#!/usr/bin/env bash
# =============================================================================
# pre-bash-branch-guard.sh — PreToolUse Hook for Bash
#
# 防止 Claude 在 main 分支上執行 git commit
# 確保所有實作發生在 feature branch
# =============================================================================

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# 只攔截 git commit 相關指令
if [[ "$COMMAND" != *"git commit"* ]]; then
  exit 0
fi

# 確認目前分支
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
  echo ""
  echo "════════════════════════════════════════"
  echo "  🚫  Branch Guard: 禁止在 main 上 commit"
  echo "════════════════════════════════════════"
  echo ""
  echo "  目前分支: main"
  echo ""
  echo "  請先建立 feature branch："
  echo "    git checkout -b feat/{description}"
  echo "    git checkout -b fix/{description}"
  echo ""
  echo "  若為並行任務，請使用 worktree："
  echo "    git worktree add .worktrees/feat-xxx feat/xxx"
  echo "════════════════════════════════════════"
  exit 2
fi

exit 0
