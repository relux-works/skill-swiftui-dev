# Swift Code Quality

Rules for writing modern, clean Swift code.

## Modern Swift Patterns

- Prefer Swift-native string methods: `replacing("a", with: "b")` not `replacingOccurrences(of: "a", with: "b")`.
- Use modern Foundation API: `URL.documentsDirectory` instead of `FileManager` lookups, `appending(path:)` for URL paths.
- Never use C-style formatting like `String(format: "%.2f", value)`. Use `FormatStyle` APIs: `Text(value, format: .number.precision(.fractionLength(2)))`.
- Prefer static member lookup: `.circle` not `Circle()`, `.borderedProminent` not `BorderedProminentButtonStyle()`.
- Avoid force unwraps (`!`) and force `try`. Prefer `if let`, `guard let`, nil-coalescing, or `do-catch`. If failure is truly unrecoverable, use `fatalError()` with a description.
- Use `localizedStandardContains()` for user-input filtering, not `contains()` or `localizedCaseInsensitiveContains()`.
- Prefer `Double` over `CGFloat` except when using optionals or `inout`.
- Use `count(where:)` not `filter().count`.
- Prefer `Date.now` over `Date()`.
- When `import SwiftUI` is present, you do not need `import UIKit`/`import AppKit` — they're imported automatically.
- Use `PersonNameComponents` with formatting for people's names, not string interpolation.
- If a sort closure is repeated, make the type conform to `Comparable` instead.
- Prefer `if let value {` shorthand over `if let value = value {`.
- Omit `return` for single-expression functions. Use `if`/`switch` as expressions:

```swift
// Prefer
var tileColor: Color {
    if isCorrect { .green } else { .red }
}

// Avoid
var tileColor: Color {
    if isCorrect {
        return .green
    } else {
        return .red
    }
}
```

## Date and Number Formatting

- Avoid manual date formatting strings when possible. If manual formatting is needed for display, use "y" not "yyyy" for correct localization.
- For string-to-date conversion, prefer `Date(myString, strategy: .iso8601)`.
- Flag silently swallowed errors (e.g. `print(error.localizedDescription)` instead of showing an alert).

## Swift Concurrency

- Always prefer `async`/`await` over closure-based APIs when both exist.
- Never use GCD (`DispatchQueue.main.async()`, `DispatchQueue.global()`). Use Swift concurrency.
- Never use `Task.sleep(nanoseconds:)` — use `Task.sleep(for:)`.
- Flag mutable shared state not protected by an actor or `@MainActor`, unless the project uses MainActor default isolation.
- Assume strict concurrency rules. Flag `@Sendable` violations and data races.
- Check project default actor isolation before flagging `MainActor.run()` as unnecessary.
- `Task.detached()` is often a bad idea. Check any usage carefully.
