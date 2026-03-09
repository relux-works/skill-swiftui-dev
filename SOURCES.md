# Upstream Sources

This skill merges best practices from two open-source SwiftUI agent skills. Check these repos periodically for updates.

## Sources

| Source | Author | Repo | Focus |
|--------|--------|------|-------|
| swiftui-expert-skill | Antoine van der Lee (AvdLee) | [AvdLee/SwiftUI-Agent-Skill](https://github.com/AvdLee/SwiftUI-Agent-Skill) | General SwiftUI development: state, views, performance, animations, Liquid Glass |
| swiftui-pro | Paul Hudson (twostraws) | [twostraws/SwiftUI-Agent-Skill](https://github.com/twostraws/SwiftUI-Agent-Skill) | SwiftUI code review: modern APIs, accessibility, HIG, Swift quality |

## Reference File Provenance

| Reference | Primary Source | Merged From |
|-----------|---------------|-------------|
| `state-management.md` | AvdLee | + twostraws `data.md` |
| `modern-apis.md` | AvdLee | + twostraws `api.md` |
| `view-structure.md` | AvdLee | + twostraws `views.md` |
| `performance-patterns.md` | AvdLee | + twostraws `performance.md` |
| `navigation.md` | AvdLee `sheet-navigation-patterns.md` | + twostraws `navigation.md` |
| `accessibility.md` | twostraws | — |
| `design.md` | twostraws | — |
| `swift-quality.md` | twostraws `swift.md` | — |
| `animation-basics.md` | AvdLee | — |
| `animation-transitions.md` | AvdLee | — |
| `animation-advanced.md` | AvdLee | — |
| `liquid-glass.md` | AvdLee | — |
| `image-optimization.md` | AvdLee | — |
| `layout-best-practices.md` | AvdLee | — |
| `list-patterns.md` | AvdLee | — |
| `scroll-patterns.md` | AvdLee | — |
| `text-formatting.md` | AvdLee | — |

## Update Process

1. Check upstream repos for new commits / releases
2. Compare changed reference files against ours
3. Merge relevant additions into the corresponding file
4. Update this table if provenance changes
