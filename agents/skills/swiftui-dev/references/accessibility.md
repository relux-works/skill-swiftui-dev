# Accessibility

Rules for Dynamic Type, VoiceOver, Reduce Motion, and other accessibility requirements.

## Dynamic Type

- Do not force specific font sizes. Prefer Dynamic Type (`.font(.body)`, `.font(.headline)`, etc.).
- If you need a custom font size, use `@ScaledMetric` when targeting iOS 18 and earlier. On iOS 26+, `.font(.body.scaled(by:))` is also available.
- The font size `.caption2` is extremely small and is generally best avoided. Even `.caption` is on the small side.

## VoiceOver

- Flag images with unclear or unhelpful VoiceOver readings. If decorative, suggest `Image(decorative:)` or `accessibilityHidden()`. Otherwise attach `accessibilityLabel()`.
- Buttons with image labels must always include text, even if invisible: `Button("Label", systemImage: "plus", action: myAction)`. Flag icon-only buttons as bad for VoiceOver.
- The same applies to `Menu`: `Menu("Options", systemImage: "ellipsis.circle") { }` is better than using just an image.
- Never use `onTapGesture()` unless you specifically need tap location or tap count. All other tappable elements should be a `Button`.
- If `onTapGesture()` must be used, add `.accessibilityAddTraits(.isButton)` so VoiceOver can read it correctly.
- If buttons have complex or frequently changing labels, use `accessibilityInputLabels()` for better Voice Control commands. Example: a button showing "AAPL $271.68" should have an input label "Apple".

## Color and Motion

- If color is an important differentiator, respect `.accessibilityDifferentiateWithoutColor` by showing variation beyond color — icons, patterns, strokes.
- If the user has "Reduce Motion" enabled, replace large motion-based animations with opacity transitions instead.
