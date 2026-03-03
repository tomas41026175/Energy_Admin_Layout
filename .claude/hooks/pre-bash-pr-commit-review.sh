#!/usr/bin/env bash
# =============================================================================
# pre-bash-pr-commit-review.sh — PreToolUse Hook for Bash
#
# 建立 PR 前自動偵測雜訊 commits
# 有問題才阻擋，乾淨則直接通過
# =============================================================================

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

# 只攔截 gh pr create
if [[ "$COMMAND" != *"gh pr create"* ]]; then
  exit 0
fi

BASE_BRANCH="main"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
COMMIT_MESSAGES=$(git log "${BASE_BRANCH}..HEAD" --format="%s" 2>/dev/null || echo "")

NOISE_FOUND=0
NOISE_ITEMS=""

# ── Rule 1: WIP / temp / fixup 關鍵字 ─────────────────────────────────────
WIP_PATTERN='(^wip[[:space:]:]|^temp[[:space:]:]|^tmp[[:space:]:]|fixup!|squash!|do.not.merge|\bdnm\b)'

while IFS= read -r msg; do
  [[ -z "$msg" ]] && continue
  if echo "$msg" | grep -iqE "$WIP_PATTERN"; then
    NOISE_FOUND=1
    NOISE_ITEMS="${NOISE_ITEMS}\n    ⚠️  WIP/暫存: ${msg}"
  fi
done <<< "$COMMIT_MESSAGES"

# ── Rule 2: Commit type 與 branch type 不符 ────────────────────────────────
# 允許的輔助 type（任何 branch 都可帶）
SECONDARY_OK="fix test docs style chore refactor perf"
BRANCH_TYPE=$(echo "$CURRENT_BRANCH" | sed 's|/.*||')

if echo "feat fix chore refactor perf build ci" | grep -qw "$BRANCH_TYPE"; then
  while IFS= read -r msg; do
    [[ -z "$msg" ]] && continue
    # 提取 commit type（conventional commits 格式）
    commit_type=$(echo "$msg" | grep -oE '^[a-z]+' | head -1 || echo "")
    [[ -z "$commit_type" ]] && continue
    [[ "$commit_type" == "$BRANCH_TYPE" ]] && continue
    if ! echo "$SECONDARY_OK" | grep -qw "$commit_type"; then
      NOISE_FOUND=1
      NOISE_ITEMS="${NOISE_ITEMS}\n    ⚠️  類型不符 [branch:${BRANCH_TYPE} commit:${commit_type}]: ${msg}"
    fi
  done <<< "$COMMIT_MESSAGES"
fi

# ── 結果輸出 ───────────────────────────────────────────────────────────────
if [[ $NOISE_FOUND -eq 1 ]]; then
  echo ""
  echo "════════════════════════════════════════════════════"
  echo "  🚫  PR Blocked — 發現雜訊 commits"
  echo "════════════════════════════════════════════════════"
  echo ""
  echo "  分支: ${CURRENT_BRANCH} → ${BASE_BRANCH}"
  echo ""
  echo "  問題:"
  echo -e "$NOISE_ITEMS"
  echo ""
  echo "  修正步驟:"
  echo "    1. git rebase -i ${BASE_BRANCH}"
  echo "       → 將雜訊 commit 標記為 drop 或 squash"
  echo "    2. git push --force-with-lease origin ${CURRENT_BRANCH}"
  echo "    3. gh pr create ...  （重新提交）"
  echo "════════════════════════════════════════════════════"
  exit 2
fi

exit 0
