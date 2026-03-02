# CR Log

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

## [2026-03-03 07:26] CR #2 — feat/phase-0-project-setup（Energy_Admin）

**審查範圍:** Phase 0-8 完整 MVP 實作（71 files，9353 insertions）
**Commit:** ccd26ff（修正後）

### 發現問題

| # | 等級 | 面向 | 檔案:行號 | 問題描述 |
|---|---|---|---|---|
| 1 | 🔴 | 安全性/邏輯 | interceptor.ts:71-76 | `/auth/refresh` 型別含不存在的 `refresh_token`，導致每次刷新後 refresh token 被清除 |
| 2 | 🟡 | 型別安全 | auth.store.ts:11 | `JSON.parse(stored) as AuthUser` 不安全斷言，應用 Zod parse |
| 3 | 🟡 | 效能 | UsersTable.tsx:119 | 分頁按鈕無上限，大量資料會渲染大量按鈕 |
| 4 | 🟡 | React 最佳實踐 | router.tsx:42-44 | Wildcard `*` 一律導向 `/login`，已登入用戶應導向 `/users` |
| 5 | 🟢 | i18n | 全域 | 所有顯示文字硬編碼英文 |

### 統計
- 🔴 Critical: 1 個
- 🟡 Warning: 3 個
- 🟢 Info: 1 個

### 例外清單
| # | 等級 | 例外理由 |
|---|---|---|
| 5 | 🟢 | i18n — Phase 9 才需要，MVP 不要求 |

### 修正狀態: ✅ 已修正（commit: ccd26ff）

---

## [2026-03-03 07:40] CR #3 — chore/team-model-policy（workspace，re-review）

**審查範圍:** hooks、CI workflows、settings、protocol（11 files，376 insertions）
**Commit:** 8bd04db（修正後）

### 發現問題

| # | 等級 | 面向 | 檔案:行號 | 問題描述 |
|---|---|---|---|---|
| 1 | 🟡 | 可維護性 | pre-bash-pr-commit-review.sh:39 | `SECONDARY_OK` 缺少 `chore`，`feat/` branch 的 `chore(ci)` commits 被誤擋（本 session 實際觸發） |
| 2 | 🟢 | 文件 | protocol.md:34 | 狀態顯示「Phase 0 進行中」，實際已完成 Phase 0-8 |

### 統計
- 🔴 Critical: 0
- 🟡 Warning: 1
- 🟢 Info: 1

### 修正狀態: ✅ 已修正（commit: 8bd04db）
---
