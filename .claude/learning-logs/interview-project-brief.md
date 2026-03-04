# Energy Admin — 面試專案介紹備忘錄（含實作細節）

> 用途：面試時介紹 Energy Admin 專案，每個重點都附上實際程式碼。

---

## 一句話定位

> 「這是一個生產級後台使用者管理系統，從零建立完整的前端架構：Auth + Token 刷新、TDD 測試 265 tests / 99.8% 覆蓋率、RWD + A11y，並部署至 Vercel 搭配 GitHub Actions CI/CD。」

---

## 1. Token 刷新機制（Race Condition 防護）

**問題**：多個請求同時 401，若每個都觸發 Refresh 會導致 Token 消耗衝突。

**解法**：`isRefreshing` flag + 請求佇列（immutable pattern，不 push）。

```ts
// src/shared/api/interceptor.ts

interface QueueItem {
  resolve: (token: string) => void
  reject: (err: unknown) => void
}

let isRefreshing = false
let failedQueue: QueueItem[] = []

const processQueue = (error: unknown, token: string | null = null): void => {
  const queue = [...failedQueue]   // 取出後清空（immutable）
  failedQueue = []
  queue.forEach((item) => {
    if (error) item.reject(error)
    else if (token) item.resolve(token)
  })
}

apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config
    const isTokenExpired =
      error.response?.status === 401 && error.response?.data?.code === 'TOKEN_EXPIRED'
    const isRefreshRequest = originalRequest.url?.includes('/auth/refresh')

    if (!isTokenExpired || isRefreshRequest) {
      return Promise.reject(normalizeAxiosError(error))
    }

    // 已有其他請求在刷新：排隊等候
    if (isRefreshing) {
      return new Promise<string>((resolve, reject) => {
        failedQueue = [...failedQueue, { resolve, reject }]  // spread，不 push
      }).then((token) => {
        originalRequest.headers.Authorization = `Bearer ${token}`
        return apiClient(originalRequest)
      })
    }

    isRefreshing = true
    try {
      const refreshToken = tokenStore.getRefreshToken()
      if (!refreshToken) throw new AuthError('No refresh token available')

      const response = await apiClient.post('/auth/refresh', { refresh_token: refreshToken })
      const { access_token } = response.data

      tokenStore.setAccessToken(access_token)
      processQueue(null, access_token)   // 通知所有排隊請求
      originalRequest.headers.Authorization = `Bearer ${access_token}`
      return apiClient(originalRequest)  // 重試原始請求
    } catch (refreshError) {
      processQueue(refreshError, null)   // 全部 reject
      tokenStore.clearAll()
      return Promise.reject(new AuthError('Session expired'))
    } finally {
      isRefreshing = false
    }
  },
)
```

**面試重點**：
- `failedQueue = [...failedQueue, { resolve, reject }]`：不 push，符合 immutable 原則
- `finally { isRefreshing = false }`：無論成功失敗都重置 flag，防止死鎖
- Refresh 請求本身(`/auth/refresh`)直接 reject，不進入刷新迴圈

---

## 2. Auth Store — Zustand + Session Restore

**設計**：Access Token 存 in-memory（Zustand），Refresh Token 存 localStorage，頁面重整透過 `restoreSession` 無感恢復。

```ts
// src/auth/auth.store.ts

const getStoredUser = (): AuthUser | null => {
  const stored = localStorage.getItem('auth_user')
  if (!stored) return null
  try {
    return authUserSchema.parse(JSON.parse(stored))  // Zod 驗證，防止舊格式污染
  } catch {
    return null
  }
}

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  isAuthenticated: false,
  isLoading: true,  // 初始 true，等 restoreSession 完成才決定

  login: async (data) => {
    const response = await authApi.login(data)
    tokenStore.setAccessToken(response.access_token)   // in-memory
    tokenStore.setRefreshToken(response.refresh_token) // localStorage
    setStoredUser(response.user)
    set({ user: response.user, isAuthenticated: true, isLoading: false })
  },

  logout: () => {
    tokenStore.clearAll()
    setStoredUser(null)
    set({ user: null, isAuthenticated: false, isLoading: false })
  },

  restoreSession: async () => {
    const refreshToken = tokenStore.getRefreshToken()
    if (!refreshToken) {
      set({ user: null, isAuthenticated: false, isLoading: false })
      return
    }
    try {
      const response = await authApi.refreshToken(refreshToken)
      tokenStore.setAccessToken(response.access_token)  // 換新的 access token
      const user = getStoredUser()
      if (user) {
        set({ user, isAuthenticated: true, isLoading: false })
      } else {
        tokenStore.clearAll()
        set({ user: null, isAuthenticated: false, isLoading: false })
      }
    } catch {
      tokenStore.clearAll()
      set({ user: null, isAuthenticated: false, isLoading: false })
    }
  },
}))
```

**Selector 模式**（避免非必要 re-render）：

```tsx
// ✅ 只訂閱需要的欄位
const user = useAuthStore((s) => s.user)
const logout = useAuthStore((s) => s.logout)

// ❌ 訂閱整個 store，任何欄位變動都會 re-render
const { user, logout } = useAuthStore()
```

---

## 3. AuthGuard — 路由守衛

**設計**：`isLoading` 期間顯示 Spinner，避免未登入的使用者看到 `/dashboard` 閃爍。

```tsx
// src/auth/auth.guard.tsx

export const AuthGuard = () => {
  const { isAuthenticated, isLoading } = useAuthStore()

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Spinner size="lg" className="text-blue-600" />
      </div>
    )
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  return <Outlet />  // 通過後渲染子路由
}
```

---

## 4. 路由架構 — 巢狀保護路由 + Code Splitting

```tsx
// src/app/router.tsx

// 路由層級 lazy loading，各頁面獨立 chunk
const LoginPage = lazy(() => import('@/pages/login'))
const DashboardPage = lazy(() => import('@/pages/dashboard'))
const UsersPage = lazy(() => import('@/pages/users'))

export const router = createBrowserRouter([
  { path: '/login', element: <Suspense><LoginPage /></Suspense> },

  {
    element: <AuthGuard />,      // 保護層：未登入 → /login
    children: [{
      element: <AppLayout />,    // Layout 層：Sidebar + Header + Outlet
      children: [
        { path: '/dashboard', element: <Suspense><DashboardPage /></Suspense> },
        { path: '/users',     element: <Suspense><UsersPage /></Suspense> },
        { path: '*',          element: <Navigate to="/dashboard" replace /> },
      ],
    }],
  },

  { path: '/',  element: <Navigate to="/login" replace /> },
  { path: '*',  element: <Navigate to="/login" replace /> },
])
```

**路由層級**：`/ → /login → AuthGuard → AppLayout → 各頁面`

---

## 5. URL 作為篩選狀態唯一來源

**問題**：用 `useState` 管篩選條件，重整頁面後丟失，也無法分享連結。

**解法**：`useSearchParams`，URL 即狀態。

```tsx
// src/pages/users.tsx

const UsersPage = () => {
  const [searchParams, setSearchParams] = useSearchParams()

  // URL 是唯一真相來源
  const searchInput = searchParams.get('q') ?? ''
  const statusFilter = (searchParams.get('status') ?? '') as UserStatus | ''
  const page = Number(searchParams.get('page') ?? '1')
  const limit = Number(searchParams.get('limit') ?? '10')

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
    setSearchParams(
      (prev) => {
        const next = new URLSearchParams(prev)
        if (e.target.value) next.set('q', e.target.value)
        else next.delete('q')
        next.delete('page')  // 搜尋時重置頁碼
        return next
      },
      { replace: true },  // 不污染瀏覽器歷史
    )
  }

  // 含 @ → 路由至 email；否則路由至 name
  const isEmailSearch = debouncedSearch.includes('@')

  const tableParams = useMemo(() => ({
    page,
    limit,
    ...(debouncedSearch
      ? isEmailSearch ? { email: debouncedSearch } : { name: debouncedSearch }
      : {}),
    ...(statusFilter ? { status: statusFilter } : {}),
  }), [page, limit, debouncedSearch, isEmailSearch, statusFilter])
  // ...
}
```

**鍵盤快捷鍵**（`/` 聚焦搜尋，`Esc` 清除）：

```tsx
useKeyboard('/', () => searchInputRef.current?.focus())
useKeyboard('Escape', () => { if (searchInput) handleClearSearch() })
```

---

## 6. useUsers Hook — 分頁預取 + keepPreviousData

```ts
// src/domains/users/users.hooks.ts

export const useUsers = (params: UsersParams) => {
  const queryClient = useQueryClient()

  const query = useQuery({
    queryKey: ['users', params],
    queryFn: () => usersApi.getUsers(params),
    staleTime: QUERY_STALE_TIME,   // 30 秒內不重複請求
    placeholderData: keepPreviousData,  // 翻頁時舊資料保留，避免白屏
  })

  // 預取下一頁 — 此處 useEffect 合理：prefetch 是 cache side effect，無 Query-native 替代
  useEffect(() => {
    const nextPage = (params.page ?? 1) + 1
    if (query.data && nextPage <= query.data.pagination.total_pages) {
      void queryClient.prefetchQuery({
        queryKey: ['users', { ...params, page: nextPage }],
        queryFn: () => usersApi.getUsers({ ...params, page: nextPage }),
        staleTime: QUERY_STALE_TIME,
      })
    }
  }, [query.data, params, queryClient])

  return query
}
```

**效果**：
- `keepPreviousData`：翻頁時舊資料保留至新資料到達，搭配 `isPlaceholderData` 顯示 Spinner
- `prefetchQuery`：停留當頁時預取下一頁，多數情況翻頁無 loading

---

## 7. UsersTable — 狀態分支 + Client-side 排序

```tsx
// src/domains/users/UsersTable.tsx（核心邏輯）

export const UsersTable = ({ params, onPageChange, searchQuery }: UsersTableProps) => {
  const { data, isLoading, isError, error, refetch, isPlaceholderData } = useUsers(params)
  const [sortField, setSortField] = useState<SortField | null>(null)
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc')

  // Client-side 排序（API 不支援 sort 參數，僅影響當前頁）
  const sortedUsers = useMemo(() => {
    if (!data?.data || !sortField) return data?.data ?? []
    return [...data.data].sort((a, b) => {
      const aVal = a[sortField]
      const bVal = b[sortField]
      const cmp =
        typeof aVal === 'number' && typeof bVal === 'number'
          ? aVal - bVal
          : String(aVal).localeCompare(String(bVal))
      return sortOrder === 'asc' ? cmp : -cmp
    })
  }, [data?.data, sortField, sortOrder])

  // 狀態分支（順序重要：先判斷 isLoading，再 isError，再 empty）
  if (isLoading && !data) return <SkeletonTable />
  if (isError) return <ErrorMessage message={error?.message} onRetry={() => void refetch()} />
  if (!data || data.data.length === 0) {
    return searchQuery
      ? <EmptyState title="找不到符合的使用者" description={`找不到符合「${searchQuery}」的使用者`} />
      : <EmptyState title="找不到使用者" description="目前沒有使用者資料。" />
  }

  return (
    <div className={cn('relative', isPlaceholderData && 'opacity-60')}>
      {/* 翻頁 loading 指示（isPlaceholderData = 快取資料顯示中，新資料尚未到達）*/}
      {isPlaceholderData && (
        <div className="absolute top-2 right-2 z-10"><Spinner size="sm" /></div>
      )}
      <p className="text-sm text-gray-500 mb-3">共 {data.pagination.total} 筆結果</p>

      {/* 桌面版表格 / 手機版卡片 */}
      <div className="hidden sm:block">{/* table */}</div>
      <div className="sm:hidden space-y-3">{/* mobile cards */}</div>

      <Pagination ... />
    </div>
  )
}
```

**分頁省略號演算法**：

```ts
const getPageWindow = (current: number, total: number): (number | '...')[] => {
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
  if (current <= 4) return [1, 2, 3, 4, 5, '...', total]
  if (current >= total - 3) return [1, '...', total - 4, total - 3, total - 2, total - 1, total]
  return [1, '...', current - 1, current, current + 1, '...', total]
}
```

---

## 8. AppLayout — Offline Banner + Sticky Header

```tsx
// src/app/layout/AppLayout.tsx

export const AppLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false)

  // Zustand Selector 模式：只訂閱需要的欄位
  const user = useAuthStore((s) => s.user)
  const logout = useAuthStore((s) => s.logout)

  const { isOnline } = useNetworkStatus()  // useSyncExternalStore 實作

  return (
    <div className="flex min-h-screen bg-gray-50">
      <Sidebar
        isOpen={sidebarOpen}
        collapsed={sidebarCollapsed}
        onClose={() => setSidebarOpen(false)}
        onToggleCollapse={() => setSidebarCollapsed((prev) => !prev)}
      />

      <div className="flex flex-col flex-1 min-w-0">
        {/* 離線 Banner */}
        {!isOnline && (
          <div role="alert" className="bg-yellow-50 border-b border-yellow-200 ...">
            ⚠️ 目前離線，顯示的資料可能不是最新
          </div>
        )}

        {/* Sticky Header：z-10，低於手機版 Sidebar overlay（z-40）*/}
        <header className="h-16 bg-white border-b ... sticky top-0 z-10">
          {/* Hamburger（手機專用）*/}
          <button className="lg:hidden ..." onClick={() => setSidebarOpen(true)} aria-label="開啟選單">
            {/* SVG */}
          </button>
          <Button variant="ghost" onClick={handleLogout}>登出</Button>
        </header>

        <main className="flex-1 p-4 sm:p-6">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
```

---

## 9. useNetworkStatus — useSyncExternalStore

**設計**：不用 `useEffect + useState`，改用 React 18 原生的 `useSyncExternalStore`，保證 Server/Client 一致性且無 hydration mismatch。

```ts
// src/shared/hooks/useNetworkStatus.ts

const subscribe = (callback: () => void): (() => void) => {
  window.addEventListener('online', callback)
  window.addEventListener('offline', callback)
  return () => {
    window.removeEventListener('online', callback)
    window.removeEventListener('offline', callback)
  }
}

const getSnapshot = (): boolean => navigator.onLine

export const useNetworkStatus = (): { isOnline: boolean } => {
  const isOnline = useSyncExternalStore(subscribe, getSnapshot)
  return { isOnline }
}
```

**vs 傳統寫法的差別**：

```tsx
// ❌ 傳統（useEffect）：SSR 不安全，初始值可能不一致
const [isOnline, setIsOnline] = useState(true)
useEffect(() => {
  window.addEventListener('online', () => setIsOnline(true))
  window.addEventListener('offline', () => setIsOnline(false))
}, [])

// ✅ useSyncExternalStore：React 官方推薦的外部 store 訂閱方式
const isOnline = useSyncExternalStore(subscribe, getSnapshot)
```

---

## 10. Dashboard — 多 Query 設計

```tsx
// src/pages/dashboard.tsx

// 4 個獨立 useUsers()，各 dataset 不同（total/active/inactive/recent-5）
// TanStack Query 以 queryKey 快取，staleTime=30s 防止重複請求
const DashboardPage = () => {
  const totalQuery    = useUsers({})
  const activeQuery   = useUsers({ status: 'active' })
  const inactiveQuery = useUsers({ status: 'inactive' })
  const recentQuery   = useUsers({ page: 1, limit: 5 })

  const statsLoading = totalQuery.isLoading || activeQuery.isLoading || inactiveQuery.isLoading

  return (
    <div className="space-y-6">
      {/* Stat Cards：各自處理 isLoading / isError */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <StatCard
          label="總使用者"
          value={totalQuery.data?.pagination.total}
          isLoading={statsLoading}
          isError={totalQuery.isError}
          colorClass="text-blue-600"
        />
        {/* active / inactive ... */}
      </div>

      {/* Recharts 圓餅圖：aria-hidden 防止 SVG 垃圾被 Screen Reader 讀取 */}
      <div aria-hidden="true" className="outline-none">
        <ResponsiveContainer width="100%" height={200}>
          <PieChart style={{ outline: 'none' }}>
            <Pie data={data} innerRadius={50} outerRadius={80} dataKey="value" label={...}>
              {data.map((_, i) => <Cell key={i} fill={PIE_COLORS[i]} />)}
            </Pie>
            <Tooltip formatter={(v) => `${v} 人`} />
          </PieChart>
        </ResponsiveContainer>
      </div>

      {/* Recent Users：isError 顯示重試按鈕 */}
      {recentQuery.isError ? (
        <ErrorMessage onRetry={() => void recentQuery.refetch()} />
      ) : (
        recentQuery.data?.data.map((user) => <RecentUserRow key={user.id} user={user} />)
      )}
    </div>
  )
}
```

---

## 11. 測試策略

**工具**：Vitest + MSW + React Testing Library

**MSW 設定**（在 network 層攔截，不 mock axios）：

```ts
// src/shared/mocks/handlers.ts
export const handlers = [
  http.get(`${API_BASE_URL}/api/users`, ({ request }) => {
    const url = new URL(request.url)
    const name = url.searchParams.get('name') ?? ''
    const status = url.searchParams.get('status') ?? ''
    const filtered = MOCK_USERS.filter((u) =>
      (!name || u.name.toLowerCase().includes(name.toLowerCase())) &&
      (!status || u.status === status)
    )
    return HttpResponse.json({ data: paginated, pagination: { ... } })
  }),
]

// src/test/server.ts
export const server = setupServer(...handlers)
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }))
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
```

**整合測試範例（Token 刷新並發）**：

```ts
it('只觸發一次 Refresh，並發請求依序重試', async () => {
  let refreshCallCount = 0
  server.use(
    http.post('/auth/refresh', () => {
      refreshCallCount++
      return HttpResponse.json({ access_token: 'new-token' })
    }),
  )

  // 同時發出 3 個請求
  const [r1, r2, r3] = await Promise.all([
    apiClient.get('/api/users'),
    apiClient.get('/api/users'),
    apiClient.get('/api/users'),
  ])

  expect(refreshCallCount).toBe(1)  // 關鍵斷言：只 refresh 一次
  expect(r1.status).toBe(200)
  expect(r2.status).toBe(200)
  expect(r3.status).toBe(200)
})
```

**覆蓋率**：265 tests，Statements 99.8%，Branches 99.13%

---

## 12. 常見面試問答

### Q：Token 刷新最複雜的地方？
> 「Race Condition。5 個請求同時 401，每個都去打 Refresh 會讓第二個 Refresh 因 Token 已消耗而失敗。我用 `isRefreshing` flag 和請求佇列解決：第一個 401 觸發 Refresh，其餘進入 `failedQueue`；刷新完後 `processQueue` 依序 resolve，每個排隊請求拿到新 Token 後重試原始請求。關鍵是 `finally { isRefreshing = false }`，無論成功失敗都重置，防止死鎖。」

### Q：為什麼用 URL 而不是 useState 管篩選？
> 「useState 重整後丟失，也無法分享連結。URL 是天然的狀態持久化層，`useSearchParams` 作為唯一真相來源：搜尋、狀態、頁碼、每頁筆數全部存在 URL，使用者可以複製連結、瀏覽器前進後退都正確。`replace: true` 確保每次輸入不會堆積歷史記錄。」

### Q：Dashboard 4 個 useUsers() 不是浪費請求？
> 「不是，因為 4 個 dataset 完全不同：total（無篩選）、active、inactive、recent-5 筆，合併需要改 API 設計，不值得。TanStack Query 以 queryKey 快取，staleTime=30 秒內不重複請求，使用者打開 Dashboard 後短時間切換頁面不會重打 API。」

### Q：Client-side 排序有什麼限制？
> 「只排序當前頁，跨頁排序需要 API 支援 sort 參數。我在程式碼加了注釋說明此限制（`// sorts only within the current page`），UI 上也沒有呈現『全域排序』的假象。這是 API 能力邊界內的合理決策。」

### Q：useNetworkStatus 為什麼用 useSyncExternalStore 而不是 useEffect？
> 「`useEffect` 在 SSR 不安全，初始值和 server render 可能不一致。`useSyncExternalStore` 是 React 18 官方推薦的外部 store 訂閱方式，能保證 client/server 快照一致，且訂閱/取消訂閱的邏輯更清晰。」

---

## 數字備忘

| 指標 | 數字 |
|------|------|
| 測試數量 | 265 tests，27 個檔案 |
| 覆蓋率（Statements） | 99.8% |
| 覆蓋率（Branches） | 99.13% |
| Access Token 有效期 | 300 秒（in-memory）|
| staleTime | 30 秒 |
| UX 優化項目 | 12 項 |
| PAGE_SIZE_OPTIONS | 10 / 25 / 50 |
| Sidebar 收合寬度 | w-64 ↔ w-16 |
| z-index 層級 | Header: 10，手機 Sidebar: 40 |
