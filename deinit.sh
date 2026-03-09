#!/usr/bin/env zsh
#
# Deinit script for swiftui-dev skill.
# Removes installed skill and symlinks. Does NOT touch upstream repos.
#

set -euo pipefail

SKILL_NAME="swiftui-dev"

AGENTS_DIR="$HOME/.agents/skills"
CLAUDE_DIR="$HOME/.claude/skills"
CODEX_DIR="$HOME/.codex/skills"

# --- Colors ---
red()   { print -P "%F{red}$1%f" }
green() { print -P "%F{green}$1%f" }
yellow(){ print -P "%F{yellow}$1%f" }

# --- 1. Remove symlinks ---
remove_symlink() {
  local link="$1"
  if [[ -L "$link" ]]; then
    rm "$link"
    green "Removed symlink: $link"
  elif [[ -e "$link" ]]; then
    yellow "Skipping $link (not a symlink)"
  fi
}

remove_symlinks() {
  remove_symlink "$CLAUDE_DIR/$SKILL_NAME"
  remove_symlink "$CODEX_DIR/$SKILL_NAME"
}

# --- 2. Remove installed copy ---
remove_installed() {
  local dest="$AGENTS_DIR/$SKILL_NAME"
  if [[ -d "$dest" ]] && [[ ! -L "$dest" ]]; then
    rm -rf "$dest"
    green "Removed: $dest"
  elif [[ -L "$dest" ]]; then
    rm -f "$dest"
    green "Removed symlink: $dest"
  else
    yellow "Not found: $dest"
  fi
}

# --- 3. Verify ---
verify_clean() {
  local clean=true

  for dir in "$AGENTS_DIR/$SKILL_NAME" "$CLAUDE_DIR/$SKILL_NAME" "$CODEX_DIR/$SKILL_NAME"; do
    if [[ -e "$dir" ]] || [[ -L "$dir" ]]; then
      red "WARN: still exists: $dir"
      clean=false
    fi
  done

  if $clean; then
    green "All clean!"
  fi
}

# --- Run ---
print ""
green "=== swiftui-dev skill deinit ==="
print ""
remove_symlinks
remove_installed
verify_clean
print ""
green "=== Done ==="
