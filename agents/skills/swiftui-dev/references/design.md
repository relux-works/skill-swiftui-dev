# Design and HIG Compliance

Rules for building apps that meet Apple's Human Interface Guidelines.

## Uniform Design

- Place standard fonts, sizes, colors, spacing, padding, rounding, and animation timings into a shared constants enum. This keeps the app's design uniform and easy to adjust.

## Flexible Layout

- Never use `UIScreen.main.bounds` to read available space. Prefer `containerRelativeFrame()`, `visualEffect()`, or (last resort) `GeometryReader`.
- Avoid fixed frames unless content fits neatly inside. Give frames flexibility for different device sizes and Dynamic Type settings.
- Apple's minimum acceptable tap area for interactions is 44x44. Enforce strictly.

## System Styling

- Use `ContentUnavailableView` for empty/missing data states. With `searchable()`, use `ContentUnavailableView.search` — it includes the search term automatically.
- If you need an icon + text side by side, prefer `Label` over `HStack`.
- Prefer system hierarchical styles (secondary/tertiary) over manual opacity for adaptive styling.
- Wrap controls like `Slider` in `LabeledContent` inside `Form` for correct title + control layout.
- `RoundedRectangle` defaults to `.continuous` rounding — no need to specify.

## Typography

- Use `bold()` instead of `fontWeight(.bold)` — it lets the system choose the correct weight for context.
- Only use `fontWeight()` for weights other than bold when there's an important reason.
- Avoid hard-coded padding and spacing unless specifically requested.
- Avoid UIKit colors (`UIColor`) in SwiftUI code; use SwiftUI `Color` or asset catalog colors.
