# 任務詳細分解 - 驗收標準、文件與技能

> 每個任務的詳細驗收標準、參考文件和所需技能

**版本**: v1.0
**建立日期**: 2026-03-03
**最後更新**: 2026-03-03

---

## 📚 目錄

- [Phase 0: 專案設定](#phase-0-專案設定)
- [Phase 1: 型別系統建立](#phase-1-型別系統建立)
- [Phase 2: API 客戶端建立](#phase-2-api-客戶端建立)
- [Phase 3: 認證模組實作](#phase-3-認證模組實作)
- [Phase 4: 使用者列表功能](#phase-4-使用者列表功能)
- [Phase 5: 頁面與路由](#phase-5-頁面與路由)
- [Phase 6: UI 優化](#phase-6-ui-優化)
- [Phase 7: 測試完善與效能優化](#phase-7-測試完善與效能優化)
- [Phase 8: CI/CD 與 Vercel 部署](#phase-8-cicd-與-vercel-部署)

---

# Phase 0: 專案設定

## 0.1 專案初始化

### 📋 任務：使用 Vite 建立專案

**驗收標準**：
- [ ] 執行 `npm create vite@latest` 成功
- [ ] 選擇 `React` + `TypeScript` 模板
- [ ] 專案目錄結構正確
  ```
  energy-admin/
  ├── src/
  ├── public/
  ├── index.html
  ├── package.json
  ├── vite.config.ts
  └── tsconfig.json
  ```
- [ ] 執行 `npm run dev` 可以啟動開發伺服器
- [ ] 瀏覽器訪問 `http://localhost:5173` 可以看到預設頁面

**相關文件**：
- [Vite 官方文檔](https://vitejs.dev/guide/)
- [Vite + React + TypeScript 教學](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)

**所需技能**：
- Node.js 基礎
- npm/yarn/pnpm 套件管理
- 終端機基本操作

**預估時間**: 30 分鐘

---

### 📋 任務：安裝核心依賴

**驗收標準**：
- [ ] 所有核心依賴安裝成功
- [ ] `package.json` 包含以下依賴：
  ```json
  {
    "dependencies": {
      "react": "^18.2.0",
      "react-dom": "^18.2.0",
      "react-router-dom": "^6.20.0",
      "axios": "^1.6.0",
      "@tanstack/react-query": "^5.12.0",
      "zustand": "^4.4.0",
      "react-hook-form": "^7.48.0",
      "zod": "^3.22.0",
      "@hookform/resolvers": "^3.3.0"
    },
    "devDependencies": {
      "@types/react": "^18.2.0",
      "@types/react-dom": "^18.2.0",
      "@vitejs/plugin-react": "^4.2.0",
      "typescript": "^5.3.0",
      "vite": "^5.0.0"
    }
  }
  ```
- [ ] 執行 `npm install` 無錯誤
- [ ] `node_modules/` 目錄建立成功

**相關文件**：
- [React Router 文檔](https://reactrouter.com/)
- [Axios 文檔](https://axios-http.com/)
- [TanStack Query 文檔](https://tanstack.com/query/latest)
- [Zustand 文檔](https://zustand-demo.pmnd.rs/)
- [React Hook Form 文檔](https://react-hook-form.com/)
- [Zod 文檔](https://zod.dev/)

**所需技能**：
- npm 套件管理
- 理解前端生態系統
- 版本管理概念

**預估時間**: 30 分鐘

---

### 📋 任務：設定 TypeScript 配置

**驗收標準**：
- [ ] `tsconfig.json` 啟用 strict mode
  ```json
  {
    "compilerOptions": {
      "target": "ES2020",
      "lib": ["ES2020", "DOM", "DOM.Iterable"],
      "module": "ESNext",
      "skipLibCheck": true,
      "moduleResolution": "bundler",
      "allowImportingTsExtensions": true,
      "resolveJsonModule": true,
      "isolatedModules": true,
      "noEmit": true,
      "jsx": "react-jsx",
      "strict": true,
      "noUnusedLocals": true,
      "noUnusedParameters": true,
      "noFallthroughCasesInSwitch": true
    }
  }
  ```
- [ ] 執行 `tsc --noEmit` 無型別錯誤
- [ ] IDE（VS Code）顯示正確的型別提示

**相關文件**：
- [TypeScript 官方文檔](https://www.typescriptlang.org/docs/)
- [TypeScript Strict Mode](https://www.typescriptlang.org/tsconfig#strict)

**所需技能**：
- TypeScript 基礎
- tsconfig.json 配置
- 編譯選項理解

**預估時間**: 30 分鐘

---

### 📋 任務：設定路徑別名 (@/)

**驗收標準**：
- [ ] `tsconfig.json` 設定 paths
  ```json
  {
    "compilerOptions": {
      "baseUrl": ".",
      "paths": {
        "@/*": ["./src/*"]
      }
    }
  }
  ```
- [ ] `vite.config.ts` 設定 resolve.alias
  ```typescript
  import { defineConfig } from 'vite';
  import react from '@vitejs/plugin-react';
  import path from 'path';

  export default defineConfig({
    plugins: [react()],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
  });
  ```
- [ ] 可以使用 `import { ... } from '@/...'` 語法
- [ ] IDE 自動完成正常運作

**相關文件**：
- [Vite Resolve Alias](https://vitejs.dev/config/shared-options.html#resolve-alias)
- [TypeScript Path Mapping](https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping)

**所需技能**：
- Vite 配置
- TypeScript 路徑映射
- Node.js path 模組

**預估時間**: 30 分鐘

---

## 0.2 開發工具設定

### 📋 任務：設定 ESLint

**驗收標準**：
- [ ] 安裝 ESLint 相關套件
  ```bash
  npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react eslint-plugin-react-hooks
  ```
- [ ] 建立 `.eslintrc.cjs` 配置
  ```javascript
  module.exports = {
    root: true,
    env: { browser: true, es2020: true },
    extends: [
      'eslint:recommended',
      'plugin:@typescript-eslint/recommended',
      'plugin:react-hooks/recommended',
    ],
    ignorePatterns: ['dist', '.eslintrc.cjs'],
    parser: '@typescript-eslint/parser',
    plugins: ['react-refresh'],
    rules: {
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
      '@typescript-eslint/no-unused-vars': ['error', {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
      }],
    },
  };
  ```
- [ ] 執行 `npm run lint` 可以正常運作
- [ ] 加入 package.json scripts
  ```json
  {
    "scripts": {
      "lint": "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
      "lint:fix": "eslint . --ext ts,tsx --fix"
    }
  }
  ```

**相關文件**：
- [ESLint 官方文檔](https://eslint.org/docs/latest/)
- [typescript-eslint](https://typescript-eslint.io/)
- [eslint-plugin-react-hooks](https://www.npmjs.com/package/eslint-plugin-react-hooks)

**所需技能**：
- ESLint 配置
- Linting 規則理解
- TypeScript ESLint 整合

**預估時間**: 1 小時

---

### 📋 任務：設定 Prettier

**驗收標準**：
- [ ] 安裝 Prettier
  ```bash
  npm install -D prettier eslint-config-prettier
  ```
- [ ] 建立 `.prettierrc` 配置
  ```json
  {
    "semi": true,
    "trailingComma": "es5",
    "singleQuote": true,
    "printWidth": 80,
    "tabWidth": 2,
    "endOfLine": "lf"
  }
  ```
- [ ] 建立 `.prettierignore`
  ```
  dist
  node_modules
  .cache
  ```
- [ ] 加入 package.json scripts
  ```json
  {
    "scripts": {
      "format": "prettier --write \"src/**/*.{ts,tsx,css}\"",
      "format:check": "prettier --check \"src/**/*.{ts,tsx,css}\""
    }
  }
  ```
- [ ] 執行 `npm run format` 可以格式化程式碼
- [ ] ESLint 與 Prettier 無衝突

**相關文件**：
- [Prettier 官方文檔](https://prettier.io/docs/en/)
- [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier)

**所需技能**：
- Prettier 配置
- ESLint + Prettier 整合
- 程式碼格式化概念

**預估時間**: 30 分鐘

---

### 📋 任務：設定 Tailwind CSS

**驗收標準**：
- [ ] 安裝 Tailwind CSS
  ```bash
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
  ```
- [ ] 配置 `tailwind.config.js`
  ```javascript
  /** @type {import('tailwindcss').Config} */
  export default {
    content: [
      "./index.html",
      "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
      extend: {},
    },
    plugins: [],
  }
  ```
- [ ] 在 `src/index.css` 加入 Tailwind directives
  ```css
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
  ```
- [ ] 測試 Tailwind 類別可以正常運作
  ```tsx
  <div className="bg-blue-500 text-white p-4">
    Tailwind is working!
  </div>
  ```

**相關文件**：
- [Tailwind CSS 官方文檔](https://tailwindcss.com/docs/)
- [Tailwind + Vite 安裝指南](https://tailwindcss.com/docs/guides/vite)

**所需技能**：
- Tailwind CSS 基礎
- PostCSS 配置
- CSS-in-JS 概念

**預估時間**: 1 小時

---

### 📋 任務：設定 Git hooks (husky)

**驗收標準**：
- [ ] 安裝 husky 和 lint-staged
  ```bash
  npm install -D husky lint-staged
  npx husky install
  ```
- [ ] 建立 pre-commit hook
  ```bash
  npx husky add .husky/pre-commit "npx lint-staged"
  ```
- [ ] 配置 `package.json`
  ```json
  {
    "lint-staged": {
      "*.{ts,tsx}": [
        "eslint --fix",
        "prettier --write"
      ]
    }
  }
  ```
- [ ] commit 時自動執行 lint 和 format
- [ ] lint 錯誤會阻止 commit

**相關文件**：
- [Husky 官方文檔](https://typicode.github.io/husky/)
- [lint-staged](https://github.com/okonet/lint-staged)

**所需技能**：
- Git hooks 概念
- husky 配置
- lint-staged 使用

**預估時間**: 1 小時

---

## 0.3 測試環境設定

### 📋 任務：安裝 Vitest

**驗收標準**：
- [ ] 安裝 Vitest 相關套件
  ```bash
  npm install -D vitest @vitest/ui jsdom @testing-library/react @testing-library/jest-dom @testing-library/user-event
  ```
- [ ] 建立 `vitest.config.ts`
  ```typescript
  import { defineConfig } from 'vitest/config';
  import react from '@vitejs/plugin-react';
  import path from 'path';

  export default defineConfig({
    plugins: [react()],
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: './src/test/setup.ts',
      coverage: {
        provider: 'v8',
        reporter: ['text', 'json', 'html'],
      },
    },
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
  });
  ```
- [ ] 加入 package.json scripts
  ```json
  {
    "scripts": {
      "test": "vitest",
      "test:ui": "vitest --ui",
      "test:coverage": "vitest --coverage"
    }
  }
  ```

**相關文件**：
- [Vitest 官方文檔](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)

**所需技能**：
- Vitest 配置
- 測試框架概念
- Jest/Vitest API

**預估時間**: 1 小時

---

### 📋 任務：安裝 MSW (Mock Service Worker)

**驗收標準**：
- [ ] 安裝 MSW
  ```bash
  npm install -D msw
  ```
- [ ] 建立 `src/test/mocks/handlers.ts`
  ```typescript
  import { http, HttpResponse } from 'msw';

  export const handlers = [
    // Mock handlers will be added here
  ];
  ```
- [ ] 建立 `src/test/mocks/server.ts`
  ```typescript
  import { setupServer } from 'msw/node';
  import { handlers } from './handlers';

  export const server = setupServer(...handlers);
  ```
- [ ] 在測試 setup 中啟動 MSW
  ```typescript
  // src/test/setup.ts
  import '@testing-library/jest-dom';
  import { server } from './mocks/server';

  beforeAll(() => server.listen());
  afterEach(() => server.resetHandlers());
  afterAll(() => server.close());
  ```

**相關文件**：
- [MSW 官方文檔](https://mswjs.io/)
- [MSW + Vitest](https://mswjs.io/docs/integrations/node)

**所需技能**：
- MSW 概念
- API Mocking
- HTTP 請求攔截

**預估時間**: 1.5 小時

---

### 📋 任務：建立測試工具函式

**驗收標準**：
- [ ] 建立 `src/test/utils.tsx`
  ```typescript
  import { render, RenderOptions } from '@testing-library/react';
  import { ReactElement } from 'react';
  import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

  const createTestQueryClient = () =>
    new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false },
      },
    });

  export function renderWithProviders(
    ui: ReactElement,
    options?: Omit<RenderOptions, 'wrapper'>
  ) {
    const queryClient = createTestQueryClient();

    function Wrapper({ children }: { children: React.ReactNode }) {
      return (
        <QueryClientProvider client={queryClient}>
          {children}
        </QueryClientProvider>
      );
    }

    return { ...render(ui, { wrapper: Wrapper, ...options }), queryClient };
  }
  ```
- [ ] 建立範例測試檔案並通過
  ```typescript
  // src/test/example.test.tsx
  import { describe, it, expect } from 'vitest';
  import { renderWithProviders } from './utils';

  describe('Test Setup', () => {
    it('should render', () => {
      const { container } = renderWithProviders(<div>Test</div>);
      expect(container).toBeDefined();
    });
  });
  ```

**相關文件**：
- [Testing Library - Setup](https://testing-library.com/docs/react-testing-library/setup)
- [TanStack Query - Testing](https://tanstack.com/query/latest/docs/react/guides/testing)

**所需技能**：
- React Testing Library
- Test utilities 設計
- Provider 包裝

**預估時間**: 1 小時

---

# Phase 1: 型別系統建立

## 1.1 全域型別定義

### 📋 任務：建立 `types/global.d.ts`

**驗收標準**：
- [ ] 建立 `src/types/global.d.ts`
  ```typescript
  /// <reference types="vite/client" />

  interface ImportMetaEnv {
    readonly VITE_API_BASE_URL: string;
    // 其他環境變數...
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
  ```
- [ ] TypeScript 識別環境變數型別
- [ ] `import.meta.env.VITE_API_BASE_URL` 有型別提示

**相關文件**：
- [Vite - Env Variables and Modes](https://vitejs.dev/guide/env-and-mode.html)
- [TypeScript - Declaration Files](https://www.typescriptlang.org/docs/handbook/declaration-files/introduction.html)

**所需技能**：
- TypeScript Declaration Files
- Vite 環境變數
- Ambient Declarations

**預估時間**: 30 分鐘

---

### 📋 任務：建立 `types/common.ts`

**驗收標準**：
- [ ] 建立 `src/types/common.ts`
  ```typescript
  // Pagination
  export interface PaginationParams {
    page: number;
    limit: number;
  }

  export interface PaginatedResponse<T> {
    data: T[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  }

  // API Response
  export interface ApiResponse<T> {
    success: boolean;
    data?: T;
    error?: ApiError;
  }

  export interface ApiError {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  }

  // Async State
  export type AsyncStatus = 'idle' | 'loading' | 'success' | 'error';
  ```
- [ ] 型別可以被其他模組正確引用
- [ ] IDE 自動完成正常

**相關文件**：
- [TypeScript Handbook - Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)

**所需技能**：
- TypeScript Generics
- Interface vs Type
- 型別設計原則

**預估時間**: 1 小時

---

## 1.2 共用型別定義

### 📋 任務：建立 `shared/api/error.ts`

**驗收標準**：
- [ ] 建立 `src/shared/api/error.ts`
  ```typescript
  export enum ApiErrorCode {
    // Auth
    TOKEN_EXPIRED = 'TOKEN_EXPIRED',
    TOKEN_INVALID = 'TOKEN_INVALID',
    UNAUTHORIZED = 'UNAUTHORIZED',

    // Network
    NETWORK_ERROR = 'NETWORK_ERROR',
    TIMEOUT = 'TIMEOUT',

    // Validation
    VALIDATION_ERROR = 'VALIDATION_ERROR',

    // Server
    INTERNAL_SERVER_ERROR = 'INTERNAL_SERVER_ERROR',
    SERVICE_UNAVAILABLE = 'SERVICE_UNAVAILABLE',

    // Generic
    UNKNOWN_ERROR = 'UNKNOWN_ERROR',
  }

  export interface NormalizedError {
    code: ApiErrorCode;
    message: string;
    originalError?: unknown;
    details?: Record<string, unknown>;
  }

  export class AppError extends Error {
    public code: ApiErrorCode;
    public details?: Record<string, unknown>;

    constructor(code: ApiErrorCode, message: string, details?: Record<string, unknown>) {
      super(message);
      this.name = 'AppError';
      this.code = code;
      this.details = details;
    }
  }
  ```
- [ ] 錯誤型別定義完整
- [ ] 錯誤碼涵蓋所有常見情況

**相關文件**：
- [TypeScript - Enums](https://www.typescriptlang.org/docs/handbook/enums.html)
- [MDN - Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error)

**所需技能**：
- TypeScript Enums
- Error Handling 設計
- 自訂 Error 類別

**預估時間**: 1 小時

---

### 📋 任務：建立 `shared/api/types.ts`

**驗收標準**：
- [ ] 建立 `src/shared/api/types.ts`
  ```typescript
  import { ApiErrorCode } from './error';

  export interface ApiSuccessResponse<T> {
    success: true;
    data: T;
  }

  export interface ApiErrorResponse {
    success: false;
    error: {
      code: ApiErrorCode;
      message: string;
      details?: Record<string, unknown>;
    };
  }

  export type ApiResponse<T> = ApiSuccessResponse<T> | ApiErrorResponse;

  export interface RequestConfig {
    headers?: Record<string, string>;
    params?: Record<string, unknown>;
    timeout?: number;
  }
  ```
- [ ] 型別符合 API 規格（參考 docs/04-api-documentation.md）
- [ ] TypeScript discriminated unions 正確運作

**相關文件**：
- [TypeScript - Discriminated Unions](https://www.typescriptlang.org/docs/handbook/unions-and-intersections.html#discriminating-unions)
- 專案文件：`docs/04-api-documentation.md`

**所需技能**：
- TypeScript Discriminated Unions
- API 型別設計
- Generic Types

**預估時間**: 1 小時

---

### 📋 任務：建立 Type Guards (`shared/utils/type-guards.ts`)

**驗收標準**：
- [ ] 建立 `src/shared/utils/type-guards.ts`
  ```typescript
  import { ApiResponse, ApiErrorResponse, ApiSuccessResponse } from '@/shared/api/types';

  export function isApiError<T>(
    response: ApiResponse<T>
  ): response is ApiErrorResponse {
    return response.success === false;
  }

  export function isApiSuccess<T>(
    response: ApiResponse<T>
  ): response is ApiSuccessResponse<T> {
    return response.success === true;
  }

  export function isDefined<T>(value: T | null | undefined): value is T {
    return value !== null && value !== undefined;
  }
  ```
- [ ] Type Guards 正確運作
- [ ] TypeScript narrowing 正常

**相關文件**：
- [TypeScript - Type Guards](https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates)

**所需技能**：
- TypeScript Type Guards
- Type Predicates
- Type Narrowing

**預估時間**: 1 小時

---

## 1.3 型別測試

### 📋 任務：建立 Type Guards 單元測試

**驗收標準**：
- [ ] 建立 `src/shared/utils/__tests__/type-guards.test.ts`
  ```typescript
  import { describe, it, expect } from 'vitest';
  import { isApiError, isApiSuccess, isDefined } from '../type-guards';
  import { ApiErrorCode } from '@/shared/api/error';

  describe('Type Guards', () => {
    describe('isApiError', () => {
      it('should return true for error response', () => {
        const response = {
          success: false,
          error: {
            code: ApiErrorCode.UNKNOWN_ERROR,
            message: 'Test error',
          },
        };
        expect(isApiError(response)).toBe(true);
      });

      it('should return false for success response', () => {
        const response = {
          success: true,
          data: { id: 1 },
        };
        expect(isApiError(response)).toBe(false);
      });
    });

    describe('isApiSuccess', () => {
      it('should return true for success response', () => {
        const response = {
          success: true,
          data: { id: 1 },
        };
        expect(isApiSuccess(response)).toBe(true);
      });

      it('should return false for error response', () => {
        const response = {
          success: false,
          error: {
            code: ApiErrorCode.UNKNOWN_ERROR,
            message: 'Test error',
          },
        };
        expect(isApiSuccess(response)).toBe(false);
      });
    });

    describe('isDefined', () => {
      it('should return true for defined values', () => {
        expect(isDefined(0)).toBe(true);
        expect(isDefined('')).toBe(true);
        expect(isDefined(false)).toBe(true);
      });

      it('should return false for null or undefined', () => {
        expect(isDefined(null)).toBe(false);
        expect(isDefined(undefined)).toBe(false);
      });
    });
  });
  ```
- [ ] 所有測試通過
- [ ] 測試覆蓋率 100%

**相關文件**：
- [Vitest API](https://vitest.dev/api/)
- [Testing Type Guards](https://kentcdodds.com/blog/how-to-test-custom-react-hooks)

**所需技能**：
- Vitest 單元測試
- Type Guards 測試策略
- Test Coverage

**預估時間**: 1 小時

---

# Phase 2: API 客戶端建立

## 2.1 基礎 API 客戶端

### 📋 任務：建立 Axios 實例 (`shared/api/client.ts`)

**驗收標準**：
- [ ] 建立 `src/shared/api/client.ts`
  ```typescript
  import axios, { AxiosInstance } from 'axios';

  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

  export const apiClient: AxiosInstance = axios.create({
    baseURL: API_BASE_URL,
    timeout: 30000,
    headers: {
      'Content-Type': 'application/json',
    },
  });
  ```
- [ ] 環境變數正確讀取
- [ ] 基礎配置正確（timeout、headers）
- [ ] 可以成功發送測試請求

**相關文件**：
- [Axios 官方文檔](https://axios-http.com/docs/intro)
- [Axios Instance](https://axios-http.com/docs/instance)

**所需技能**：
- Axios 基礎
- HTTP Client 配置
- 環境變數使用

**預估時間**: 1 小時

---

### 📋 任務：設定請求/回應攔截器

**驗收標準**：
- [ ] 實作請求攔截器（添加 Token）
  ```typescript
  // src/shared/api/interceptor.ts
  import { apiClient } from './client';
  import { getAccessToken } from '@/auth/auth.store';

  apiClient.interceptors.request.use(
    (config) => {
      const token = getAccessToken();
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );
  ```
- [ ] 實作回應攔截器（錯誤處理）
  ```typescript
  apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
      // Error handling logic
      return Promise.reject(error);
    }
  );
  ```
- [ ] Token 自動附加到請求
- [ ] 錯誤攔截器正常運作

**相關文件**：
- [Axios Interceptors](https://axios-http.com/docs/interceptors)

**所需技能**：
- Axios Interceptors
- Promise 處理
- HTTP Headers

**預估時間**: 2 小時

---

### 📋 任務：實作錯誤正規化

**驗收標準**：
- [ ] 建立 `src/shared/api/error-normalizer.ts`
  ```typescript
  import { AxiosError } from 'axios';
  import { ApiErrorCode, NormalizedError } from './error';

  export function normalizeError(error: unknown): NormalizedError {
    if (axios.isAxiosError(error)) {
      const axiosError = error as AxiosError<{ code?: string; message?: string }>;

      // Network error
      if (!axiosError.response) {
        return {
          code: ApiErrorCode.NETWORK_ERROR,
          message: 'Network error. Please check your connection.',
          originalError: error,
        };
      }

      // Server error
      const { status, data } = axiosError.response;

      if (status === 401) {
        return {
          code: data?.code === 'TOKEN_EXPIRED'
            ? ApiErrorCode.TOKEN_EXPIRED
            : ApiErrorCode.UNAUTHORIZED,
          message: data?.message || 'Unauthorized',
          originalError: error,
        };
      }

      // ... other error codes
    }

    // Unknown error
    return {
      code: ApiErrorCode.UNKNOWN_ERROR,
      message: 'An unexpected error occurred',
      originalError: error,
    };
  }
  ```
- [ ] 所有 HTTP 錯誤正確分類
- [ ] 錯誤訊息友善且具體

**相關文件**：
- [Axios Error Handling](https://axios-http.com/docs/handling_errors)
- 專案文件：`docs/04-api-documentation.md`（錯誤碼定義）

**所需技能**：
- Error Handling 設計
- HTTP Status Codes
- Axios Error 結構

**預估時間**: 2 小時

---

## 2.2 Token 刷新機制

### 📋 任務：實作 Token 過期偵測

**驗收標準**：
- [ ] 回應攔截器偵測 401 + TOKEN_EXPIRED
  ```typescript
  apiClient.interceptors.response.use(
    (response) => response,
    async (error) => {
      const originalRequest = error.config;

      if (
        error.response?.status === 401 &&
        error.response?.data?.code === 'TOKEN_EXPIRED' &&
        !originalRequest._retry
      ) {
        // Token expired, trigger refresh
        return handleTokenRefresh(originalRequest);
      }

      return Promise.reject(error);
    }
  );
  ```
- [ ] 只在 TOKEN_EXPIRED 時觸發刷新
- [ ] 避免無限迴圈（_retry 標記）

**相關文件**：
- [JWT Refresh Token Best Practices](https://auth0.com/blog/refresh-tokens-what-are-they-and-when-to-use-them/)
- 專案文件：`docs/02-technical-decisions.md`（Token 策略）

**所需技能**：
- JWT 概念
- Token 過期處理
- Axios Interceptors 進階

**預估時間**: 2 小時

---

### 📋 任務：實作自動刷新邏輯

**驗收標準**：
- [ ] 建立 `src/shared/api/token-refresh.ts`
  ```typescript
  import { apiClient } from './client';
  import { refreshToken as authRefreshToken } from '@/auth/auth.api';

  let isRefreshing = false;
  let failedQueue: Array<{
    resolve: (token: string) => void;
    reject: (error: unknown) => void;
  }> = [];

  function processQueue(error: unknown, token: string | null = null) {
    failedQueue.forEach((prom) => {
      if (error) {
        prom.reject(error);
      } else if (token) {
        prom.resolve(token);
      }
    });
    failedQueue = [];
  }

  export async function handleTokenRefresh(originalRequest: any) {
    if (isRefreshing) {
      return new Promise((resolve, reject) => {
        failedQueue.push({ resolve, reject });
      })
        .then((token) => {
          originalRequest.headers.Authorization = `Bearer ${token}`;
          return apiClient(originalRequest);
        })
        .catch((err) => Promise.reject(err));
    }

    originalRequest._retry = true;
    isRefreshing = true;

    try {
      const newToken = await authRefreshToken();
      processQueue(null, newToken);
      originalRequest.headers.Authorization = `Bearer ${newToken}`;
      return apiClient(originalRequest);
    } catch (error) {
      processQueue(error, null);
      // Logout user
      return Promise.reject(error);
    } finally {
      isRefreshing = false;
    }
  }
  ```
- [ ] Refresh Token API 呼叫成功
- [ ] 新 Token 正確儲存
- [ ] 原始請求自動重試

**相關文件**：
- [Axios Queue Pattern](https://www.npmjs.com/package/axios-auth-refresh)

**所需技能**：
- Promise Queue 設計
- 非同步控制流
- Token 管理

**預估時間**: 3 小時

---

### 📋 任務：實作請求佇列機制

**驗收標準**：
- [ ] 多個同時失敗的請求只觸發一次刷新
- [ ] 其他請求加入佇列等待
- [ ] 刷新成功後，佇列中的請求全部重試
- [ ] 刷新失敗後，佇列中的請求全部失敗

**測試場景**：
```typescript
// 同時發送 3 個請求
Promise.all([
  apiClient.get('/users'),
  apiClient.get('/profile'),
  apiClient.get('/settings'),
]);

// 預期：只觸發 1 次 refresh token API 呼叫
// 預期：3 個請求都自動重試
```

**相關文件**：
- [Concurrency Control Patterns](https://www.patterns.dev/posts/throttling-debouncing)

**所需技能**：
- 佇列設計
- 並發控制
- Promise 協調

**預估時間**: 2 小時

---

### 📋 任務：實作 Refresh Lock

**驗收標準**：
- [ ] `isRefreshing` flag 防止重複刷新
- [ ] 刷新過程中新請求加入 failedQueue
- [ ] 刷新完成後 flag 正確重置
- [ ] 錯誤情況下 lock 正確釋放

**相關文件**：
- [Mutex Lock Pattern](https://en.wikipedia.org/wiki/Lock_(computer_science))

**所需技能**：
- 鎖機制概念
- Race Condition 處理
- 狀態管理

**預估時間**: 1 小時

---

## 2.3 錯誤處理機制（UX 提升）

### 📋 任務：實作錯誤分級系統

**驗收標準**：
- [ ] 定義錯誤等級
  ```typescript
  export enum ErrorSeverity {
    CRITICAL = 'critical',     // 應用崩潰，需要 Error Boundary
    RECOVERABLE = 'recoverable', // 可重試的錯誤
    WARNING = 'warning',       // 警告訊息
    VALIDATION = 'validation', // 表單驗證錯誤
  }

  export interface ClassifiedError extends NormalizedError {
    severity: ErrorSeverity;
    recoverable: boolean;
  }
  ```
- [ ] 錯誤分類邏輯完整
  ```typescript
  export function classifyError(error: NormalizedError): ClassifiedError {
    switch (error.code) {
      case ApiErrorCode.NETWORK_ERROR:
        return { ...error, severity: ErrorSeverity.RECOVERABLE, recoverable: true };

      case ApiErrorCode.TOKEN_EXPIRED:
      case ApiErrorCode.TOKEN_INVALID:
        return { ...error, severity: ErrorSeverity.CRITICAL, recoverable: false };

      case ApiErrorCode.VALIDATION_ERROR:
        return { ...error, severity: ErrorSeverity.VALIDATION, recoverable: false };

      default:
        return { ...error, severity: ErrorSeverity.RECOVERABLE, recoverable: true };
    }
  }
  ```
- [ ] 不同等級有不同處理方式

**相關文件**：
- [Error Handling Best Practices](https://kentcdodds.com/blog/use-react-error-boundary-to-handle-errors-in-react)

**所需技能**：
- Error Classification 設計
- UX Error Handling
- Severity Levels

**預估時間**: 2 小時

---

### 📋 任務：建立 Error Boundary (`shared/components/ErrorBoundary.tsx`)

**驗收標準**：
- [ ] 建立 `src/shared/components/ErrorBoundary.tsx`
  ```typescript
  import React, { Component, ErrorInfo, ReactNode } from 'react';

  interface Props {
    children: ReactNode;
    fallback?: ReactNode;
    onError?: (error: Error, errorInfo: ErrorInfo) => void;
  }

  interface State {
    hasError: boolean;
    error?: Error;
  }

  export class ErrorBoundary extends Component<Props, State> {
    constructor(props: Props) {
      super(props);
      this.state = { hasError: false };
    }

    static getDerivedStateFromError(error: Error): State {
      return { hasError: true, error };
    }

    componentDidCatch(error: Error, errorInfo: ErrorInfo) {
      console.error('ErrorBoundary caught:', error, errorInfo);
      this.props.onError?.(error, errorInfo);
    }

    render() {
      if (this.state.hasError) {
        return (
          this.props.fallback || (
            <div className="error-boundary">
              <h2>Something went wrong</h2>
              <button onClick={() => window.location.reload()}>
                Reload Page
              </button>
            </div>
          )
        );
      }

      return this.props.children;
    }
  }
  ```
- [ ] Error Boundary 可以捕捉 React 錯誤
- [ ] 顯示 fallback UI
- [ ] 提供重新載入功能

**相關文件**：
- [React Error Boundaries](https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary)

**所需技能**：
- React Error Boundaries
- Class Components
- Lifecycle Methods

**預估時間**: 2 小時

---

### 📋 任務：實作 Toast Notification 系統 (`shared/ui/Toast.tsx`)

**驗收標準**：
- [ ] 安裝 toast 函式庫（可選：react-hot-toast 或自製）
  ```bash
  npm install react-hot-toast
  ```
- [ ] 建立 `src/shared/ui/Toast.tsx`
  ```typescript
  import toast, { Toaster } from 'react-hot-toast';

  export { toast, Toaster };

  // Helper functions
  export const toastError = (message: string) => {
    toast.error(message, {
      duration: 4000,
      position: 'top-right',
    });
  };

  export const toastSuccess = (message: string) => {
    toast.success(message, {
      duration: 3000,
      position: 'top-right',
    });
  };

  export const toastWarning = (message: string) => {
    toast(message, {
      icon: '⚠️',
      duration: 3500,
      position: 'top-right',
    });
  };
  ```
- [ ] Toast 可以顯示不同類型的訊息（success、error、warning）
- [ ] 自動消失（可設定時間）
- [ ] 可以手動關閉

**相關文件**：
- [react-hot-toast](https://react-hot-toast.com/)

**所需技能**：
- Toast 函式庫使用
- UI 回饋設計
- Portal API

**預估時間**: 2 小時

---

### 📋 任務：實作網路狀態偵測（Offline Detection）

**驗收標準**：
- [ ] 建立 `src/shared/hooks/useNetworkStatus.ts`
  ```typescript
  import { useEffect, useState } from 'react';
  import { toastWarning, toastSuccess } from '@/shared/ui/Toast';

  export function useNetworkStatus() {
    const [isOnline, setIsOnline] = useState(navigator.onLine);

    useEffect(() => {
      const handleOnline = () => {
        setIsOnline(true);
        toastSuccess('Connection restored');
      };

      const handleOffline = () => {
        setIsOnline(false);
        toastWarning('You are offline. Some features may not work.');
      };

      window.addEventListener('online', handleOnline);
      window.addEventListener('offline', handleOffline);

      return () => {
        window.removeEventListener('online', handleOnline);
        window.removeEventListener('offline', handleOffline);
      };
    }, []);

    return isOnline;
  }
  ```
- [ ] 離線時顯示 Toast 提示
- [ ] 恢復連線時顯示成功訊息
- [ ] Hook 可以在任何元件中使用

**相關文件**：
- [MDN - Navigator.onLine](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/onLine)
- [Online/Offline Events](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/Online_and_offline_events)

**所需技能**：
- Custom Hooks
- Browser Events
- Network Status API

**預估時間**: 1.5 小時

---

## 2.4 API 客戶端測試

### 📋 任務：建立攔截器整合測試

**驗收標準**：
- [ ] 建立 `src/shared/api/__tests__/interceptor.integration.test.ts`
  ```typescript
  import { describe, it, expect, beforeEach, afterEach } from 'vitest';
  import { server } from '@/test/mocks/server';
  import { http, HttpResponse } from 'msw';
  import { apiClient } from '../client';

  describe('API Interceptor Integration', () => {
    beforeEach(() => {
      // Reset interceptors state
    });

    afterEach(() => {
      server.resetHandlers();
    });

    it('should attach Authorization header when token exists', async () => {
      // Mock getAccessToken to return a token
      // Make a request
      // Verify Authorization header is attached
    });

    it('should not attach Authorization header when token does not exist', async () => {
      // Mock getAccessToken to return null
      // Make a request
      // Verify Authorization header is not attached
    });

    it('should handle network errors correctly', async () => {
      server.use(
        http.get('/test', () => {
          return HttpResponse.error();
        })
      );

      await expect(apiClient.get('/test')).rejects.toThrow();
    });
  });
  ```
- [ ] 所有測試通過
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [MSW Testing Guide](https://mswjs.io/docs/best-practices/unit-testing)
- [Vitest - Testing Async Code](https://vitest.dev/guide/features.html#async-await)

**所需技能**：
- Integration Testing
- MSW Mocking
- Async Testing

**預估時間**: 3 小時

---

### 📋 任務：測試 Token 刷新機制

**驗收標準**：
- [ ] 測試 Token 過期偵測
  ```typescript
  it('should detect TOKEN_EXPIRED and trigger refresh', async () => {
    server.use(
      http.get('/test', () => {
        return HttpResponse.json(
          {
            success: false,
            error: { code: 'TOKEN_EXPIRED', message: 'Token expired' }
          },
          { status: 401 }
        );
      })
    );

    // Expect refresh token API to be called
    // Expect original request to be retried
  });
  ```
- [ ] 測試刷新成功後重試
- [ ] 測試刷新失敗後登出
- [ ] 測試請求佇列機制

**相關文件**：
- [Testing Token Refresh](https://kentcdodds.com/blog/how-to-test-custom-react-hooks)

**所需技能**：
- Token Refresh 測試策略
- Mock 複雜場景
- Async Flow Testing

**預估時間**: 4 小時

---

### 📋 任務：測試錯誤處理與錯誤分級

**驗收標準**：
- [ ] 測試錯誤正規化
  ```typescript
  describe('Error Normalization', () => {
    it('should normalize network errors', () => {
      const error = new Error('Network Error');
      const normalized = normalizeError(error);
      expect(normalized.code).toBe(ApiErrorCode.NETWORK_ERROR);
    });

    it('should normalize 401 errors', () => {
      const axiosError = createAxiosError(401, { code: 'UNAUTHORIZED' });
      const normalized = normalizeError(axiosError);
      expect(normalized.code).toBe(ApiErrorCode.UNAUTHORIZED);
    });
  });
  ```
- [ ] 測試錯誤分級
  ```typescript
  describe('Error Classification', () => {
    it('should classify network errors as recoverable', () => {
      const error: NormalizedError = {
        code: ApiErrorCode.NETWORK_ERROR,
        message: 'Network error',
      };
      const classified = classifyError(error);
      expect(classified.severity).toBe(ErrorSeverity.RECOVERABLE);
      expect(classified.recoverable).toBe(true);
    });
  });
  ```
- [ ] 所有錯誤碼有測試
- [ ] 測試覆蓋率 100%

**相關文件**：
- [Error Handling Testing](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)

**所需技能**：
- Error Testing Patterns
- Mock 錯誤場景
- Coverage Analysis

**預估時間**: 3 小時

---

由於文件非常長，我將分段繼續。這是 Phase 0-2 的詳細分解。**是否需要我繼續完成 Phase 3-8 的詳細分解？**

或者你想先針對某個特定 Phase 進行更深入的細節補充？