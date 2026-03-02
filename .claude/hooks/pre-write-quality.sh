#!/usr/bin/env bash
# =============================================================================
# pre-write-quality.sh — PostToolUse Hook for Write/Edit
#
# 在 Claude 寫入/編輯 .ts/.tsx 檔案後執行品質檢查
# 目的：在問題進入 git 前即時發現
#
# 輸出：
#   exit 0 → 品質通過（Claude 繼續）
#   exit 2 → 品質問題（阻斷 Claude，強制修正）
# =============================================================================

set -euo pipefail

# ── 讀取被修改的檔案（從 stdin 接收 Claude hook JSON）────────────────────────
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

# 只處理 TypeScript/TSX 檔案
if [[ "$FILE_PATH" != *.ts && "$FILE_PATH" != *.tsx ]]; then
  exit 0
fi

# 確認檔案在 Energy_Admin 目錄內（project layer）
if [[ "$FILE_PATH" != */Energy_Admin/* && "$FILE_PATH" != */src/* ]]; then
  exit 0
fi

echo "[Quality Check] 檢查: $FILE_PATH"

ERRORS=()

# ── 1. 禁止 any ─────────────────────────────────────────────────────────────
if grep -n ": any" "$FILE_PATH" 2>/dev/null | grep -v "// ok-any" | grep -q .; then
  ERRORS+=("❌ 發現禁止的 'any' 型別（用 unknown + type guard 替代）")
fi

# ── 2. 禁止 console.log ──────────────────────────────────────────────────────
if grep -n "console\.log" "$FILE_PATH" 2>/dev/null | grep -v "// ok-log" | grep -q .; then
  ERRORS+=("❌ 發現 console.log（提交前必須移除）")
fi

# ── 3. useEffect 過度使用偵測 ─────────────────────────────────────────────────
EFFECT_COUNT=$(grep -c "useEffect" "$FILE_PATH" 2>/dev/null || echo 0)
if [[ "$EFFECT_COUNT" -gt 2 ]]; then
  ERRORS+=("⚠️  偵測到 ${EFFECT_COUNT} 個 useEffect（應優先使用 TanStack Query / useMemo 替代）")
fi

# ── 4. 禁止直接 fetch/axios（應透過 API layer）───────────────────────────────
if grep -n "axios\.\(get\|post\|put\|delete\)" "$FILE_PATH" 2>/dev/null | grep -v "shared/api" | grep -v "\.api\.ts" | grep -q .; then
  ERRORS+=("❌ 直接呼叫 axios（應透過 shared/api/client 或 domain API layer）")
fi

# ── 5. 檢查 TODO 遺留 ─────────────────────────────────────────────────────────
TODO_COUNT=$(grep -c "TODO\|FIXME\|HACK" "$FILE_PATH" 2>/dev/null || echo 0)
if [[ "$TODO_COUNT" -gt 0 ]]; then
  ERRORS+=("⚠️  發現 ${TODO_COUNT} 個 TODO/FIXME（需在 Phase 完成前處理）")
fi

# ── 輸出結果 ─────────────────────────────────────────────────────────────────
if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo ""
  echo "════════════════════════════════════════"
  echo "  ⚠️  品質檢查發現問題"
  echo "════════════════════════════════════════"
  for err in "${ERRORS[@]}"; do
    echo "  $err"
  done
  echo ""

  # 只有 ❌ 錯誤才阻斷（⚠️ 警告只提示）
  HAS_ERROR=false
  for err in "${ERRORS[@]}"; do
    if [[ "$err" == ❌* ]]; then
      HAS_ERROR=true
      break
    fi
  done

  if [[ "$HAS_ERROR" == true ]]; then
    echo "  → 請修正 ❌ 錯誤後再繼續"
    echo "════════════════════════════════════════"
    exit 2
  else
    echo "  → 警告僅供參考，可繼續"
    echo "════════════════════════════════════════"
    exit 0
  fi
fi

echo "[Quality Check] ✅ 通過"
exit 0
