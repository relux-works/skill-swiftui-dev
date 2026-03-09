# SwiftUI Sheet and Navigation Patterns Reference

## Navigation Rules

- Use `NavigationStack` or `NavigationSplitView` as appropriate; flag all use of the deprecated `NavigationView`.
- Strongly prefer `navigationDestination(for:)` for destinations; flag `NavigationLink(destination:)`.
- Never mix `navigationDestination(for:)` and `NavigationLink(destination:)` in the same navigation hierarchy -- it causes significant problems.
- `navigationDestination(for:)` must be registered once per data type; flag duplicates.

## Sheet Patterns

### Item-Driven Sheets (Preferred)

**Use `.sheet(item:)` instead of `.sheet(isPresented:)` when presenting model-based content.**

When using `sheet(item:)` with a view that accepts the item as its only initializer parameter, prefer shorthand: `sheet(item: $item, content: SomeView.init)`.

```swift
// Good - item-driven
@State private var selectedItem: Item?

var body: some View {
    List(items) { item in
        Button(item.name) {
            selectedItem = item
        }
    }
    .sheet(item: $selectedItem) { item in
        ItemDetailSheet(item: item)
    }
}

// Good - shorthand when view takes item as sole init parameter
.sheet(item: $selectedItem, content: ItemDetailSheet.init)

// Avoid - boolean flag requires separate state
@State private var showSheet = false
@State private var selectedItem: Item?

var body: some View {
    List(items) { item in
        Button(item.name) {
            selectedItem = item
            showSheet = true
        }
    }
    .sheet(isPresented: $showSheet) {
        if let selectedItem {
            ItemDetailSheet(item: selectedItem)
        }
    }
}
```

**Why**: `.sheet(item:)` automatically handles presentation state and avoids optional unwrapping in the sheet body.

### Sheets Own Their Actions

**Sheets should handle their own dismiss and actions internally.**

```swift
// Good - sheet owns its actions
struct EditItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataStore.self) private var store

    let item: Item
    @State private var name: String
    @State private var isSaving = false

    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isSaving ? "Saving..." : "Save") {
                        Task { await save() }
                    }
                    .disabled(isSaving || name.isEmpty)
                }
            }
        }
    }

    private func save() async {
        isSaving = true
        await store.updateItem(item, name: name)
        dismiss()
    }
}

// Avoid - parent manages sheet actions via closures
struct ParentView: View {
    @State private var selectedItem: Item?

    var body: some View {
        List(items) { item in
            Button(item.name) {
                selectedItem = item
            }
        }
        .sheet(item: $selectedItem) { item in
            EditItemSheet(
                item: item,
                onSave: { newName in
                    // Parent handles save
                },
                onCancel: {
                    selectedItem = nil
                }
            )
        }
    }
}
```

**Why**: Sheets that own their actions are more reusable and don't require callback prop-drilling.

## Navigation Patterns

### Type-Safe Navigation with NavigationStack

```swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Profile", value: Route.profile)
                NavigationLink("Settings", value: Route.settings)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}

enum Route: Hashable {
    case profile
    case settings
}
```

### Programmatic Navigation

```swift
struct ContentView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Button("Go to Detail") {
                    navigationPath.append(DetailRoute.item(id: 1))
                }
            }
            .navigationDestination(for: DetailRoute.self) { route in
                switch route {
                case .item(let id):
                    ItemDetailView(id: id)
                }
            }
        }
    }
}

enum DetailRoute: Hashable {
    case item(id: Int)
}
```

### Navigation with State Restoration

```swift
struct ContentView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            RootView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        }
    }
}
```

## Presentation Modifiers

### Full Screen Cover

```swift
struct ContentView: View {
    @State private var showFullScreen = false

    var body: some View {
        Button("Show Full Screen") {
            showFullScreen = true
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenView()
        }
    }
}
```

### Popover

```swift
struct ContentView: View {
    @State private var showPopover = false

    var body: some View {
        Button("Show Popover") {
            showPopover = true
        }
        .popover(isPresented: $showPopover) {
            PopoverContentView()
                .presentationCompactAdaptation(.popover)  // Don't adapt to sheet on iPhone
        }
    }
}
```

### Alert with Actions

If an alert has only a single "OK" button that does nothing, the actions closure can be left empty: `.alert("Title", isPresented: $show) { }`.

```swift
struct ContentView: View {
    @State private var showAlert = false

    var body: some View {
        Button("Show Alert") {
            showAlert = true
        }
        .alert("Delete Item?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
                deleteItem()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
```

### Confirmation Dialog

Always attach `confirmationDialog()` to the UI element that triggers the dialog. This allows Liquid Glass animations to animate from the correct source.

```swift
struct ContentView: View {
    @State private var showDialog = false

    var body: some View {
        Button("Show Options") {
            showDialog = true
        }
        .confirmationDialog("Choose an option", isPresented: $showDialog) {
            Button("Option 1") { handleOption1() }
            Button("Option 2") { handleOption2() }
            Button("Cancel", role: .cancel) { }
        }
    }
}
```

## Summary Checklist

- [ ] Use `NavigationStack` or `NavigationSplitView`; flag deprecated `NavigationView`
- [ ] Prefer `navigationDestination(for:)` over `NavigationLink(destination:)`
- [ ] Never mix `navigationDestination(for:)` and `NavigationLink(destination:)` in the same hierarchy
- [ ] Register `navigationDestination(for:)` once per data type; flag duplicates
- [ ] Use `.sheet(item:)` for model-based sheets
- [ ] Use shorthand `sheet(item:, content: View.init)` when applicable
- [ ] Sheets own their actions and dismiss internally
- [ ] Use `NavigationStack` with `navigationDestination(for:)` for type-safe navigation
- [ ] Use `NavigationPath` for programmatic navigation
- [ ] Use appropriate presentation modifiers (sheet, fullScreenCover, popover)
- [ ] Alerts and confirmation dialogs use modern API with actions
- [ ] Omit single "OK" button from alerts when it does nothing
- [ ] Attach `confirmationDialog()` to the triggering UI element
- [ ] Avoid passing dismiss/save callbacks to sheets
- [ ] Navigation state can be saved/restored when needed
