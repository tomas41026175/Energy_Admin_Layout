# 測試規範（TDD 強制）

## TDD 強制工作流程

**必須遵循 RED → GREEN → REFACTOR：**

1. 先寫測試（RED — 測試必須失敗）
2. 寫最小實作讓測試通過（GREEN）
3. 重構（REFACTOR — 確保測試仍通過）

禁止先寫實作再補測試。

## 工具

- **框架**: Vitest
- **API Mock**: MSW (Mock Service Worker)
- **元件測試**: React Testing Library
- **目標覆蓋率**: 70-80%

## 測試分層

### Unit Tests（單元）
- API 函式、Schema、Type Guards、Utility 函式
- 不依賴 DOM，純邏輯測試

### Integration Tests（整合）
- TanStack Query Hooks（搭配 MSW mock）
- Token 刷新流程
- 認證流程

### Component Tests（元件）
- 使用 React Testing Library（行為驅動，不測實作細節）
- 測試 Loading / Error / Empty 狀態

## 目錄結構

```
src/
└── domains/users/
    ├── users.api.ts
    └── __tests__/
        ├── users.api.test.ts        # unit
        └── users.hooks.test.ts      # integration
```

## MSW 設定

```ts
// src/shared/mocks/handlers.ts
export const handlers = [
  http.get('/api/users', () =>
    HttpResponse.json({ users: mockUsers, total: 10 })
  ),
];
```

## 測試規則

- 測試檔與源碼放同目錄下的 `__tests__/`
- 每個測試只驗證一件事
- 禁止測試實作細節（用 `getByRole`, `getByText`，不用 `getByTestId`）
- API 測試一律使用 MSW，不直接 mock axios
