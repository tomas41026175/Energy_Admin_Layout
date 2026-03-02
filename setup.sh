#!/usr/bin/env bash
# =============================================================================
# setup.sh — Energy Admin Workspace Setup
#
# 雙層 Git 架構設定腳本
#   Layer 1 (Workspace): Energy_Admin_Layout  ← 你現在在這裡
#   Layer 2 (Project):   Energy_Admin         ← 此腳本負責管理
#
# 使用方式:
#   bash setup.sh              # 首次 clone 或 pull 最新
#   bash setup.sh --install    # clone/pull 後自動安裝 npm 依賴
# =============================================================================

set -euo pipefail

# ── 設定 ──────────────────────────────────────────────────────────────────────
REPO_URL="${ENERGY_ADMIN_REPO:-}"          # 可透過環境變數覆寫
PROJECT_DIR="Energy_Admin"
DEFAULT_BRANCH="main"
INSTALL_DEPS=false

# ── 解析參數 ──────────────────────────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --install) INSTALL_DEPS=true ;;
    --help|-h)
      echo "用法: bash setup.sh [--install]"
      echo ""
      echo "  --install    clone/pull 後自動執行 npm install"
      echo ""
      echo "環境變數:"
      echo "  ENERGY_ADMIN_REPO    指定 git remote URL（若尚未設定）"
      exit 0
      ;;
  esac
done

# ── 顏色輸出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ── 確認 REPO_URL ─────────────────────────────────────────────────────────────
if [[ -z "$REPO_URL" ]]; then
  # 嘗試從現有 remote 讀取
  if [[ -d "$PROJECT_DIR/.git" ]]; then
    REPO_URL=$(git -C "$PROJECT_DIR" remote get-url origin 2>/dev/null || true)
  fi
fi

if [[ -z "$REPO_URL" ]]; then
  log_warn "尚未設定 Energy-Admin repo URL"
  echo ""
  echo "請選擇其中一種方式設定："
  echo "  1. 環境變數: export ENERGY_ADMIN_REPO=https://github.com/<user>/Energy-Admin.git"
  echo "  2. 直接執行: ENERGY_ADMIN_REPO=https://github.com/<user>/Energy-Admin.git bash setup.sh"
  echo ""
  read -rp "請輸入 repo URL（直接 Enter 跳過）: " input_url
  REPO_URL="${input_url:-}"
fi

# ── 主流程 ────────────────────────────────────────────────────────────────────
echo ""
echo "============================================================"
echo "  Energy Admin Workspace Setup"
echo "  Layer 1: $(pwd)"
echo "  Layer 2: $(pwd)/${PROJECT_DIR}"
echo "============================================================"
echo ""

WORKSPACE_DIR="$(pwd)"

if [[ -d "$PROJECT_DIR/.git" ]]; then
  # ── 已存在：Pull 更新 ────────────────────────────────────────────────────
  log_info "偵測到 ${PROJECT_DIR}/ 已存在，執行 pull..."
  cd "$PROJECT_DIR"

  CURRENT_BRANCH=$(git branch --show-current)
  log_info "目前分支: ${CURRENT_BRANCH}"

  git fetch origin
  git pull origin "${CURRENT_BRANCH}"

  log_success "${PROJECT_DIR} 已更新至最新版本"
  cd "$WORKSPACE_DIR"

elif [[ -n "$REPO_URL" ]]; then
  # ── 首次：Clone ──────────────────────────────────────────────────────────
  log_info "Clone Energy-Admin repo..."
  log_info "來源: ${REPO_URL}"
  log_info "目標: ./${PROJECT_DIR}/"
  echo ""

  git clone --branch "$DEFAULT_BRANCH" "$REPO_URL" "$PROJECT_DIR"

  log_success "Clone 完成"

else
  # ── 無 URL 且無現有 repo ─────────────────────────────────────────────────
  log_warn "跳過 clone（未提供 repo URL）"
  log_info "若要初始化空的 Layer 2 repo:"
  echo "    mkdir -p ${PROJECT_DIR} && git -C ${PROJECT_DIR} init"
fi

# ── 安裝依賴（可選）─────────────────────────────────────────────────────────
if [[ "$INSTALL_DEPS" == true ]] && [[ -d "$PROJECT_DIR" ]]; then
  cd "$PROJECT_DIR"

  if [[ -f "package.json" ]]; then
    log_info "安裝 npm 依賴..."
    npm install
    log_success "依賴安裝完成"
  else
    log_warn "找不到 package.json，跳過 npm install"
  fi

  cd "$WORKSPACE_DIR"
fi

# ── 完成摘要 ──────────────────────────────────────────────────────────────────
echo ""
echo "============================================================"
log_success "Workspace 設定完成"
echo ""
echo "  架構說明:"
echo "    Layer 1 (Workspace)  $(pwd)"
echo "    Layer 2 (Project)    $(pwd)/${PROJECT_DIR}"
echo ""
echo "  常用指令:"
echo "    bash setup.sh              # pull 最新 project"
echo "    bash setup.sh --install    # pull + npm install"
echo "============================================================"
echo ""
