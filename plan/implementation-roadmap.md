# 專案實作路線圖

> 後台管理系統完整實作計畫

---

## 📋 專案概覽

**專案名稱**: Energy Admin (後台使用者管理系統)
**技術棧**: React + TypeScript + Vite + TanStack Query + Zustand
**目標**: 建立一個生產級後台管理系統，展示完整的前端架構設計與實作能力

---

## 🎯 核心目標

- ✅ 完整的文件系統（已完成）
- ✅ 實作認證與 Token 管理機制
- ✅ 實作使用者列表功能
- ✅ **設定 CI/CD 流程並部署到 Vercel（已完成）**
- ✅ 提升使用者體驗（Loading States、Error Handling、A11y）
- 🟡 建立測試體系（覆蓋率 ~68%，目標 80%）
- ⏳ 確保專案完整度（Observability、進階效能優化）

---

## 🚀 Phase 執行順序（重要）

```
Phase 0 → Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5
                                                        ↓
                                                    Phase 8 ← ⚠️ 提前執行
                                                    (CI/CD + Vercel 部署)
                                                        ↓
                                            Phase 6 → Phase 7 → Phase 9
```

**關鍵說明**：
- ⚠️ **Phase 8（CI/CD + Vercel 部署）必須在 Phase 5 之後立即執行**
- Phase 8 是**交付必要項目**，不是可選項
- 完成 Phase 5 後，立即設定 Vercel 部署，確保核心功能可以上線
- Phase 6-7（UI 優化、測試）可以在部署後持續優化

---

## 📊 實作階段

### Phase 0: 專案設定

**狀態**: ✅ 完成

#### 0.1 專案初始化
- [ ] 使用 Vite 建立專案
- [ ] 安裝核心依賴
- [ ] 設定 TypeScript 配置
- [ ] 設定路徑別名 (@/)

#### 0.2 開發工具設定
- [ ] 設定 ESLint
- [ ] 設定 Prettier
- [ ] 設定 Tailwind CSS
- [ ] 設定 Git hooks (husky)

#### 0.3 測試環境設定
- [ ] 安裝 Vitest
- [ ] 安裝 MSW
- [ ] 設定測試配置
- [ ] 建立測試工具函式

**交付物**:
- `package.json`
- `tsconfig.json`
- `vite.config.ts`
- `vitest.config.ts`
- `.eslintrc.js`
- `.prettierrc`
- `tailwind.config.js`

---

### Phase 1: 型別系統建立

**狀態**: ✅ 完成

#### 1.1 全域型別定義
- [ ] 建立 `types/global.d.ts`
- [ ] 建立 `types/common.ts`
- [ ] 定義環境變數型別

#### 1.2 共用型別定義
- [ ] 建立 `shared/api/error.ts`
- [ ] 建立 `shared/api/types.ts`
- [ ] 建立 Type Guards (`shared/utils/type-guards.ts`)

#### 1.3 型別測試
- [ ] 建立 Type Guards 單元測試
- [ ] 驗證型別推導正確性

**交付物**:
- `src/types/global.d.ts`
- `src/types/common.ts`
- `src/shared/api/error.ts`
- `src/shared/api/types.ts`
- `src/shared/utils/type-guards.ts`
- `src/shared/utils/__tests__/type-guards.test.ts`

---

### Phase 2: API 客戶端建立

**狀態**: ✅ 完成

#### 2.1 基礎 API 客戶端
- [ ] 建立 Axios 實例 (`shared/api/client.ts`)
- [ ] 設定請求/回應攔截器
- [ ] 實作錯誤正規化
- [ ] 建立統一的錯誤型別與錯誤碼定義

#### 2.2 Token 刷新機制
- [ ] 實作 Token 過期偵測
- [ ] 實作自動刷新邏輯
- [ ] 實作請求佇列機制
- [ ] 實作 Refresh Lock

#### 2.3 錯誤處理機制（UX 提升）
- [ ] 實作錯誤分級系統（Critical/Recoverable/Warning/Validation）
- [ ] 建立 Error Boundary (`shared/components/ErrorBoundary.tsx`)
- [ ] 實作 Toast Notification 系統 (`shared/ui/Toast.tsx`)
- [ ] 實作網路狀態偵測（Offline Detection）

#### 2.4 API 客戶端測試
- [ ] 建立攔截器整合測試
- [ ] 測試 Token 刷新機制
- [ ] 測試錯誤處理與錯誤分級
- [ ] 測試網路錯誤恢復機制

**交付物**:
- `src/shared/api/client.ts`
- `src/shared/api/interceptor.ts`
- `src/shared/api/error-handler.ts` - 錯誤處理邏輯
- `src/shared/components/ErrorBoundary.tsx` - React Error Boundary
- `src/shared/ui/Toast.tsx` - Toast 通知系統
- `src/shared/hooks/useNetworkStatus.ts` - 網路狀態 Hook
- `src/shared/api/__tests__/interceptor.integration.test.ts`
- `src/shared/api/__tests__/error-handler.test.ts`

---

### Phase 3: 認證模組實作

**狀態**: ✅ 完成

#### 3.1 認證型別與 Schema
- [ ] 建立 `auth/auth.types.ts`
- [ ] 建立 `auth/auth.schemas.ts` (Zod)
- [ ] 建立 Schema 單元測試

#### 3.2 認證 API
- [ ] 實作 `auth/auth.api.ts`
  - `login()` - 登入
  - `refreshToken()` - 刷新 Token
  - `logout()` - 登出
- [ ] 建立 API 單元測試

#### 3.3 認證狀態管理
- [ ] 建立 `auth/auth.store.ts` (Zustand)
- [ ] 實作 Session Restore
- [ ] 建立 Store 單元測試

#### 3.4 路由守衛
- [ ] 建立 `auth/auth.guard.tsx`
- [ ] 實作 Protected Route
- [ ] 建立守衛測試

**交付物**:
- `src/auth/auth.types.ts`
- `src/auth/auth.schemas.ts`
- `src/auth/auth.api.ts`
- `src/auth/auth.store.ts`
- `src/auth/auth.guard.tsx`
- `src/auth/__tests__/auth.api.test.ts`
- `src/auth/__tests__/auth.schemas.test.ts`
- `src/auth/__tests__/auth.store.test.ts`

---

### Phase 4: 使用者列表功能

**狀態**: ✅ 完成

#### 4.1 使用者型別與 Schema
- [ ] 建立 `domains/users/users.types.ts`
- [ ] 建立 `domains/users/users.schemas.ts` (Zod)
- [ ] 建立 Schema 單元測試

#### 4.2 使用者 API
- [ ] 實作 `domains/users/users.api.ts`
  - `getUsers()` - 取得使用者列表
- [ ] 建立 API 單元測試

#### 4.3 使用者 Hooks
- [ ] 建立 `domains/users/users.hooks.ts` (TanStack Query)
- [ ] 實作 `useUsers` Hook
- [ ] 建立 Hooks 測試

#### 4.4 使用者列表 UI
- [ ] 建立 `domains/users/UsersTable.tsx`
- [ ] 實作分頁功能
- [ ] 實作 Loading 狀態（Skeleton Loading）
- [ ] 實作 Error 狀態（含重試按鈕）
- [ ] 實作 Empty 狀態（無資料時的友善提示）
- [ ] 實作重試功能與 Loading 指示
- [ ] 加入分頁載入動畫（切換頁面時的 Loading）

**交付物**:
- `src/domains/users/users.types.ts`
- `src/domains/users/users.schemas.ts`
- `src/domains/users/users.api.ts`
- `src/domains/users/users.hooks.ts`
- `src/domains/users/UsersTable.tsx`
- `src/domains/users/__tests__/users.api.test.ts`
- `src/domains/users/__tests__/users.schemas.test.ts`

---

### Phase 5: 頁面與路由

**狀態**: ✅ 完成

#### 5.1 登入頁面（Form Experience UX）
- [ ] 建立 `pages/login.tsx`
- [ ] 整合 React Hook Form + Zod
- [ ] 實作即時表單驗證（失焦時驗證）
- [ ] 實作 Field-level 錯誤訊息
- [ ] 實作錯誤處理與友善錯誤提示
- [ ] 加入提交中狀態（禁用按鈕 + Loading 指示）
- [ ] 加入 Helper Text（欄位提示文字）
- [ ] 實作 AutoComplete 屬性（username/password）
- [ ] 加入鍵盤支援（Enter 提交）

#### 5.2 使用者列表頁面
- [ ] 建立 `pages/users.tsx`
- [ ] 整合 UsersTable 元件
- [ ] 實作分頁狀態管理

#### 5.3 路由設定
- [ ] 建立 `app/router.tsx`
- [ ] 設定 Protected Routes
- [ ] 設定導向規則

#### 5.4 應用程式入口
- [ ] 建立 `app/App.tsx`
- [ ] 建立 `app/providers.tsx`
- [ ] 整合 TanStack Query Provider

**交付物**:
- `src/pages/login.tsx`
- `src/pages/users.tsx`
- `src/app/router.tsx`
- `src/app/App.tsx`
- `src/app/providers.tsx`

---

### Phase 6: UI 優化

**狀態**: ✅ 完成

#### 6.1 共用 UI 元件
- [ ] 建立 `shared/ui/Button.tsx`（含 Loading 狀態）
- [ ] 建立 `shared/ui/Input.tsx`（含錯誤狀態與 Helper Text）
- [ ] 建立 `shared/ui/Skeleton.tsx`（多種形狀：文字、圖片、卡片）
- [ ] 建立 `shared/ui/ErrorMessage.tsx`（含重試按鈕）
- [ ] 建立 `shared/ui/EmptyState.tsx`（空狀態元件）
- [ ] 建立 `shared/ui/ConfirmDialog.tsx`（確認對話框）
- [ ] 建立 `shared/ui/Spinner.tsx`（載入指示器）

#### 6.2 響應式設計（RWD）
- [ ] 實作手機版佈局（< 768px）
  - [ ] 導航選單適配
  - [ ] 表格轉為卡片式呈現
  - [ ] 表單欄位垂直排列
- [ ] 實作平板版佈局（768-1024px）
  - [ ] 側邊欄摺疊功能
  - [ ] 表格簡化顯示
- [ ] 實作桌面版佈局（> 1024px）
  - [ ] 完整表格顯示
  - [ ] 側邊欄展開

#### 6.3 無障礙性（Accessibility）
- [ ] 實作鍵盤導航支援（Tab、Enter、Escape）
- [ ] 加入 ARIA 屬性（aria-label、aria-describedby）
- [ ] 實作 Focus 狀態樣式
- [ ] 確保色彩對比度符合 WCAG AA（4.5:1）
- [ ] 加入 Skip to Content 連結
- [ ] 確保所有互動元素可用鍵盤操作

#### 6.4 使用者體驗優化（進階）
- [ ] 加入 Loading 動畫（Skeleton Loading）
- [ ] 加入頁面過場效果（Fade In/Out）
- [ ] 加入微互動（Hover Effects、Button Click Feedback）
- [ ] 優化錯誤訊息（具體、可操作）
- [ ] 實作操作回饋（Toast Notifications）
- [ ] 加入確認對話框（刪除、登出等操作）

#### 6.5 資料視覺化與空狀態
- [ ] 設計使用者列表空狀態
- [ ] 設計搜尋無結果狀態
- [ ] 設計載入失敗狀態

**交付物**:
- `src/shared/ui/Button.tsx`
- `src/shared/ui/Input.tsx`
- `src/shared/ui/Skeleton.tsx`
- `src/shared/ui/ErrorMessage.tsx`
- `src/shared/ui/EmptyState.tsx`
- `src/shared/ui/ConfirmDialog.tsx`
- `src/shared/ui/Spinner.tsx`
- `src/shared/hooks/useMediaQuery.ts` - RWD Hook
- `src/shared/hooks/useKeyboard.ts` - 鍵盤導航 Hook
- `src/shared/styles/animations.css` - 動畫樣式

---

### Phase 7: 測試完善與效能優化

**狀態**: 🟡 進行中（覆蓋率 ~68%，目標 80%）

#### 7.1 單元測試補完
- [ ] 確保所有 API 函式有測試
- [ ] 確保所有 Schema 有測試
- [ ] 確保所有 Type Guards 有測試
- [ ] 確保所有 UI 元件有測試

#### 7.2 整合測試
- [ ] Token 刷新整合測試
- [ ] 認證流程整合測試
- [ ] 使用者列表分頁整合測試
- [ ] 錯誤處理整合測試

#### 7.3 無障礙性測試（A11y Testing）
- [ ] 使用 axe-core 進行自動化 A11y 測試
- [ ] 鍵盤導航測試（Tab、Enter、Escape）
- [ ] Screen Reader 測試（基本驗證）
- [ ] 色彩對比度檢查

#### 7.4 效能優化（Performance Optimization）
- [ ] 實作 Code Splitting（路由層級）
- [ ] 實作 Lazy Loading（React.lazy + Suspense）
- [ ] 圖片優化（lazy loading、WebP 格式）
- [ ] Bundle Size 分析與優化
- [ ] 移除未使用的依賴
- [ ] 實作 Memoization（React.memo、useMemo）

#### 7.5 效能測試
- [ ] Lighthouse 測試（LCP < 2.5s、FID < 100ms、CLS < 0.1）
- [ ] Bundle Size 檢查（< 500KB）
- [ ] 載入速度測試

#### 7.6 測試覆蓋率
- [ ] 執行覆蓋率報告
- [ ] 確保達到 70-80% 目標
- [ ] 修補低覆蓋率區域

**交付物**:
- 測試覆蓋率報告
- 所有測試通過
- Lighthouse 報告
- Bundle Size 分析報告
- A11y 測試報告

---

### Phase 8: CI/CD 與 Vercel 部署（必須完成）

**狀態**: ✅ 完成（2026-03-04）

> **重要**: 此階段為生產部署必要項目，必須完成以確保專案可透過 Vercel 交付。

#### 8.1 GitHub Actions CI/CD 設定（必須）
- [ ] 建立 `.github/workflows/ci.yml` - 持續整合流程
  - [ ] 自動執行測試（`npm test`）
  - [ ] Lint 檢查（`npm run lint`）
  - [ ] TypeScript 型別檢查（`tsc --noEmit`）
  - [ ] Build 檢查（`npm run build`）
- [ ] 設定 PR 觸發條件（pull_request 到 main）
- [ ] 設定狀態檢查為必要（Required Status Checks）

#### 8.2 Vercel 部署設定（必須）
- [ ] 建立 Vercel 專案
  - [ ] 連結 GitHub Repository
  - [ ] 設定 Build Command: `npm run build`
  - [ ] 設定 Output Directory: `dist`
  - [ ] 設定 Install Command: `npm install`
- [ ] 設定環境變數
  - [ ] `VITE_API_BASE_URL`（API Base URL）
  - [ ] 其他必要的環境變數
- [ ] 設定自動部署
  - [ ] Production 部署（main branch）
  - [ ] Preview 部署（所有 PR）
- [ ] 設定自訂網域（可選）
- [ ] 測試 Vercel 部署流程

#### 8.3 Vercel 配置檔案（必須）
- [ ] 建立 `vercel.json`
  - [ ] 設定 rewrites（SPA 路由）
  - [ ] 設定 headers（Security Headers、CORS）
  - [ ] 設定 redirects（可選）
- [ ] 建立 `.vercelignore`（可選）

#### 8.4 安全性檢查（必須）
- [ ] 檢查依賴套件漏洞（`npm audit`）
- [ ] 設定 Security Headers（via vercel.json）
  - [ ] Content Security Policy（CSP）
  - [ ] X-Frame-Options
  - [ ] X-Content-Type-Options
  - [ ] Referrer-Policy
- [ ] 驗證 Token 儲存策略（in-memory + localStorage）
- [ ] 檢查輸入驗證（Zod Schema）
- [ ] 驗證 API 錯誤不洩露敏感資訊
- [ ] 確保 `.env` 不會被提交（.gitignore）

#### 8.5 部署驗證（必須）
- [ ] Production 部署成功
- [ ] Preview 部署成功（測試 PR）
- [ ] 環境變數正確設定並生效
- [ ] SPA 路由正常（/users 直接訪問不會 404）
- [ ] API 呼叫正常（CORS、Base URL）
- [ ] 登入流程完整運作
- [ ] Token 刷新機制正常
- [ ] 重新整理頁面保持登入

#### 8.6 可觀測性（可選 - 可延後至 Phase 8+）
- [ ] 整合錯誤追蹤（Sentry）
- [ ] 設定錯誤日誌記錄
- [ ] 加入基本 Analytics（可選）
- [ ] 設定效能監控（Vercel Analytics / Web Vitals）

#### 8.7 文件最終檢查（必須）
- [ ] 更新 README.md
  - [ ] 加入部署 URL
  - [ ] 加入環境變數設定說明
  - [ ] 加入 Vercel 部署步驟
- [ ] 檢查所有文件連結
- [ ] 建立 CHANGELOG.md
- [ ] 補充 Vercel 部署說明

**交付物**:
- `.github/workflows/ci.yml` - CI 流程
- `vercel.json` - Vercel 配置
- Vercel 專案配置（環境變數、自動部署）
- Production 部署 URL
- 完整的 README.md（含部署說明）
- CHANGELOG.md

---

### Phase UX: UX 深度優化（12 項）

**狀態**: ✅ 完成（2026-03-03，branch: feat/ux-improvements）

> 基於 API 限制（僅支援 GET /api/users?page&limit&name&email&status），
> 跳過需要 POST/PATCH 的 3 項（狀態切換、新增使用者、Dashboard 時間篩選），
> 實作以下 12 項 UX 優化。

#### UX.1 搜尋改進
- [x] 搜尋清除按鈕（searchInput 非空時顯示 ✕）
- [x] 搜尋結果數量提示（「共 N 筆結果」）
- [x] 鍵盤快捷鍵：`/` 聚焦搜尋框，`Esc` 清除搜尋

#### UX.2 URL Query Params 同步
- [x] `useSearchParams` 作為唯一狀態來源（q / status / page / limit）
- [x] 篩選條件可分享（重整後保留）
- [x] 每頁筆數選擇（PAGE_SIZE_OPTIONS: 10 / 25 / 50）

#### UX.3 表格增強
- [x] isPlaceholderData Spinner（翻頁時右上角 loading 指示器）
- [x] 差異化 Empty State（有搜尋條件 vs 無資料）
- [x] 欄位排序 client-side（ID / 姓名 / 建立日期，含 ▲▼ 指示器）

#### UX.4 效能優化
- [x] 分頁預取（useEffect 預取下一頁至 QueryClient cache）

#### UX.5 Layout 改進
- [x] Sidebar 收合（desktop: w-64 ↔ w-16，icon-only + tooltip）
- [x] 離線 Banner（useNetworkStatus，頂部提示列）

#### UX.6 資料視覺化
- [x] Dashboard 圓餅圖（recharts PieChart，啟用/停用比例）

**測試覆蓋**：265 tests pass（25 files），新增 sort / spinner / offline / collapse / pie chart 測試

---

### Phase 9: 進階功能擴充（可選）

**狀態**: ⏳ 未來擴充（核心功能已交付，此 Phase 為選配）

> 此階段為可選功能，可在核心功能完成後根據需求選擇性實作

#### 9.1 進階使用者功能
- [ ] 使用者搜尋功能（Real-time Search）
- [ ] 進階篩選器（狀態、角色、日期範圍）
- [ ] 排序功能（姓名、建立日期、狀態）
- [ ] 批次操作（批次啟用/停用）
- [ ] 匯出功能（CSV、Excel）

#### 9.2 權限管理（RBAC）
- [ ] 角色定義（管理員、一般使用者）
- [ ] 權限控制（頁面層級、功能層級）
- [ ] 權限檢查 Hook (`usePermission`)
- [ ] 條件式渲染（根據權限顯示/隱藏功能）

#### 9.3 稽核日誌（Audit Logs）
- [ ] 使用者操作記錄（登入、登出、操作）
- [ ] 稽核日誌列表頁面
- [ ] 稽核日誌篩選與搜尋
- [ ] 稽核日誌匯出

#### 9.4 通知系統
- [ ] 站內通知（Notification Center）
- [ ] 通知列表與未讀標記
- [ ] 通知設定（Email、Push）

#### 9.5 主題切換（Dark Mode）
- [ ] 實作深色模式
- [ ] 主題切換 Toggle
- [ ] 主題偏好儲存（localStorage）
- [ ] 尊重系統主題設定

#### 9.6 國際化（i18n）
- [ ] 整合 i18n 框架（react-i18next）
- [ ] 多語言支援（繁中、英文）
- [ ] 語言切換功能
- [ ] 語言偏好儲存

#### 9.7 表格虛擬化（大量資料）
- [ ] 整合 @tanstack/react-virtual
- [ ] 虛擬化列表實作
- [ ] 大量資料效能優化

**交付物**:
- 根據選擇實作的功能而定

---

### Phase TD: 技術債清償（2026-03-04 登錄）

**狀態**: ⏳ 待處理

> 根據 2026-03-04 程式碼品質審查發現，登錄以下技術債，依優先級排序。

#### TD-P0：立即修復

- [ ] **拆分 `UsersTable.tsx`**（359 行 → 目標各 <100 行）
  - [ ] `UsersTable.tsx`（容器，<100 行）
  - [ ] `UsersTableRow.tsx`（行元件）
  - [ ] `UsersTableMobile.tsx`（行動版卡片）
  - [ ] `UsersTablePagination.tsx`（分頁器）
  - [ ] `SortableHeader.tsx`（可排序欄位）
- [ ] **補 `interceptor.ts` 單元測試**（Token 刷新、佇列、失敗回退）
- [ ] **修正 `StatusBadge` 跨層耦合**（改為泛型介面，移除對 `users.types` 的直接依賴）

#### TD-P1：本週處理

- [ ] **拆分 `pages/users.tsx`**（242 行）→ 抽出 `SearchBar.tsx`、`FilterControls.tsx`
- [ ] **拆分 `pages/dashboard.tsx`**（176 行）→ 抽出 `StatCard.tsx`、`RecentUserRow.tsx`
- [ ] **拆分 `app/layout/Sidebar.tsx`**（185 行）→ 抽出各 icon 元件

#### TD-P2：長期優化

- [ ] **補齊測試覆蓋率至 80%**（目前 ~68%）
  - [ ] `shared/api/interceptor.ts`
  - [ ] `app/router.tsx`
  - [ ] `app/providers.tsx`
  - [ ] `shared/hooks/useToast.ts`
- [ ] **修正 import 順序**（外部套件 → 內部 alias → 相對路徑）
- [ ] **評估 `interceptor.ts` 競態條件**（`isRefreshing` + `failedQueue` 全域狀態在極端並行情境下的風險）

**交付物**:
- 各元件檔案行數符合規範（元件 <100 行，函式 <50 行）
- 測試覆蓋率 ≥ 80%
- `shared/` 無 domain 依賴

---


## 🎯 里程碑

### Milestone 1: 專案基礎完成（Phase 0-2）
- ✅ 專案設定完成
- ✅ 型別系統建立
- ✅ API 客戶端完成
- ✅ 錯誤處理機制建立

### Milestone 2: 核心功能完成（Phase 3-4）
- ✅ 認證模組完成（含 Token 刷新）
- ✅ 使用者列表完成（含分頁）
- ✅ Loading/Error/Empty 狀態實作

### Milestone 3: 完整應用（Phase 5-6）
- ✅ 頁面與路由完成
- ✅ 表單體驗優化
- ✅ UI 優化完成（RWD + A11y）
- ✅ 使用者回饋機制（Toast、Confirm）

### Milestone 4: 生產就緒（Phase 7-8）
- 🟡 測試完善（覆蓋率 ~68%，目標 80%）
- ⏳ 效能優化（Lighthouse 尚未測量）
- ✅ **CI/CD 部署（GitHub Actions + Vercel）**
- ✅ **Production 部署成功並可訪問**
- ✅ Security Headers 設定
- ⏳ 可觀測性（可選 - 錯誤追蹤，尚未實作）
- ✅ 文件完整（含部署說明）

### Milestone 5: 進階功能（Phase 9 - 可選）
- ⏳ 進階使用者功能（搜尋、篩選）
- ⏳ 權限管理（RBAC）
- ⏳ 深色模式
- ⏳ 國際化（i18n）

---

## 📊 優先級分級

### 🔴 高優先級（必須完成 - MVP）
- **Phase 0**: 專案設定
- **Phase 1**: 型別系統
- **Phase 2**: API 客戶端（含錯誤處理）
- **Phase 3**: 認證模組（含 Token 刷新）
- **Phase 4**: 使用者列表（含 Loading/Error/Empty 狀態）
- **Phase 5**: 頁面與路由（含表單體驗）
- **Phase 8**: CI/CD 與部署（Vercel + GitHub Actions）- **必須完成**

### 🟡 中優先級（重要，建議完成）
- **Phase 6**: UI 優化（RWD + A11y + 使用者回饋）
- **Phase 7**: 測試完善（含效能優化）

### 🟢 低優先級（可選或延後）
- **Phase 8.3**: 可觀測性進階功能（Sentry 等 - 可延後）
- **Phase 9**: 進階功能擴充（可選）

---

## 🚧 風險與挑戰

### 已知風險

1. **Token 刷新機制複雜度**
   - 風險：競態條件、請求佇列處理
   - 緩解：詳細的整合測試、參考文件範例

2. **測試覆蓋率目標**
   - 風險：時間不足導致覆蓋率不達標
   - 緩解：優先測試核心邏輯、使用 MSW 簡化測試

3. **UI/UX 細節打磨**
   - 風險：時間投入過多在細節
   - 緩解：先完成功能，再優化體驗

---

## 🎯 階段驗收目標

### Phase 0: 專案設定

**驗收標準：**
- [ ] 專案可以正常啟動（`npm run dev`）
- [ ] ESLint 和 Prettier 正常運作
- [ ] Tailwind CSS 樣式生效
- [ ] 測試可以執行（`npm test`）
- [ ] TypeScript 編譯無錯誤

**產出確認：**
- [ ] 可以看到 Vite 開發伺服器畫面
- [ ] 基本的 Hello World 頁面顯示正常
- [ ] 測試框架可以執行範例測試

---

### Phase 1: 型別系統建立

**驗收標準：**
- [ ] 所有型別檔案建立完成
- [ ] Type Guards 測試 100% 通過
- [ ] TypeScript strict mode 無錯誤
- [ ] 環境變數型別正確定義

**產出確認：**
- [ ] `types/` 目錄結構完整
- [ ] Type Guards 可以正確識別型別
- [ ] IDE 自動完成功能正常

---

### Phase 2: API 客戶端建立

**驗收標準：**
- [ ] Axios 實例可以正常發送請求
- [ ] 攔截器正確附加 Token
- [ ] Token 刷新機制整合測試通過
- [ ] 錯誤正規化功能正常
- [ ] Error Boundary 可捕捉 React 錯誤
- [ ] Toast Notification 系統正常運作
- [ ] 網路斷線時正確偵測並提示

**產出確認：**
- [ ] 可以成功呼叫測試 API
- [ ] Token 過期自動刷新並重試
- [ ] 錯誤訊息格式統一
- [ ] 不同錯誤等級有不同處理方式（Critical/Recoverable/Warning）
- [ ] 網路錯誤時顯示 Toast 提示

---

### Phase 3: 認證模組實作

**驗收標準：**
- [ ] 登入 API 正常運作
- [ ] Refresh Token API 正常運作
- [ ] Auth Store 狀態管理正確
- [ ] Session Restore 功能正常
- [ ] Protected Route 正確攔截未登入請求
- [ ] 所有認證相關測試通過（覆蓋率 ≥ 80%）

**產出確認：**
- [ ] 可以使用測試帳號登入
- [ ] 重新整理頁面保持登入狀態
- [ ] 未登入訪問受保護頁面會被導向登入頁

---

### Phase 4: 使用者列表功能

**驗收標準：**
- [ ] 使用者列表 API 正常運作
- [ ] TanStack Query Hook 正確管理狀態
- [ ] 分頁功能正常
- [ ] Loading 狀態正確顯示（Skeleton Loading）
- [ ] Error 狀態正確顯示（含重試按鈕）
- [ ] Empty 狀態正確顯示（無資料時的友善提示）
- [ ] 分頁切換時有載入指示
- [ ] 所有使用者相關測試通過（覆蓋率 ≥ 80%）

**產出確認：**
- [ ] 登入後可以看到使用者列表
- [ ] 分頁切換正常且有 Loading 指示
- [ ] 首次載入時顯示 Skeleton（不是白屏）
- [ ] 錯誤時顯示具體錯誤訊息和重試按鈕
- [ ] 無資料時顯示友善的空狀態提示
- [ ] 重試功能正常運作

---

### Phase 5: 頁面與路由

**驗收標準：**
- [ ] 登入頁面表單驗證正常（即時驗證）
- [ ] 表單錯誤訊息正確顯示（Field-level）
- [ ] 表單提交中狀態正常（禁用按鈕 + Loading）
- [ ] 路由導向邏輯正確
- [ ] Protected Routes 正常運作
- [ ] Provider 設定正確
- [ ] 鍵盤支援正常（Enter 提交、Tab 切換）

**產出確認：**
- [ ] 登入流程完整運作
- [ ] 登入後導向使用者列表頁
- [ ] 登出後導向登入頁
- [ ] 瀏覽器前進/後退正常
- [ ] 表單驗證即時回饋（失焦時驗證）
- [ ] 錯誤訊息具體且友善
- [ ] 提交中按鈕禁用且顯示 Loading

---

### Phase 6: UI 優化

**驗收標準：**
- [ ] 共用 UI 元件可重用
- [ ] 響應式設計在所有裝置正常
- [ ] Loading 動畫流暢
- [ ] 錯誤訊息清晰易懂
- [ ] 所有互動元素可用鍵盤操作（Tab、Enter、Escape）
- [ ] Focus 狀態清晰可見
- [ ] 色彩對比度符合 WCAG AA（4.5:1）
- [ ] Toast Notification 正常運作
- [ ] Confirm Dialog 正常運作

**產出確認：**
- [ ] 手機版（< 768px）佈局正常
- [ ] 平板版（768-1024px）佈局正常
- [ ] 桌面版（> 1024px）佈局正常
- [ ] 無 UI 閃爍或錯位
- [ ] 可以只用鍵盤完成所有操作
- [ ] 空狀態顯示友善提示
- [ ] 操作有明確回饋（Toast）
- [ ] 危險操作有確認對話框

---

### Phase 7: 測試完善與效能優化

**驗收標準：**
- [ ] 測試覆蓋率達到 70-80%
- [ ] 所有單元測試通過
- [ ] 關鍵整合測試通過
- [ ] A11y 測試通過（axe-core 無 Critical 錯誤）
- [ ] 效能測試通過（Lighthouse Green - LCP < 2.5s、FID < 100ms、CLS < 0.1）
- [ ] Bundle Size < 500KB（gzipped）
- [ ] 手動測試檢查清單完成
- [ ] 無 Flaky Tests

**產出確認：**
- [ ] `npm test` 全部通過
- [ ] `npm run test:coverage` 達標
- [ ] Lighthouse 報告顯示綠色（90+ 分）
- [ ] Bundle Size 分析報告正常
- [ ] A11y 測試報告無 Critical 錯誤
- [ ] 測試報告無警告

---

### Phase 8: CI/CD 與 Vercel 部署

**驗收標準：**
- [ ] GitHub Actions CI workflow 正常運作
- [ ] 自動測試在 CI 中通過
- [ ] PR 觸發 CI 檢查（Required Status Checks）
- [ ] Vercel 專案成功建立並連結 GitHub
- [ ] Production 部署成功（main branch）
- [ ] Preview 部署成功（PR）
- [ ] 環境變數在 Vercel 中正確設定
- [ ] `vercel.json` 配置正確（rewrites、headers）
- [ ] Security Headers 設定正確（CSP、X-Frame-Options 等）
- [ ] 安全性檢查通過（npm audit 無 High/Critical）
- [ ] 文件完整且連結正確

**產出確認（生產環境驗證）：**
- [ ] PR 自動觸發 CI 測試和 Vercel Preview 部署
- [ ] Production 網站可以正常訪問（提供 URL）
- [ ] Preview 部署 URL 可以正常訪問
- [ ] SPA 路由正常（直接訪問 `/users` 不會 404）
- [ ] API 呼叫正常（CORS、環境變數正確）
- [ ] 登入流程完整運作
- [ ] Token 刷新機制在生產環境正常
- [ ] 重新整理頁面保持登入狀態
- [ ] README 包含部署 URL 和環境變數說明
- [ ] 所有文件連結有效
- [ ] CHANGELOG.md 記錄完整

---

## 📝 總體驗收標準

### 功能驗收
- [ ] 使用者可以登入
- [ ] Token 過期自動刷新（無感知）
- [ ] 重新整理頁面保持登入
- [ ] 使用者列表正確顯示
- [ ] 分頁功能正常
- [ ] 錯誤處理完善（有重試機制）

### 使用者體驗驗收
- [ ] Loading 狀態清晰（Skeleton Loading）
- [ ] Error 狀態友善（具體錯誤訊息 + 重試按鈕）
- [ ] Empty 狀態有提示
- [ ] 表單驗證即時回饋
- [ ] 操作有明確回饋（Toast）
- [ ] 響應式設計在所有裝置正常
- [ ] 所有互動元素可用鍵盤操作
- [ ] Focus 狀態清晰可見
- [ ] 色彩對比度符合 WCAG AA

### 效能驗收
- [ ] Lighthouse Performance ≥ 90
- [ ] LCP (Largest Contentful Paint) < 2.5s
- [ ] FID (First Input Delay) < 100ms
- [ ] CLS (Cumulative Layout Shift) < 0.1
- [ ] Bundle Size < 500KB (gzipped)

### 測試驗收
- [ ] 測試覆蓋率 ≥ 70%
- [ ] 所有單元測試通過
- [ ] 關鍵整合測試通過
- [ ] A11y 測試通過（無 Critical 錯誤）
- [ ] 手動測試檢查清單完成

### 安全性驗收
- [ ] Token 儲存策略正確（in-memory + localStorage）
- [ ] 輸入驗證完善（Zod Schema）
- [ ] 依賴套件無高風險漏洞（npm audit）
- [ ] CSP 設定正確
- [ ] 錯誤訊息不洩露敏感資訊

### 程式碼品質
- [ ] ESLint 無錯誤
- [ ] TypeScript 嚴格模式
- [ ] 無 console.log
- [ ] 無未使用的 import
- [ ] 程式碼結構清晰（Domain-driven）

### 部署驗收（必須）
- [ ] Production 部署成功（Vercel）
- [ ] Production URL 可正常訪問
- [ ] Preview 部署正常運作
- [ ] CI/CD 流程正常（GitHub Actions）
- [ ] 環境變數正確設定
- [ ] SPA 路由正常（不會 404）
- [ ] Security Headers 設定正確

### 文件驗收
- [ ] README.md 完整（含部署 URL 和環境變數說明）
- [ ] API 文件準確
- [ ] 測試文件完整
- [ ] 技術決策有記錄
- [ ] CHANGELOG.md 維護
- [ ] 包含 Vercel 部署步驟說明

---

## 🎨 UX 與完整度 Domain 對照表

| Domain | 優先級 | 實作階段 | 影響範圍 |
|--------|--------|----------|---------|
| **Loading States** | 🔴 高 | Phase 4, 6 | 所有非同步操作 |
| **Error Handling** | 🔴 高 | Phase 2, 4 | API 呼叫、表單 |
| **Form Experience** | 🔴 高 | Phase 5 | 登入頁、未來表單 |
| **Feedback & Confirmation** | 🟡 中 | Phase 6 | 所有使用者操作 |
| **Accessibility (A11y)** | 🟡 中 | Phase 6 | 所有 UI 元件 |
| **Performance** | 🟡 中 | Phase 7 | 整體應用 |
| **Security** | 🔴 高 | Phase 2-3 | Token、API、輸入 |
| **Observability** | 🟢 低 | Phase 8 | 錯誤追蹤、監控 |
| **Testing** | 🔴 高 | Phase 7 | 所有程式碼 |
| **RWD** | 🟡 中 | Phase 6 | 所有頁面 |
| **Search & Filtering** | 🟢 低 | Phase 9 | 使用者列表 |
| **Animation** | 🟢 低 | Phase 6 | UI 元件 |
| **Dark Mode** | 🟢 低 | Phase 9 | 整體應用 |
| **i18n** | 🟢 低 | Phase 9 | 整體應用 |

---

## 🚀 Vercel 部署快速參考

### 必要檔案

#### 1. `vercel.json`（SPA 路由 + Security Headers）
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
```

#### 2. `.github/workflows/ci.yml`（CI 檢查）
```yaml
name: CI

on:
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run lint
      - run: npm run test
      - run: npm run build
```

### Vercel 環境變數設定

在 Vercel Dashboard 設定以下環境變數：

| 變數名稱 | 範例值 | 說明 |
|---------|--------|------|
| `VITE_API_BASE_URL` | `https://lbbj5pioquwxdexqmcnwaxrpce0lcoqx.lambda-url.ap-southeast-1.on.aws` | API Base URL |

### 部署流程

1. **連結 GitHub Repo 到 Vercel**
   ```bash
   # 在 Vercel Dashboard:
   # - Import Project
   # - 選擇 GitHub Repository
   # - Framework Preset: Vite
   # - Build Command: npm run build
   # - Output Directory: dist
   ```

2. **設定環境變數**
   - Settings → Environment Variables
   - 加入 `VITE_API_BASE_URL`

3. **觸發部署**
   - Push to `main` → Production 部署
   - 開 PR → Preview 部署

4. **驗證部署**
   - 訪問 Production URL
   - 測試登入流程
   - 測試 SPA 路由（直接訪問 `/users`）

---

## 🔗 相關文件

- [API 文件](../docs/04-api-documentation.md)
- [技術決策](../docs/02-technical-decisions.md)
- [實作指南](../docs/03-implementation-guide.md)
- [測試策略](../docs/05-testing-strategy.md)

---

## 📊 預估時程

| 階段 | 預估時間 | 累計時間 | 狀態 |
|------|---------|---------|------|
| Phase 0: 專案設定 | 1-2 天 | 1-2 天 | 必須 |
| Phase 1: 型別系統 | 1 天 | 2-3 天 | 必須 |
| Phase 2: API 客戶端（含錯誤處理）| 2-3 天 | 4-6 天 | 必須 |
| Phase 3: 認證模組 | 2-3 天 | 6-9 天 | 必須 |
| Phase 4: 使用者列表 | 2-3 天 | 8-12 天 | 必須 |
| Phase 5: 頁面與路由 | 2-3 天 | 10-15 天 | 必須 |
| **Phase 8: CI/CD 與 Vercel 部署** | **1-2 天** | **11-17 天** | **必須** |
| **MVP 核心功能完成** | **11-17 天** | — | — |
| Phase 6: UI 優化（RWD + A11y）| 3-4 天 | 14-21 天 | 建議 |
| Phase 7: 測試與效能 | 3-4 天 | 17-25 天 | 建議 |
| **完整 MVP（含 UX 優化）** | **17-25 天** | — | — |
| Phase 8+: 可觀測性進階 | 1-2 天 | 18-27 天 | 可選 |
| Phase 9: 進階功能（可選）| 依需求 | — | 可選 |

> **注意**:
> - Phase 8（CI/CD + Vercel 部署）已提前至 Phase 5 之後，作為**交付必要項目**
> - Phase 0-5 + Phase 8 = **MVP 核心功能**（11-17 天）
> - 加上 Phase 6-7 = **完整 MVP**（17-25 天，含 UX 優化）
> - 以上時程為預估值，實際時間會因開發者經驗、需求變更等因素有所不同

---

**建立日期**: 2026-03-03
**最後更新**: 2026-03-04
**負責人**: Development Team
**版本**: v2.2 - 更新各 Phase 實際完成狀態（Phase 0-6、Phase UX、Phase 8 已完成；Phase 7 進行中）
