# skill-swiftui-dev

SwiftUI development skill for AI coding agents. Covers state management, view composition, performance, modern APIs, accessibility, HIG compliance, Swift concurrency, animations, and iOS 26+ Liquid Glass.

## What it does

When triggered, the skill guides the agent through writing, reviewing, or improving SwiftUI code using best practices distilled from two well-known open-source skills (see [Sources](#sources)).

Key capabilities:
- **Review pipeline**: 10-step review process with before/after code fixes
- **Partial review**: load only relevant reference files to save context tokens
- **Modern API enforcement**: catch deprecated patterns LLMs commonly produce
- **Accessibility first**: Dynamic Type, VoiceOver, Reduce Motion compliance
- **Performance patterns**: view composition, hot path optimization, lazy loading

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

## The Relux stack

This package is part of the Relux stack: the
[Relux](https://github.com/relux-works/swift-relux) unidirectional data-flow
architecture for Swift 6, a family of modules around it, and agent-ready testing
tools. The stack is how we build MVPs fast on agentic rails and then scale them into
enterprise-grade apps: Tuist workspaces, strict modularization, and a UDF architecture
proven in production for years. Browse the full picture in the
[Relux Works open-source catalog](https://relux.works/en/open-source/).

<!-- relux-ecosystem:start -->

## About Relux Works

This project is part of the open-source ecosystem of
[Relux Works](https://relux.works), an AI-native software development studio.
We build fixed-price MVPs, rescue vibe-coded apps, run local AI inference, and
train teams to work with coding agents. Much of the infrastructure behind that
work is open source.

- Full catalog: [relux.works/en/open-source](https://relux.works/en/open-source/)
- Agentic enablement: [agent harnesses & team training](https://relux.works/en/agentic-enablement/)
- Hire us the agent-native way: point your assistant at `https://api.relux.works/mcp`
- Contact: ivan@relux.works

<!-- relux-ecosystem:end -->

## License

MIT. See [LICENSE](LICENSE).

This is a derivative work. See [NOTICE](NOTICE) for upstream attribution.