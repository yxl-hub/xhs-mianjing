#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SKILL_SRC="$ROOT_DIR/xhs-mianjing"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SKILL_DST="$CODEX_HOME_DIR/skills/xhs-mianjing"

if [ ! -f "$SKILL_SRC/SKILL.md" ]; then
  echo "未找到 $SKILL_SRC/SKILL.md"
  exit 1
fi

mkdir -p "$SKILL_DST"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude '.DS_Store' "$SKILL_SRC"/ "$SKILL_DST"/
else
  rm -rf "$SKILL_DST"
  mkdir -p "$SKILL_DST"
  cp -R "$SKILL_SRC"/. "$SKILL_DST"/
  find "$SKILL_DST" -name '.DS_Store' -delete
fi

echo "已安装 Skill 到：$SKILL_DST"

if command -v xhs >/dev/null 2>&1; then
  echo "已检测到 xhs-cli：$(command -v xhs)"
  echo "可运行：xhs status"
else
  echo "未检测到 xhs-cli。请先安装：pipx install xiaohongshu-cli"
fi
