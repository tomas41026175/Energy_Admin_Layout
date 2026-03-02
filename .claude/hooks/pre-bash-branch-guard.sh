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

# 攔截 git commit 與 force push
IS_COMMIT=false
IS_FORCE_PUSH=false

[[ "$COMMAND" == *"git commit"* ]] && IS_COMMIT=true
# 注意：--force-with-lease 包含 --force，但在 feature branch 上會被正確放行
[[ "$COMMAND" == *"git push"* ]] && [[ "$COMMAND" == *"--force"* || "$COMMAND" == *" -f "* || "$COMMAND" == *" -f" ]] && IS_FORCE_PUSH=true

if [[ "$IS_COMMIT" == false && "$IS_FORCE_PUSH" == false ]]; then
  exit 0
fi

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

# ── Force push to main/master ─────────────────────────────────────────────
if [[ "$IS_FORCE_PUSH" == true ]]; then
  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" || "$COMMAND" == *" main"* || "$COMMAND" == *" master"* ]]; then
    echo ""
    echo "════════════════════════════════════════"
    echo "  🚫  Branch Guard: 禁止 force push 到 main"
    echo "════════════════════════════════════════"
    echo ""
    echo "  永遠不要 force push 到 main / master"
    echo "════════════════════════════════════════"
    exit 2
  fi
fi

# ── Commit on main/master ─────────────────────────────────────────────────
if [[ "$IS_COMMIT" == true ]]; then
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
fi

exit 0
