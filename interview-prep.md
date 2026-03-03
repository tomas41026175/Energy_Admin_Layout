# Energy Admin — 技術面試備忘錄

> 專案：[Energy Admin](https://github.com/tomas41026175/Energy_Admin) — 後台使用者管理系統
> 技術棧：React 18 + TypeScript + Vite + TanStack Query v5 + Zustand + Axios + Zod + Tailwind CSS + Vitest + MSW + Recharts
> 規模：265 tests pass，30 test files，覆蓋率 99%+

---

## 一、專案一句話介紹

「我獨立設計並實作了一套生產級後台管理系統，從架構設計到 CI/CD 部署，包含 Token 刷新機制、TanStack Query 狀態管理、完整測試覆蓋，以及 12 項 UX 優化。」

---

## 二、高頻問題 × STAR 答法

---

### Q1. 你們的 Token 刷新機制是怎麼設計的？有沒有遇到 Race Condition？

**Situation**
API 的 Access Token 只有 300 秒有效，多個 API 同時發出時，若 Token 恰好過期，會有多個請求同時觸發刷新，導致重複呼叫 `/auth/refresh`，或部分請求拿到舊 Token 失敗。

**Task**
設計一個機制，確保同一時間只有一個刷新請求在飛，其餘請求排隊等候，刷新成功後全部重試。

**Action**
```ts
// 核心邏輯：interceptor.ts
let isRefreshing = false
let requestQueue: QueuedRequest[] = []

// 401 攔截器
if (!isRefreshing) {
  isRefreshing = true
  const newToken = await authApi.refreshToken(refreshToken)
  // 通知佇列中所有請求繼續
  requestQueue.forEach(({ resolve }) => resolve(newToken))
  requestQueue = []
  isRefreshing = false
} else {
  // 排隊等待
  return new Promise((resolve, reject) => {
    requestQueue.push({ resolve, reject })
  })
}
```

**Result**
- 並發場景下只觸發一次 `/auth/refresh`
- 所有排隊請求在刷新後自動重試，使用者無感知
- 整合測試 100% 覆蓋，含並發競態條件場景

---

### Q2. 為什麼用 TanStack Query，而不用 Redux 或直接 useEffect fetch？

**Situation**
需要管理 API 資料的快取、Loading/Error 狀態、分頁、背景更新等，如果純用 useEffect，每個頁面都要手寫大量 boilerplate。

**Task**
選擇合適的 Server State 管理工具。

**Action**
採用 TanStack Query，並充分利用以下功能：
- `staleTime: 30_000`：30 秒內不重複 fetch，減少 API 壓力
- `placeholderData: keepPreviousData`：翻頁時保留舊資料，等新資料到再替換（無閃白屏）
- `prefetchQuery`：停留當前頁時預取下一頁，翻頁近乎即時
- `queryKey: ['users', params]`：params 變化自動重新 fetch，無需手動管理依賴

**Result**
- 移除所有 useEffect + fetch 模式（專案強制規則）
- Dashboard 4 個統計數字用 4 個獨立 `useUsers()` call，每個 queryKey 不同，TanStack Query 自動去重快取
- isPlaceholderData Spinner：翻頁時顯示右上角 loading 而非全頁 skeleton，體驗更平滑

---

### Q3. 你的測試策略是什麼？為什麼選擇 MSW？

**Situation**
需要測試 API Hook（`useUsers`）和頁面元件，但不能直接呼叫真實 API，也不想 mock axios 導致測試過於脆弱。

**Task**
建立穩健的測試策略，覆蓋 Unit / Integration / Component 三層。

**Action**
```
Unit:        users.api.ts、schemas、type-guards（純邏輯）
Integration: useUsers hook、Token 刷新流程（搭配 MSW）
Component:   UsersTable.tsx、users.tsx（React Testing Library，行為驅動）
```

MSW（Mock Service Worker）在 Node 層攔截 HTTP 請求，而非 mock axios。
這讓測試更接近真實行為，同時可以模擬不同 API 回應（成功/失敗/邊界條件）。

**Result**
- 265 tests，30 files，覆蓋率 99%+
- 關鍵原則：`getByRole` / `getByText`，禁止 `getByTestId`（避免測試實作細節）

---

### Q4. 狀態管理怎麼分層？什麼時候用 Zustand，什麼時候用 TanStack Query？

**原則**：Server State 和 Client State 嚴格分離。

| 狀態類型 | 工具 | 範例 |
|---------|------|------|
| Server State（API 資料）| TanStack Query | 使用者列表、分頁 |
| Global Client State | Zustand | 登入使用者、Auth Token |
| Local State | useState | 搜尋輸入（暫存）、Modal 開關 |
| URL State | useSearchParams | 搜尋條件、頁碼、篩選 |

**補充**：URL State 是 UX 優化中的重要決策——以 URL 作為篩選條件的唯一狀態來源，使用者可以分享連結、重整頁面保留條件、瀏覽器前進/後退正常。

---

### Q5. 你有沒有做過 UX 優化？舉例說明。

**Situation**
基礎功能完成後，使用者體驗還有明顯改善空間：搜尋無法清除、翻頁有白屏閃爍、沒有鍵盤快捷鍵、離線無提示。

**Task**
在 API 限制下（只有 GET /api/users），盡可能提升使用體驗。

**Action**（12 項，以 3 個最有代表性為例）

1. **URL Query Params 同步**
   `useSearchParams` 取代 `useState`。URL 即狀態，可分享、可重整、歷史記錄正常。

2. **分頁預取（Prefetch）**
   停留當前頁時，背景預取下一頁資料進 QueryClient cache。翻頁時命中 cache，載入近乎即時。

3. **差異化 Empty State**
   有搜尋條件時顯示「找不到符合『alice』的使用者，請嘗試其他關鍵字」；無條件時顯示「目前沒有使用者資料」。Context-aware 的提示比通用訊息更易用。

**Result**
- 12 項 UX 優化全部落地，265 tests 覆蓋所有新功能
- 每個功能都有對應測試（sort / spinner / offline banner / collapse / pie chart）

---

### Q6. TypeScript strict mode 在實務上對你有什麼幫助？遇過什麼挑戰？

**幫助**
- 強迫定義明確型別，API 回應用 Zod schema 推導：`z.infer<typeof UsersResponseSchema>`
- 禁止 `any`，改用 `unknown + type guard`，讓錯誤處理更安全
- 函式參數和回傳型別明確，閱讀程式碼不需要猜測

**挑戰與解法**
- Axios error 的型別不明確 → 自定義 `normalizeAxiosError()` 函式，統一轉為內部錯誤型別
- TanStack Query 的 `data` 有可能是 `undefined` → 利用 `placeholderData: keepPreviousData` 減少 undefined guard 的頻率

---

### Q7. 你如何確保元件的可維護性和可讀性？

**原則**：

1. **Domain-driven 結構**
   `domains/users/` 包含 types / schemas / api / hooks / components，不跨 domain 直接 import

2. **單一職責**
   `pages/users.tsx` 只負責狀態聚合和 URL 同步；業務邏輯在 hooks；UI 邏輯在 components

3. **禁止 useEffect 原則**
   資料 fetch 用 TanStack Query，副作用用 `onSuccess` callback。
   例外：window event listener（useKeyboard hook）、prefetch（useEffect 有說明 comment）

4. **測試即文件**
   測試名稱描述行為，不描述實作：
   `it('shows differentiated empty state when no users with search query')`

---

### Q8. 你怎麼處理 API 不支援某功能的限制？

**具體案例：API 不支援 sort 參數**

**Situation**
使用者需要能依 ID / 姓名 / 建立日期排序，但 API 只支援 page / limit / name / email / status。

**Action**
Client-side sort：在前端用 `useMemo` 對當前頁資料排序，並在 UI 加上明確限制說明 comment：
```ts
// Client-side sort — 僅影響當前頁（API 無 sort 支援）
const sortedUsers = useMemo(() => { ... }, [data?.data, sortField, sortOrder])
```
Table header 加 ▲▼ 指示器，視覺上清楚。

**Result**
功能可用，但對跨頁排序的限制是已知 trade-off，非 bug。

---

### Q9. CI/CD 流程是怎麼設計的？

**架構**：GitHub Actions + Vercel

- PR → GitHub Actions 自動跑：`npm run lint` → `tsc --noEmit` → `npx vitest run` → `npm run build`
- merge to main → Vercel 自動 Production 部署
- PR → Vercel 自動 Preview 部署

**vercel.json 關鍵設定**：
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }],
  "headers": [{ "source": "/(.*)", "headers": [
    { "key": "X-Frame-Options", "value": "DENY" },
    { "key": "X-Content-Type-Options", "value": "nosniff" }
  ]}]
}
```
SPA rewrites 讓 `/users` 直接訪問不會 404。

---

### Q10. 你的 Code Review 或程式碼品質管理習慣？

1. **Commit 前**：lint + type check + tests（hook 強制執行）
2. **Branch 保護**：自定義 pre-bash hook，禁止在 main 直接 commit
3. **PR 描述**：包含驗收標準勾選清單、覆蓋率數字、設計稿對照
4. **Code Review 重點**：非任務相關的檔案是否意外納入、trailing space 差異、命名一致性
5. **測試先行（TDD）**：先 RED → 再 GREEN → 再 REFACTOR，禁止先寫實作再補測試

---

## 三、技術亮點（可主動提起）

| 亮點 | 說明 |
|------|------|
| Token 刷新競態解決 | Refresh Lock + Request Queue，並發安全 |
| 測試覆蓋率 99%+ | 265 tests，MSW，行為驅動，無 `getByTestId` |
| URL as State | useSearchParams，篩選可分享/重整 |
| 分頁預取 | keepPreviousData + prefetchQuery，翻頁體驗平滑 |
| Zod runtime 驗證 | API 回應型別由 schema 推導，catch runtime 錯誤 |
| Client-side sort | API 限制下的合理 trade-off，有文件說明 |
| 12 項 UX 優化 | 每項有對應測試 |

---

## 四、可能被追問的細節

**Q: `keepPreviousData` 和 `initialData` 有什麼差別？**
`keepPreviousData`（v5 叫 `placeholderData: keepPreviousData`）會在 queryKey 變化時保留上一次的資料，直到新資料到達。`initialData` 是給定一個初始值，會被當作有效快取（影響 staleTime 計算）。分頁場景用 `keepPreviousData` 更合適。

**Q: Zod 和 TypeScript type 的差別？**
TypeScript type 只在編譯時存在（compile-time）。API 回應在 runtime 可能與宣告型別不符，Zod schema 在 runtime 做驗證，catch 實際不符合預期的資料。

**Q: 為什麼不用 Redux？**
Server State 用 TanStack Query 已經解決。Client State 只有 Auth 需要全域，Zustand 足夠（< 1KB）。Redux 的 action/reducer 模式在這個規模是 over-engineering。

**Q: useSearchParams 的 `replace: true` 是幹嘛的？**
避免每次輸入搜尋字符就在 history 留一筆，導致按「上一頁」要連按很多次才能真正回到上一頁。

**Q: MSW 和 mock axios 的差別？**
MSW 在 Service Worker（browser）或 Node interceptor 層攔截真實 HTTP 請求，測試行為更接近真實環境。mock axios 直接替換函式，可能遺漏 interceptor 邏輯（例如 Token 刷新），測試覆蓋範圍較窄。

---

**最後更新**: 2026-03-03
**對應專案**: https://github.com/tomas41026175/Energy_Admin
