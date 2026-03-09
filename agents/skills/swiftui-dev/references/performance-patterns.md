# SwiftUI Performance Patterns Reference

## Performance Optimization

### 1. Avoid Redundant State Updates

SwiftUI doesn't compare values before triggering updates:

```swift
// BAD - triggers update even if value unchanged
.onReceive(publisher) { value in
    self.currentValue = value  // Always triggers body re-evaluation
}

// GOOD - only update when different
.onReceive(publisher) { value in
    if self.currentValue != value {
        self.currentValue = value
    }
}
```

### 2. Optimize Hot Paths

Hot paths are frequently executed code (scroll handlers, animations, gestures):

```swift
// BAD - updates state on every scroll position change
.onPreferenceChange(ScrollOffsetKey.self) { offset in
    shouldShowTitle = offset.y <= -32  // Fires constantly during scroll!
}

// GOOD - only update when threshold crossed
.onPreferenceChange(ScrollOffsetKey.self) { offset in
    let shouldShow = offset.y <= -32
    if shouldShow != shouldShowTitle {
        shouldShowTitle = shouldShow  // Fires only when crossing threshold
    }
}
```

### 3. Ternary Over Branching for Modifier Values

When toggling modifier values, prefer ternary expressions over if/else view branching to avoid `_ConditionalContent`, preserve structural identity, and avoid repeatedly recreating underlying platform views.

```swift
// Good - ternary
Text("Hello")
    .foregroundStyle(isActive ? .blue : .gray)

// Avoid - branching creates _ConditionalContent
if isActive {
    Text("Hello").foregroundStyle(.blue)
} else {
    Text("Hello").foregroundStyle(.gray)
}
```

### 4. Pass Only What Views Need

**Avoid passing large "config" or "context" objects.** Pass only the specific values each view needs.

```swift
// Good - pass specific values
@Observable
@MainActor
final class AppConfig {
    var theme: Theme
    var fontSize: CGFloat
    var notifications: Bool
}

struct SettingsView: View {
    @State private var config = AppConfig()

    var body: some View {
        VStack {
            ThemeSelector(theme: config.theme)
            FontSizeSlider(fontSize: config.fontSize)
        }
    }
}

// Avoid - passing entire config
struct SettingsView: View {
    @State private var config = AppConfig()

    var body: some View {
        VStack {
            ThemeSelector(config: config)  // Gets notified of ALL config changes
            FontSizeSlider(config: config)  // Gets notified of ALL config changes
        }
    }
}
```

**Why**: When using `ObservableObject`, any `@Published` property change triggers updates in all views observing the object. With `@Observable`, views update when properties they access change, but passing entire objects still creates unnecessary dependencies.

### 5. Use Equatable Views

For views with expensive bodies, conform to `Equatable`:

```swift
struct ExpensiveView: View, Equatable {
    let data: SomeData

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data.id == rhs.data.id  // Custom equality check
    }

    var body: some View {
        // Expensive computation
    }
}

// Usage
ExpensiveView(data: data)
    .equatable()  // Use custom equality
```

**Caution**: If you add new state or dependencies to your view, remember to update your `==` function!

### 6. POD Views for Fast Diffing

**POD (Plain Old Data) views use `memcmp` for fastest diffing.** A view is POD if it only contains simple value types and no property wrappers.

```swift
// POD view - fastest diffing
struct FastView: View {
    let title: String
    let count: Int

    var body: some View {
        Text("\(title): \(count)")
    }
}

// Non-POD view - uses reflection or custom equality
struct SlowerView: View {
    let title: String
    @State private var isExpanded = false  // Property wrapper makes it non-POD

    var body: some View {
        Text(title)
    }
}
```

**Advanced Pattern**: Wrap expensive non-POD views in POD parent views:

```swift
// POD wrapper for fast diffing
struct ExpensiveView: View {
    let value: Int

    var body: some View {
        ExpensiveViewInternal(value: value)
    }
}

// Internal view with state
private struct ExpensiveViewInternal: View {
    let value: Int
    @State private var item: Item?

    var body: some View {
        // Expensive rendering
    }
}
```

**Why**: The POD parent uses fast `memcmp` comparison. Only when `value` changes does the internal view get diffed.

### 7. Lazy Loading

Use lazy containers for large collections:

```swift
// BAD - creates all views immediately
ScrollView {
    VStack {
        ForEach(items) { item in
            ExpensiveRow(item: item)
        }
    }
}

// GOOD - creates views on demand
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ExpensiveRow(item: item)
        }
    }
}
```

### 8. Scroll Background Optimization

If a `ScrollView` has an opaque, static, solid background, use `scrollContentBackground(.visible)` to improve scroll-edge rendering efficiency.

### 9. Avoid Inline Formatters

Do not create formatter properties unless required. Prefer `Text` with built-in format:

```swift
// Good
Text(Date.now, format: .dateTime.day().month().year())
Text(100, format: .currency(code: "USD"))

// Avoid
let formatter = DateFormatter()
```

### 10. Prefer task() Over onAppear()

Use `task()` over `onAppear()` for async work -- it cancels automatically on view disappear.

### 11. Task Cancellation

Cancel async work when view disappears:

```swift
struct DataView: View {
    @State private var data: [Item] = []

    var body: some View {
        List(data) { item in
            Text(item.name)
        }
        .task {
            // Automatically cancelled when view disappears
            data = await fetchData()
        }
    }
}
```

### 12. Derived Data Caching

Prefer deriving transformed data from the source of truth using `let`, or caching in `@State`. But do not cache derived collections in `@State` unless you also own explicit invalidation logic to avoid stale UI.

### 13. Avoid Expensive Inline Transforms

Avoid expensive inline transforms in `List`/`ForEach` initializers (e.g. `items.filter { ... }`) when they run frequently.

### 14. Debug View Updates

**Use `Self._printChanges()` to debug unexpected view updates.**

```swift
struct DebugView: View {
    @State private var count = 0
    @State private var name = ""

    var body: some View {
        let _ = Self._printChanges()  // Prints what caused body to be called

        VStack {
            Text("Count: \(count)")
            Text("Name: \(name)")
        }
    }
}
```

**Why**: This helps identify which state changes are causing view updates. Even if a parent updates, a child's body shouldn't be called if the child's dependencies didn't change.

### 15. Eliminate Unnecessary Dependencies

**Narrow state scope to reduce update fan-out.**

```swift
// Bad - broad dependency
@Observable
@MainActor
final class AppModel {
    var items: [Item] = []
    var settings: Settings = .init()
    var theme: Theme = .light
}

struct ItemRow: View {
    @Environment(AppModel.self) private var model
    let item: Item

    var body: some View {
        // Updates when ANY property of model changes
        Text(item.name)
            .foregroundStyle(model.theme.primaryColor)
    }
}

// Good - narrow dependency
struct ItemRow: View {
    let item: Item
    let themeColor: Color  // Only depends on what it needs

    var body: some View {
        Text(item.name)
            .foregroundStyle(themeColor)
    }
}
```

**Why**: With `ObservableObject`, any `@Published` property change triggers all observers. With `@Observable`, views update when accessed properties change, but passing entire models still creates broader dependencies than necessary.

### 16. Common Performance Issues

**Be aware of common performance bottlenecks in SwiftUI:**

- View invalidation storms from broad state changes
- Unstable identity in lists causing excessive diffing
- Heavy work in `body` (formatting, sorting, image decoding)
- Layout thrash from deep stacks or preference chains

**When performance issues arise**, suggest the user profile with Instruments (SwiftUI template) to identify specific bottlenecks.

## Anti-Patterns

### 1. Creating Objects in Body

```swift
// BAD - creates new formatter every body call
var body: some View {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return Text(formatter.string(from: date))
}

// GOOD - static or stored formatter
private static let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .long
    return f
}()

var body: some View {
    Text(Self.dateFormatter.string(from: date))
}
```

### 2. Heavy Computation in Body

**Keep view body simple and pure.** Avoid side effects, dispatching, or complex logic.

```swift
// BAD - sorts array every body call
var body: some View {
    List(items.sorted { $0.name < $1.name }) { item in
        Text(item.name)
    }
}

// GOOD - compute once, store result
@State private var sortedItems: [Item] = []

var body: some View {
    List(sortedItems) { item in
        Text(item.name)
    }
    .onChange(of: items) { _, newItems in
        sortedItems = newItems.sorted { $0.name < $1.name }
    }
}

// Better - compute in model
@Observable
@MainActor
final class ItemsViewModel {
    var items: [Item] = []

    var sortedItems: [Item] {
        items.sorted { $0.name < $1.name }
    }

    func loadItems() async {
        items = await fetchItems()
    }
}

struct ItemsView: View {
    @State private var viewModel = ItemsViewModel()

    var body: some View {
        List(viewModel.sortedItems) { item in
            Text(item.name)
        }
        .task {
            await viewModel.loadItems()
        }
    }
}
```

**Why**: Complex logic in `body` slows down view updates and can cause frame drops. The `body` should be a pure structural representation of state.

### 3. Unnecessary State

```swift
// BAD - derived state stored separately
@State private var items: [Item] = []
@State private var itemCount: Int = 0  // Unnecessary!

// GOOD - compute derived values
@State private var items: [Item] = []

var itemCount: Int { items.count }  // Computed property
```

### 4. Store Built Views, Not Closures

Avoid storing escaping `@ViewBuilder` closures on views; store built view results instead:

```swift
// Anti-pattern: stores escaping closure
struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack { content() }
    }
}

// Preferred: stores built view value
struct CardView<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        VStack { content }
    }
}
```

## Summary Checklist

- [ ] State updates check for value changes before assigning
- [ ] Hot paths minimize state updates
- [ ] Ternary expressions used over if/else branching for modifier values
- [ ] Pass only needed values to views (avoid large config objects)
- [ ] Large lists use `LazyVStack`/`LazyHStack`
- [ ] No object creation in `body`
- [ ] Heavy computation moved out of `body`
- [ ] Body kept simple and pure (no side effects)
- [ ] Derived state computed, not stored
- [ ] Use `Self._printChanges()` to debug unexpected updates
- [ ] Equatable conformance for expensive views (when appropriate)
- [ ] Consider POD view wrappers for advanced optimization
- [ ] Prefer `Text` built-in format over inline formatters
- [ ] Use `task()` over `onAppear()` for async work
- [ ] Avoid expensive inline transforms in `List`/`ForEach`
- [ ] Use `scrollContentBackground(.visible)` for opaque scroll backgrounds
- [ ] Derived data cached only with explicit invalidation logic
- [ ] Store built view values, not escaping `@ViewBuilder` closures
