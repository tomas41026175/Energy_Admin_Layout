# CR Log

## [2026-03-03] CR #5 — feat/ux-improvements

**審查範圍:** 12 項 UX 優化 — AppLayout、Sidebar、users page、UsersTable、users.hooks、dashboard、constants（15 個檔案）
**Commit:** 88049cf

### 發現問題

| # | 等級 | 面向 | 檔案:行號 | 問題描述 |
|---|------|------|-----------|----------|
| 1 | 🟡 | React 最佳實踐 | users.tsx:100 | handleClearSearch 未用 useCallback 穩定化，導致 handleEscape 使用 eslint-disable 遮蔽 stale closure 警告 |
| 2 | 🟡 | 效能 | users.tsx:105 + users.hooks.ts:24 | tableParams 每次 render 都是新物件，導致 useEffect 每次渲染觸發 |
| 3 | 🟢 | 可維護性 | Sidebar.tsx:64-69 | 兩個互斥條件渲染可改為三元（可選） |
| 4 | 🟢 | React 最佳實踐 | dashboard.tsx:79 | Cell key={i} 使用陣列索引（靜態陣列可接受） |

### 統計

- 🔴 Critical: 0 個
- 🟡 Warning: 2 個（已修正）
- 🟢 Info: 2 個（可選，未修正）
- Learnings 命中: 0 個（learnings.md 不存在）

### 例外清單

| # | 等級 | 面向 | 檔案:行號 | 例外理由 |
|---|------|------|-----------|----------|
| 3 | 🟢 | 可維護性 | Sidebar.tsx:64-69 | 可讀性差異不大，保持現狀 |
| 4 | 🟢 | React 最佳實踐 | dashboard.tsx:79 | 靜態固定大小陣列，key 穩定，可接受 |

### 修正狀態: ✅ 已修正

### Re-review

🟡 兩項 Warning 已修正（commit: 66dc19d）：
- `handleClearSearch` 改為 `useCallback(fn, [setSearchParams])`
- `tableParams` 改為 `useMemo` 穩定引用
- 265 tests pass，tsc --noEmit 通過，eslint 通過

---

## [2026-03-03] CR #1 — chore/team-model-policy

**審查範圍:** team protocol、PR template、CI/CD workflows、task breakdown（5 個檔案）
**Commit:** fcdb72b

### 發現問題

| # | 等級 | 面向 | 檔案:位置 | 問題描述 |
|---|------|------|-----------|----------|
| 1 | 🔴 | 安全性 | pr-review-notify.yml:50-51 | Script injection：branch/title 直接插入 JS template literal |
| 2 | 🟡 | 可維護性 | protocol.md:35 | 拼字錯誤：sonnnet → sonnet |
| 3 | 🟡 | 可維護性 | ci.yml:28-30 | npm ci 在無 package-lock.json 時會失敗 |
| 4 | 🟡 | 可維護性 | ci.yml:32 | 直接用 npx tsc 而非 npm run type-check |
| 5 | 🟡 | 效能 | pr-review-notify.yml:21,24-28 | 不必要的 checkout 與中間步驟 |

### 統計

- 🔴 Critical: 1 個
- 🟡 Warning: 4 個
- 🟢 Info: 0 個
- Learnings 命中: 0 個（首次審查）

### 例外清單

無

### 修正狀態: ✅ 已修正

### Re-review

所有問題已於同 branch 修正並 push（commit: fcdb72b）。

---

## [2026-03-03] CR #4 — feat/phase-9-advanced

**審查範圍:** Phase 9 進階功能 — 搜尋/篩選（3 個檔案）
**Commit:** 7076b67

### 發現問題

無

### 統計

- 🔴 Critical: 0 個
- 🟡 Warning: 0 個
- 🟢 Info: 0 個

### 例外清單

無

### 修正狀態: ✅ 直接通過

---

## [2026-03-03] CR #3 — feat/phase-7-tests

**審查範圍:** Phase 7 測試完善 — 7 個新測試檔，覆蓋率 43% → 72%
**Commit:** fddf586

### 發現問題

無

### 統計

- 🔴 Critical: 0 個
- 🟡 Warning: 0 個
- 🟢 Info: 0 個
- Learnings 命中: 0 個

### 例外清單

無

### 修正狀態: ✅ 直接通過

---

## [2026-03-03] CR #2 — feat/phase-6-ui-optimization

**審查範圍:** Phase 6 UI 優化 — 共用 UI 元件、RWD、無障礙性（17 個檔案）
**Commit:** a4aff21

### 發現問題

| # | 等級 | 面向 | 檔案:行號 | 問題描述 |
|---|------|------|-----------|----------|
| 1 | 🟡 | 可維護性 | ConfirmDialog.tsx:54-55 | 冗餘 ARIA 屬性：headlessui Dialog.Panel 已自動設定 role="dialog" + aria-modal="true" |
| 2 | 🟡 | 可維護性 | Toast.tsx:5 | ToastType 重複宣告（已在 useToast.ts 定義），應統一從 useToast.ts import |
| 3 | 🟢 | 無障礙性 | Toast.tsx:67 | 關閉按鈕使用 `x` 字元，應改為 `×`（已連帶修正） |

### 統計

- 🔴 Critical: 0 個
- 🟡 Warning: 2 個
- 🟢 Info: 1 個
- Learnings 命中: 0 個（learnings.md 不存在）

### 例外清單

無

### 修正狀態: ✅ 已修正

### Re-review

所有問題已修正並 commit（commit: a4aff21）。96 tests pass，lint + type-check 通過。

---

## [2026-03-04 13:00] CR #6 — docs/tech-debt-cr-patterns

**審查範圍:** Workspace 文件更新 — CLAUDE.md CR Pattern + roadmap 狀態 + learning-logs
**Commit:** e3df278

### 發現問題
| # | 等級 | 面向 | 檔案:行號 | 問題描述 |
|---|---|---|---|---|
| 無問題 | | | | |

### 統計
- 🔴 Critical: 0 個
- 🟠 Domain Issue: 0 個
- 🟡 Warning: 0 個
- 🟢 Info: 0 個
- Learnings 命中: 0 個

### 修正狀態: ✅ 已修正（無問題，直接 Approved）
---
