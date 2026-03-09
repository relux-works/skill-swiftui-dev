---
name: swiftui-dev
description: Write, review, or improve SwiftUI code following best practices for state management, view composition, performance, modern APIs, accessibility, HIG compliance, Swift concurrency, and iOS 26+ Liquid Glass. Use when building new SwiftUI features, refactoring existing views, reviewing code quality, or adopting modern SwiftUI patterns.
---

# SwiftUI Dev Skill

## Core Instructions

- iOS 26 is the default deployment target for new apps.
- Target Swift 6.2 or later, using modern Swift concurrency.
- Prefer pure SwiftUI; avoid UIKit unless explicitly requested.
- Do not introduce third-party frameworks without asking first.
- One type per file. Feature-based folder structure.
- Report only genuine problems — do not nitpick or invent issues.
- Only document what LLMs get wrong — skip obvious patterns that any model already knows.

## Workflow Decision Tree

### 1) Review existing SwiftUI code

Run the review pipeline (all steps or partial). For partial review, load only the relevant reference files.

**Review pipeline:**

1. Deprecated API — `references/modern-apis.md`
2. View structure and composition — `references/view-structure.md`
3. State and data flow — `references/state-management.md`
4. Navigation and presentation — `references/navigation.md`
5. Design and HIG compliance — `references/design.md`
6. Accessibility — `references/accessibility.md`
7. Performance — `references/performance-patterns.md`
8. Swift code quality — `references/swift-quality.md`
9. Animations — `references/animation-basics.md`, `references/animation-transitions.md`, `references/animation-advanced.md`
10. Liquid Glass (iOS 26+) — `references/liquid-glass.md`

**Output format:** Organize findings by file. For each issue:

1. State the file and relevant line(s).
2. Name the rule being violated.
3. Show a brief before/after code fix.

Skip files with no issues. End with a prioritized summary.

Example:

```
### ContentView.swift

**Line 12: Use `foregroundStyle()` instead of `foregroundColor()`.**

// Before
Text("Hello").foregroundColor(.red)

// After
Text("Hello").foregroundStyle(.red)

### Summary

1. **Accessibility (high):** The add button on line 24 is invisible to VoiceOver.
2. **Deprecated API (medium):** `foregroundColor()` on line 12.
```

### 2) Improve existing SwiftUI code

- Audit state management for correct wrapper selection — prefer `@Observable` over `ObservableObject` (see `references/state-management.md`)
- Replace deprecated APIs with modern equivalents (see `references/modern-apis.md`)
- Extract complex views into separate subviews (see `references/view-structure.md`)
- Refactor hot paths to minimize redundant state updates (see `references/performance-patterns.md`)
- Ensure ForEach uses stable identity (see `references/list-patterns.md`)
- Improve animation patterns (see `references/animation-basics.md`, `references/animation-transitions.md`)
- Validate accessibility compliance (see `references/accessibility.md`)
- Suggest image downsampling when `UIImage(data:)` is used (see `references/image-optimization.md`)

### 3) Implement new SwiftUI features

- Choose property wrappers using the selection guide (see `references/state-management.md`)
- Follow view composition patterns (see `references/view-structure.md`)
- Use modern APIs from the start (see `references/modern-apis.md`)
- Apply correct navigation patterns (see `references/navigation.md`)
- Apply layout best practices (see `references/layout-best-practices.md`)
- Format text and numbers correctly (see `references/text-formatting.md`)
- Implement scroll behaviors properly (see `references/scroll-patterns.md`)
- Meet accessibility requirements from day one (see `references/accessibility.md`)
- Follow HIG design guidelines (see `references/design.md`)

## Quick Reference: Property Wrapper Selection

| Wrapper | Use When |
|---------|----------|
| `@State private var` | View owns the value (simple or `@Observable` class) |
| `@Binding var` | Child needs to **modify** parent's state |
| `@Bindable var` | Injected `@Observable` object needing bindings (iOS 17+) |
| `let` | Read-only value from parent |
| `@Environment(MyType.self)` | Shared `@Observable` via environment (iOS 17+) |

## Quick Reference: Modern API Replacements

| Deprecated | Modern |
|------------|--------|
| `foregroundColor()` | `foregroundStyle()` |
| `cornerRadius()` | `clipShape(.rect(cornerRadius:))` |
| `tabItem()` | `Tab` API |
| `NavigationView` | `NavigationStack` / `NavigationSplitView` |
| `NavigationLink(destination:)` | `navigationDestination(for:)` |
| `GeometryReader` | `containerRelativeFrame()` / `visualEffect()` / `Layout` |
| `onTapGesture()` (basic) | `Button` |
| `onChange(of:perform:)` (1-param) | `onChange(of:) {}` or `onChange(of:) { old, new in }` |
| `.navigationBarLeading/Trailing` | `.topBarLeading` / `.topBarTrailing` |
| `overlay(_:alignment:)` | `overlay(alignment:content:)` / `overlay { }` |
| `TextEditor` | `TextField(axis: .vertical)` (unless full-screen editing) |
| `PreviewProvider` | `#Preview` |
| `UIImpactFeedbackGenerator` | `sensoryFeedback()` |
| `DispatchQueue` / GCD | Swift concurrency (`async`/`await`, actors) |

## References

- `references/state-management.md` — Property wrappers, `@Observable`, data flow, bindings
- `references/modern-apis.md` — Modern API replacements, deprecated patterns
- `references/view-structure.md` — View composition, extraction, container patterns
- `references/performance-patterns.md` — State update optimization, lazy loading, hot paths
- `references/navigation.md` — NavigationStack, sheets, alerts, confirmation dialogs
- `references/accessibility.md` — Dynamic Type, VoiceOver, Reduce Motion
- `references/design.md` — HIG compliance, uniform design, tap targets
- `references/swift-quality.md` — Modern Swift patterns, concurrency, formatting
- `references/animation-basics.md` — Core animation concepts, implicit/explicit, timing
- `references/animation-transitions.md` — Property animations, transitions, Animatable
- `references/animation-advanced.md` — Phase/keyframe animations (iOS 17+), transactions
- `references/liquid-glass.md` — iOS 26+ Liquid Glass API
- `references/image-optimization.md` — AsyncImage, downsampling, SF Symbols
- `references/layout-best-practices.md` — Relative layout, geometry gating, testable view logic
- `references/list-patterns.md` — ForEach identity, custom list styling, pull-to-refresh
- `references/scroll-patterns.md` — Scroll position, transitions, paging, snap
- `references/text-formatting.md` — Number/date/currency formatting, AttributedString

## Upstream Sources

This skill merges best practices from:
- [AvdLee/SwiftUI-Agent-Skill](https://github.com/AvdLee/SwiftUI-Agent-Skill) (Antoine van der Lee)
- [twostraws/SwiftUI-Agent-Skill](https://github.com/twostraws/SwiftUI-Agent-Skill) (Paul Hudson)

See `SOURCES.md` in the repo root for detailed provenance and update instructions.

## Philosophy

- Facts-based, not architecture-opinionated
- Only document what LLMs commonly get wrong — skip the obvious
- Prioritize modern APIs, accessibility, and performance
- Keep references concise to save context window tokens
