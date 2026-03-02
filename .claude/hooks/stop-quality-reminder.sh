#!/usr/bin/env bash
# =============================================================================
# stop-quality-reminder.sh — Stop Hook
#
# Claude 完成回應前，提醒必要的品質檢查項目
# =============================================================================

INPUT=$(cat)
STOP_REASON=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('stop_reason',''))" 2>/dev/null || echo "")

# 只在正常完成時提醒（非 tool_use 中斷）
if [[ "$STOP_REASON" != "end_turn" ]]; then
  exit 0
fi

# 簡短的品質檢查清單
cat << 'EOF'

─────────────────────────────────────
 📋 完成前確認清單
─────────────────────────────────────
 □ 在 feature branch（非 main）
 □ 測試先寫（TDD RED→GREEN）
 □ 無 console.log / any
 □ useEffect 有必要的說明
 □ 設計稿對照確認
─────────────────────────────────────
EOF

exit 0
