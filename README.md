# skill-swiftui-dev

SwiftUI development skill for AI coding agents. Covers state management, view composition, performance, modern APIs, accessibility, HIG compliance, Swift concurrency, animations, and iOS 26+ Liquid Glass.

## What it does

When triggered, the skill guides the agent through writing, reviewing, or improving SwiftUI code using best practices distilled from two well-known open-source skills (see [Sources](#sources)).

Key capabilities:
- **Review pipeline** — 10-step review process with before/after code fixes
- **Partial review** — load only relevant reference files to save context tokens
- **Modern API enforcement** — catch deprecated patterns LLMs commonly produce
- **Accessibility first** — Dynamic Type, VoiceOver, Reduce Motion compliance
- **Performance patterns** — view composition, hot path optimization, lazy loading

## Installation

```bash
./setup.sh
```

This copies the skill to `~/.agents/skills/swiftui-dev/` and creates symlinks in `~/.claude/skills/` and `~/.codex/skills/`.

## Skill Structure

```
agents/skills/swiftui-dev/
├── SKILL.md                          # Main skill definition
└── references/
    ├── state-management.md           # Property wrappers, @Observable, data flow
    ├── modern-apis.md                # Modern API replacements
    ├── view-structure.md             # View composition, extraction patterns
    ├── performance-patterns.md       # Optimization, hot paths, lazy loading
    ├── navigation.md                 # NavigationStack, sheets, alerts
    ├── accessibility.md              # Dynamic Type, VoiceOver, Reduce Motion
    ├── design.md                     # HIG compliance, tap targets, styling
    ├── swift-quality.md              # Modern Swift, concurrency, formatting
    ├── animation-basics.md           # Core animation concepts
    ├── animation-transitions.md      # Transitions, Animatable protocol
    ├── animation-advanced.md         # Phase/keyframe animations (iOS 17+)
    ├── liquid-glass.md               # iOS 26+ Liquid Glass API
    ├── image-optimization.md         # AsyncImage, downsampling, SF Symbols
    ├── layout-best-practices.md      # Relative layout, geometry gating
    ├── list-patterns.md              # ForEach identity, custom styling
    ├── scroll-patterns.md            # Scroll position, paging, snap
    └── text-formatting.md            # Number/date/currency, AttributedString
```

## Sources

This skill merges best practices from:

| Source | Author | Focus |
|--------|--------|-------|
| [AvdLee/SwiftUI-Agent-Skill](https://github.com/AvdLee/SwiftUI-Agent-Skill) | Antoine van der Lee | General SwiftUI development |
| [twostraws/SwiftUI-Agent-Skill](https://github.com/twostraws/SwiftUI-Agent-Skill) | Paul Hudson | SwiftUI code review |

See [SOURCES.md](SOURCES.md) for detailed provenance per reference file and update instructions.

## Tools

| Tool | Purpose | Command |
|------|---------|---------|
| `setup.sh` | Install skill globally | `./setup.sh` |

## License

Apache 2.0 — see [LICENSE](LICENSE).

This is a derivative work. See [NOTICE](NOTICE) for upstream attribution.
