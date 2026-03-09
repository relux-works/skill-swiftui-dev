#!/usr/bin/env zsh
#
# Setup script for swiftui-dev skill.
# Copies skill into ~/.agents/skills/, symlinks to .claude and .codex.
# Optionally removes the old swiftui-expert-skill it replaces.
#

set -euo pipefail

SKILL_NAME="swiftui-dev"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_CONTENT_DIR="$REPO_DIR/agents/skills/swiftui-dev"

AGENTS_DIR="$HOME/.agents/skills"
CLAUDE_DIR="$HOME/.claude/skills"
CODEX_DIR="$HOME/.codex/skills"

# Old skill this one replaces
OLD_SKILL_NAME="swiftui"

# --- Colors ---
red()   { print -P "%F{red}$1%f" }
green() { print -P "%F{green}$1%f" }
yellow(){ print -P "%F{yellow}$1%f" }

# --- 1. Remove old swiftui-expert-skill if present ---
remove_old_skill() {
  for dir in "$AGENTS_DIR/$OLD_SKILL_NAME" "$CLAUDE_DIR/$OLD_SKILL_NAME" "$CODEX_DIR/$OLD_SKILL_NAME"; do
    if [[ -L "$dir" ]]; then
      rm -f "$dir"
      yellow "Removed old symlink: $dir"
    elif [[ -d "$dir" ]]; then
      rm -rf "$dir"
      yellow "Removed old directory: $dir"
    fi
  done
}

# --- 2. Copy skill into ~/.agents/skills/ ---
install_skill() {
  if [[ -L "$AGENTS_DIR/$SKILL_NAME" ]]; then
    rm -f "$AGENTS_DIR/$SKILL_NAME"
    yellow "Removed stale symlink: $AGENTS_DIR/$SKILL_NAME"
  fi

  mkdir -p "$AGENTS_DIR/$SKILL_NAME"
  rsync -a --delete "$SKILL_CONTENT_DIR/" "$AGENTS_DIR/$SKILL_NAME/" --exclude='.git'
  green "Copied skill -> $AGENTS_DIR/$SKILL_NAME/"
}

# --- 3. Symlink to tool directories ---
symlink_skill() {
  local tool_dir="$1"
  mkdir -p "$tool_dir"

  if [[ -L "$tool_dir/$SKILL_NAME" ]]; then
    rm -f "$tool_dir/$SKILL_NAME"
  elif [[ -d "$tool_dir/$SKILL_NAME" ]]; then
    rm -rf "$tool_dir/$SKILL_NAME"
  fi

  ln -s "$AGENTS_DIR/$SKILL_NAME" "$tool_dir/$SKILL_NAME"
  green "Symlink: $tool_dir/$SKILL_NAME -> $AGENTS_DIR/$SKILL_NAME"
}

# --- 4. Verify ---
verify() {
  if [[ -f "$AGENTS_DIR/$SKILL_NAME/SKILL.md" ]]; then
    local refs
    refs=$(ls -1 "$AGENTS_DIR/$SKILL_NAME/references/" 2>/dev/null | wc -l | tr -d ' ')
    green "Verified: SKILL.md + $refs reference files"
  else
    red "SKILL.md not found in $AGENTS_DIR/$SKILL_NAME/"
  fi
}

# --- Run ---
print ""
green "=== swiftui-dev skill setup ==="
print ""
remove_old_skill
install_skill
symlink_skill "$CLAUDE_DIR"
symlink_skill "$CODEX_DIR"
verify
print ""
local version
version=$(git -C "$REPO_DIR" describe --tags --always 2>/dev/null || echo "unknown")
green "=== Done. Installed $version ==="
