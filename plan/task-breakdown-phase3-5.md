# 任務詳細分解 - Phase 3-5

> 認證模組、使用者列表、頁面與路由的詳細驗收標準、參考文件和所需技能

**版本**: v1.0
**建立日期**: 2026-03-03
**最後更新**: 2026-03-03

---

## 📚 目錄

- [Phase 3: 認證模組實作](#phase-3-認證模組實作)
- [Phase 4: 使用者列表功能](#phase-4-使用者列表功能)
- [Phase 5: 頁面與路由](#phase-5-頁面與路由)

---

# Phase 3: 認證模組實作

## 3.1 認證型別與 Schema

### 📋 任務：建立 `auth/auth.types.ts`

**驗收標準**：
- [ ] 建立 `src/auth/auth.types.ts`
  ```typescript
  export interface LoginCredentials {
    username: string;
    password: string;
  }

  export interface AuthTokens {
    accessToken: string;
    refreshToken: string;
  }

  export interface LoginResponse {
    user: User;
    tokens: AuthTokens;
  }

  export interface User {
    id: string;
    username: string;
    email?: string;
    // 其他使用者欄位
  }

  export interface AuthState {
    user: User | null;
    accessToken: string | null;
    refreshToken: string | null;
    isAuthenticated: boolean;
    isLoading: boolean;
  }
  ```
- [ ] 所有認證相關型別定義完整
- [ ] 符合 API 規格（參考 docs/04-api-documentation.md）

**相關文件**：
- 專案文件：`docs/04-api-documentation.md`（Login API 規格）
- 專案文件：`docs/02-technical-decisions.md`（Token 策略）

**所需技能**：
- TypeScript Interface 設計
- 認證流程理解
- Token 管理概念

**預估時間**: 1 小時

---

### 📋 任務：建立 `auth/auth.schemas.ts` (Zod)

**驗收標準**：
- [ ] 建立 `src/auth/auth.schemas.ts`
  ```typescript
  import { z } from 'zod';

  export const loginCredentialsSchema = z.object({
    username: z
      .string()
      .min(1, '請輸入使用者名稱')
      .max(50, '使用者名稱過長'),
    password: z
      .string()
      .min(8, '密碼至少 8 個字元')
      .max(100, '密碼過長'),
  });

  export const authTokensSchema = z.object({
    accessToken: z.string(),
    refreshToken: z.string(),
  });

  export const userSchema = z.object({
    id: z.string(),
    username: z.string(),
    email: z.string().email().optional(),
  });

  export const loginResponseSchema = z.object({
    user: userSchema,
    tokens: authTokensSchema,
  });

  export type LoginCredentials = z.infer<typeof loginCredentialsSchema>;
  export type AuthTokens = z.infer<typeof authTokensSchema>;
  export type User = z.infer<typeof userSchema>;
  export type LoginResponse = z.infer<typeof loginResponseSchema>;
  ```
- [ ] 驗證規則符合業務需求
- [ ] 錯誤訊息清晰友善（中文）
- [ ] 型別可以從 Schema 推導

**相關文件**：
- [Zod 官方文檔](https://zod.dev/)
- [Zod Error Handling](https://zod.dev/ERROR_HANDLING)

**所需技能**：
- Zod Schema 定義
- Input Validation
- Type Inference from Schema

**預估時間**: 1 小時

---

### 📋 任務：建立 Schema 單元測試

**驗收標準**：
- [ ] 建立 `src/auth/__tests__/auth.schemas.test.ts`
  ```typescript
  import { describe, it, expect } from 'vitest';
  import { loginCredentialsSchema } from '../auth.schemas';

  describe('Auth Schemas', () => {
    describe('loginCredentialsSchema', () => {
      it('should validate correct credentials', () => {
        const valid = {
          username: 'testuser',
          password: 'password123',
        };
        expect(() => loginCredentialsSchema.parse(valid)).not.toThrow();
      });

      it('should reject empty username', () => {
        const invalid = {
          username: '',
          password: 'password123',
        };
        expect(() => loginCredentialsSchema.parse(invalid)).toThrow();
      });

      it('should reject short password', () => {
        const invalid = {
          username: 'testuser',
          password: '1234567', // 只有 7 個字元
        };
        expect(() => loginCredentialsSchema.parse(invalid)).toThrow();
      });

      it('should reject missing fields', () => {
        expect(() => loginCredentialsSchema.parse({})).toThrow();
      });
    });
  });
  ```
- [ ] 測試所有驗證規則
- [ ] 測試覆蓋率 100%
- [ ] 錯誤訊息測試

**相關文件**：
- [Testing Zod Schemas](https://zod.dev/?id=testing)

**所需技能**：
- Vitest 測試
- Zod 驗證測試
- Edge Case 測試

**預估時間**: 1 小時

---

## 3.2 認證 API

### 📋 任務：實作 `auth/auth.api.ts`

**驗收標準**：
- [ ] 建立 `src/auth/auth.api.ts`
  ```typescript
  import { apiClient } from '@/shared/api/client';
  import { LoginCredentials, LoginResponse, AuthTokens } from './auth.types';
  import { loginResponseSchema, authTokensSchema } from './auth.schemas';

  /**
   * 登入 API
   */
  export async function login(credentials: LoginCredentials): Promise<LoginResponse> {
    const response = await apiClient.post<LoginResponse>(
      '/auth/login',
      credentials
    );

    // 驗證回應格式
    const validated = loginResponseSchema.parse(response.data);
    return validated;
  }

  /**
   * 刷新 Token API
   */
  export async function refreshToken(token: string): Promise<string> {
    const response = await apiClient.post<AuthTokens>(
      '/auth/refresh',
      { refreshToken: token }
    );

    const validated = authTokensSchema.parse(response.data);
    return validated.accessToken;
  }

  /**
   * 登出 API
   */
  export async function logout(): Promise<void> {
    await apiClient.post('/auth/logout');
  }
  ```
- [ ] 所有 API 函式型別正確
- [ ] 使用 Zod 驗證 API 回應
- [ ] 錯誤處理完善（會自動被 interceptor 處理）

**相關文件**：
- 專案文件：`docs/04-api-documentation.md`（API 規格）
- [Axios API Reference](https://axios-http.com/docs/api_intro)

**所需技能**：
- Axios API 呼叫
- TypeScript Async Functions
- Zod Runtime Validation

**預估時間**: 1.5 小時

---

### 📋 任務：建立 API 單元測試

**驗收標準**：
- [ ] 建立 `src/auth/__tests__/auth.api.test.ts`
  ```typescript
  import { describe, it, expect, beforeEach } from 'vitest';
  import { server } from '@/test/mocks/server';
  import { http, HttpResponse } from 'msw';
  import { login, refreshToken, logout } from '../auth.api';

  describe('Auth API', () => {
    describe('login', () => {
      it('should login successfully with valid credentials', async () => {
        server.use(
          http.post('/auth/login', () => {
            return HttpResponse.json({
              user: {
                id: '1',
                username: 'testuser',
                email: 'test@example.com',
              },
              tokens: {
                accessToken: 'mock-access-token',
                refreshToken: 'mock-refresh-token',
              },
            });
          })
        );

        const result = await login({
          username: 'testuser',
          password: 'password123',
        });

        expect(result.user.username).toBe('testuser');
        expect(result.tokens.accessToken).toBeDefined();
      });

      it('should throw error with invalid credentials', async () => {
        server.use(
          http.post('/auth/login', () => {
            return HttpResponse.json(
              {
                success: false,
                error: {
                  code: 'INVALID_CREDENTIALS',
                  message: 'Invalid username or password',
                },
              },
              { status: 401 }
            );
          })
        );

        await expect(
          login({
            username: 'wrong',
            password: 'wrong',
          })
        ).rejects.toThrow();
      });
    });

    describe('refreshToken', () => {
      it('should refresh token successfully', async () => {
        server.use(
          http.post('/auth/refresh', () => {
            return HttpResponse.json({
              accessToken: 'new-access-token',
              refreshToken: 'new-refresh-token',
            });
          })
        );

        const newToken = await refreshToken('old-refresh-token');
        expect(newToken).toBe('new-access-token');
      });

      it('should throw error with invalid refresh token', async () => {
        server.use(
          http.post('/auth/refresh', () => {
            return HttpResponse.json(
              {
                success: false,
                error: {
                  code: 'TOKEN_INVALID',
                  message: 'Invalid refresh token',
                },
              },
              { status: 401 }
            );
          })
        );

        await expect(refreshToken('invalid-token')).rejects.toThrow();
      });
    });

    describe('logout', () => {
      it('should logout successfully', async () => {
        server.use(
          http.post('/auth/logout', () => {
            return HttpResponse.json({ success: true });
          })
        );

        await expect(logout()).resolves.not.toThrow();
      });
    });
  });
  ```
- [ ] 所有 API 函式有測試
- [ ] 測試成功和失敗場景
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [MSW - Testing API Calls](https://mswjs.io/docs/basics/response-resolver)
- [Vitest - Async Testing](https://vitest.dev/guide/features.html#async-await)

**所需技能**：
- MSW API Mocking
- Async Testing
- Error Testing

**預估時間**: 2 小時

---

## 3.3 認證狀態管理

### 📋 任務：建立 `auth/auth.store.ts` (Zustand)

**驗收標準**：
- [ ] 建立 `src/auth/auth.store.ts`
  ```typescript
  import { create } from 'zustand';
  import { AuthState, User, AuthTokens } from './auth.types';

  interface AuthStore extends AuthState {
    // Actions
    setAuth: (user: User, tokens: AuthTokens) => void;
    clearAuth: () => void;
    setAccessToken: (token: string) => void;
    setLoading: (isLoading: boolean) => void;
  }

  export const useAuthStore = create<AuthStore>((set) => ({
    // Initial state
    user: null,
    accessToken: null,
    refreshToken: null,
    isAuthenticated: false,
    isLoading: false,

    // Actions
    setAuth: (user, tokens) => {
      // Save refresh token to localStorage
      localStorage.setItem('refreshToken', tokens.refreshToken);

      set({
        user,
        accessToken: tokens.accessToken, // in-memory
        refreshToken: tokens.refreshToken,
        isAuthenticated: true,
      });
    },

    clearAuth: () => {
      // Remove refresh token from localStorage
      localStorage.removeItem('refreshToken');

      set({
        user: null,
        accessToken: null,
        refreshToken: null,
        isAuthenticated: false,
      });
    },

    setAccessToken: (token) => {
      set({ accessToken: token });
    },

    setLoading: (isLoading) => {
      set({ isLoading });
    },
  }));

  // Selectors
  export const getAccessToken = () => useAuthStore.getState().accessToken;
  export const getRefreshToken = () => useAuthStore.getState().refreshToken;
  export const getUser = () => useAuthStore.getState().user;
  export const isAuthenticated = () => useAuthStore.getState().isAuthenticated;
  ```
- [ ] Access Token 儲存在 memory（store state）
- [ ] Refresh Token 儲存在 localStorage
- [ ] Actions 正確更新狀態
- [ ] Selectors 可以正常使用

**相關文件**：
- [Zustand 官方文檔](https://zustand-demo.pmnd.rs/)
- [Zustand - Selectors](https://docs.pmnd.rs/zustand/guides/auto-generating-selectors)
- 專案文件：`docs/02-technical-decisions.md`（Token 儲存策略）

**所需技能**：
- Zustand State Management
- localStorage API
- Token 儲存策略

**預估時間**: 2 小時

---

### 📋 任務：實作 Session Restore

**驗收標準**：
- [ ] 在 `auth.store.ts` 中加入 Session Restore 邏輯
  ```typescript
  export const initializeAuth = async () => {
    const refreshToken = localStorage.getItem('refreshToken');

    if (!refreshToken) {
      return;
    }

    try {
      useAuthStore.setState({ isLoading: true });

      // 使用 refresh token 換取新的 access token
      const newAccessToken = await refreshTokenAPI(refreshToken);

      // 獲取使用者資訊（可選，如果 API 有提供）
      // const user = await getUserProfile();

      useAuthStore.setState({
        accessToken: newAccessToken,
        refreshToken,
        isAuthenticated: true,
        isLoading: false,
      });
    } catch (error) {
      // Refresh token 無效，清除狀態
      useAuthStore.getState().clearAuth();
      useAuthStore.setState({ isLoading: false });
    }
  };
  ```
- [ ] 在 `App.tsx` 中呼叫 `initializeAuth()`
  ```typescript
  // src/app/App.tsx
  useEffect(() => {
    initializeAuth();
  }, []);
  ```
- [ ] 重新整理頁面後保持登入狀態
- [ ] Refresh Token 無效時自動登出

**相關文件**：
- 專案文件：`docs/01-quick-reference.md`（Session Restore）

**所需技能**：
- Session 管理
- localStorage 持久化
- React useEffect

**預估時間**: 2 小時

---

### 📋 任務：建立 Store 單元測試

**驗收標準**：
- [ ] 建立 `src/auth/__tests__/auth.store.test.ts`
  ```typescript
  import { describe, it, expect, beforeEach, afterEach } from 'vitest';
  import { useAuthStore } from '../auth.store';

  describe('Auth Store', () => {
    beforeEach(() => {
      // Reset store
      useAuthStore.getState().clearAuth();
      localStorage.clear();
    });

    afterEach(() => {
      localStorage.clear();
    });

    describe('setAuth', () => {
      it('should set user and tokens', () => {
        const user = { id: '1', username: 'testuser' };
        const tokens = {
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
        };

        useAuthStore.getState().setAuth(user, tokens);

        const state = useAuthStore.getState();
        expect(state.user).toEqual(user);
        expect(state.accessToken).toBe('access-token');
        expect(state.refreshToken).toBe('refresh-token');
        expect(state.isAuthenticated).toBe(true);
      });

      it('should save refresh token to localStorage', () => {
        const user = { id: '1', username: 'testuser' };
        const tokens = {
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
        };

        useAuthStore.getState().setAuth(user, tokens);

        expect(localStorage.getItem('refreshToken')).toBe('refresh-token');
      });
    });

    describe('clearAuth', () => {
      it('should clear user and tokens', () => {
        // Set auth first
        useAuthStore.getState().setAuth(
          { id: '1', username: 'testuser' },
          { accessToken: 'access', refreshToken: 'refresh' }
        );

        // Clear auth
        useAuthStore.getState().clearAuth();

        const state = useAuthStore.getState();
        expect(state.user).toBeNull();
        expect(state.accessToken).toBeNull();
        expect(state.refreshToken).toBeNull();
        expect(state.isAuthenticated).toBe(false);
      });

      it('should remove refresh token from localStorage', () => {
        localStorage.setItem('refreshToken', 'refresh-token');

        useAuthStore.getState().clearAuth();

        expect(localStorage.getItem('refreshToken')).toBeNull();
      });
    });
  });
  ```
- [ ] 所有 actions 有測試
- [ ] 測試 localStorage 互動
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [Testing Zustand](https://docs.pmnd.rs/zustand/guides/testing)
- [Vitest - LocalStorage Mocking](https://vitest.dev/guide/mocking.html)

**所需技能**：
- Zustand Testing
- LocalStorage Mocking
- State Management Testing

**預估時間**: 2 小時

---

## 3.4 路由守衛

### 📋 任務：建立 `auth/auth.guard.tsx`

**驗收標準**：
- [ ] 建立 `src/auth/auth.guard.tsx`
  ```typescript
  import { Navigate, Outlet } from 'react-router-dom';
  import { useAuthStore } from './auth.store';

  /**
   * Protected Route Component
   * 需要認證才能訪問的路由
   */
  export function ProtectedRoute() {
    const { isAuthenticated, isLoading } = useAuthStore();

    if (isLoading) {
      return (
        <div className="flex items-center justify-center min-h-screen">
          <div>Loading...</div>
        </div>
      );
    }

    if (!isAuthenticated) {
      return <Navigate to="/login" replace />;
    }

    return <Outlet />;
  }

  /**
   * Guest Route Component
   * 僅未登入可訪問的路由（如登入頁）
   */
  export function GuestRoute() {
    const { isAuthenticated, isLoading } = useAuthStore();

    if (isLoading) {
      return (
        <div className="flex items-center justify-center min-h-screen">
          <div>Loading...</div>
        </div>
      );
    }

    if (isAuthenticated) {
      return <Navigate to="/users" replace />;
    }

    return <Outlet />;
  }
  ```
- [ ] 未登入訪問受保護路由會導向登入頁
- [ ] 已登入訪問登入頁會導向使用者列表
- [ ] Loading 狀態正確顯示

**相關文件**：
- [React Router - Protected Routes](https://reactrouter.com/en/main/start/tutorial#protecting-routes)
- 專案文件：`docs/03-implementation-guide.md`

**所需技能**：
- React Router v6
- Route Protection Pattern
- Conditional Rendering

**預估時間**: 1.5 小時

---

### 📋 任務：建立守衛測試

**驗收標準**：
- [ ] 建立 `src/auth/__tests__/auth.guard.test.tsx`
  ```typescript
  import { describe, it, expect, beforeEach } from 'vitest';
  import { render, screen } from '@testing-library/react';
  import { MemoryRouter, Routes, Route } from 'react-router-dom';
  import { ProtectedRoute, GuestRoute } from '../auth.guard';
  import { useAuthStore } from '../auth.store';

  describe('Auth Guards', () => {
    beforeEach(() => {
      useAuthStore.getState().clearAuth();
    });

    describe('ProtectedRoute', () => {
      it('should render protected content when authenticated', () => {
        useAuthStore.getState().setAuth(
          { id: '1', username: 'testuser' },
          { accessToken: 'token', refreshToken: 'refresh' }
        );

        render(
          <MemoryRouter initialEntries={['/protected']}>
            <Routes>
              <Route element={<ProtectedRoute />}>
                <Route path="/protected" element={<div>Protected Content</div>} />
              </Route>
            </Routes>
          </MemoryRouter>
        );

        expect(screen.getByText('Protected Content')).toBeInTheDocument();
      });

      it('should redirect to login when not authenticated', () => {
        render(
          <MemoryRouter initialEntries={['/protected']}>
            <Routes>
              <Route element={<ProtectedRoute />}>
                <Route path="/protected" element={<div>Protected Content</div>} />
              </Route>
              <Route path="/login" element={<div>Login Page</div>} />
            </Routes>
          </MemoryRouter>
        );

        expect(screen.getByText('Login Page')).toBeInTheDocument();
      });
    });

    describe('GuestRoute', () => {
      it('should render login page when not authenticated', () => {
        render(
          <MemoryRouter initialEntries={['/login']}>
            <Routes>
              <Route element={<GuestRoute />}>
                <Route path="/login" element={<div>Login Page</div>} />
              </Route>
            </Routes>
          </MemoryRouter>
        );

        expect(screen.getByText('Login Page')).toBeInTheDocument();
      });

      it('should redirect to users when authenticated', () => {
        useAuthStore.getState().setAuth(
          { id: '1', username: 'testuser' },
          { accessToken: 'token', refreshToken: 'refresh' }
        );

        render(
          <MemoryRouter initialEntries={['/login']}>
            <Routes>
              <Route element={<GuestRoute />}>
                <Route path="/login" element={<div>Login Page</div>} />
              </Route>
              <Route path="/users" element={<div>Users Page</div>} />
            </Routes>
          </MemoryRouter>
        );

        expect(screen.getByText('Users Page')).toBeInTheDocument();
      });
    });
  });
  ```
- [ ] 測試所有路由守衛場景
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [Testing React Router](https://reactrouter.com/en/main/start/tutorial#testing)
- [Testing Library - Router Testing](https://testing-library.com/docs/example-react-router/)

**所需技能**：
- React Router Testing
- Component Testing
- Memory Router

**預估時間**: 2 小時

---

# Phase 4: 使用者列表功能

## 4.1 使用者型別與 Schema

### 📋 任務：建立 `domains/users/users.types.ts`

**驗收標準**：
- [ ] 建立 `src/domains/users/users.types.ts`
  ```typescript
  import { PaginatedResponse, PaginationParams } from '@/types/common';

  export interface User {
    id: string;
    username: string;
    email?: string;
    avatar?: string;
    status: UserStatus;
    createdAt: string;
  }

  export enum UserStatus {
    ACTIVE = 'active',
    INACTIVE = 'inactive',
  }

  export interface GetUsersParams extends PaginationParams {
    search?: string;
    status?: UserStatus;
  }

  export type UsersResponse = PaginatedResponse<User>;
  ```
- [ ] 型別符合 API 規格
- [ ] 包含分頁參數

**相關文件**：
- 專案文件：`docs/04-api-documentation.md`（Users API）

**所需技能**：
- TypeScript Interface
- Enum 使用
- 泛型繼承

**預估時間**: 1 小時

---

### 📋 任務：建立 `domains/users/users.schemas.ts` (Zod)

**驗收標準**：
- [ ] 建立 `src/domains/users/users.schemas.ts`
  ```typescript
  import { z } from 'zod';

  export const userStatusSchema = z.enum(['active', 'inactive']);

  export const userSchema = z.object({
    id: z.string(),
    username: z.string(),
    email: z.string().email().optional(),
    avatar: z.string().url().optional(),
    status: userStatusSchema,
    createdAt: z.string().datetime(),
  });

  export const paginationSchema = z.object({
    page: z.number().int().positive(),
    limit: z.number().int().positive(),
    total: z.number().int().nonnegative(),
    totalPages: z.number().int().nonnegative(),
  });

  export const usersResponseSchema = z.object({
    data: z.array(userSchema),
    pagination: paginationSchema,
  });

  export type User = z.infer<typeof userSchema>;
  export type UsersResponse = z.infer<typeof usersResponseSchema>;
  ```
- [ ] Schema 驗證完整
- [ ] 型別可以從 Schema 推導

**相關文件**：
- [Zod - Object Schemas](https://zod.dev/?id=objects)
- [Zod - Arrays](https://zod.dev/?id=arrays)

**所需技能**：
- Zod Complex Schemas
- Type Inference
- Data Validation

**預估時間**: 1 小時

---

### 📋 任務：建立 Schema 單元測試

**驗收標準**：
- [ ] 建立 `src/domains/users/__tests__/users.schemas.test.ts`
  ```typescript
  import { describe, it, expect } from 'vitest';
  import { userSchema, usersResponseSchema } from '../users.schemas';

  describe('Users Schemas', () => {
    describe('userSchema', () => {
      it('should validate correct user data', () => {
        const valid = {
          id: '1',
          username: 'testuser',
          email: 'test@example.com',
          status: 'active',
          createdAt: '2024-01-01T00:00:00Z',
        };
        expect(() => userSchema.parse(valid)).not.toThrow();
      });

      it('should reject invalid email', () => {
        const invalid = {
          id: '1',
          username: 'testuser',
          email: 'invalid-email',
          status: 'active',
          createdAt: '2024-01-01T00:00:00Z',
        };
        expect(() => userSchema.parse(invalid)).toThrow();
      });

      it('should allow optional fields', () => {
        const minimal = {
          id: '1',
          username: 'testuser',
          status: 'active',
          createdAt: '2024-01-01T00:00:00Z',
        };
        expect(() => userSchema.parse(minimal)).not.toThrow();
      });
    });

    describe('usersResponseSchema', () => {
      it('should validate correct paginated response', () => {
        const valid = {
          data: [
            {
              id: '1',
              username: 'user1',
              status: 'active',
              createdAt: '2024-01-01T00:00:00Z',
            },
          ],
          pagination: {
            page: 1,
            limit: 10,
            total: 100,
            totalPages: 10,
          },
        };
        expect(() => usersResponseSchema.parse(valid)).not.toThrow();
      });
    });
  });
  ```
- [ ] 測試覆蓋率 100%

**相關文件**：
- [Vitest - Testing Patterns](https://vitest.dev/guide/)

**所需技能**：
- Schema Testing
- Edge Cases
- Vitest

**預估時間**: 1 小時

---

## 4.2 使用者 API

### 📋 任務：實作 `domains/users/users.api.ts`

**驗收標準**：
- [ ] 建立 `src/domains/users/users.api.ts`
  ```typescript
  import { apiClient } from '@/shared/api/client';
  import { GetUsersParams, UsersResponse } from './users.types';
  import { usersResponseSchema } from './users.schemas';

  /**
   * 取得使用者列表
   */
  export async function getUsers(params: GetUsersParams): Promise<UsersResponse> {
    const response = await apiClient.get<UsersResponse>('/users', {
      params,
    });

    // 驗證回應格式
    const validated = usersResponseSchema.parse(response.data);
    return validated;
  }
  ```
- [ ] API 呼叫正確
- [ ] 參數正確傳遞（page, limit, search, status）
- [ ] 使用 Zod 驗證回應

**相關文件**：
- 專案文件：`docs/04-api-documentation.md`（Users API）
- [Axios - Query Parameters](https://axios-http.com/docs/req_config)

**所需技能**：
- Axios GET 請求
- Query Parameters
- Response Validation

**預估時間**: 1 小時

---

### 📋 任務：建立 API 單元測試

**驗收標準**：
- [ ] 建立 `src/domains/users/__tests__/users.api.test.ts`
  ```typescript
  import { describe, it, expect } from 'vitest';
  import { server } from '@/test/mocks/server';
  import { http, HttpResponse } from 'msw';
  import { getUsers } from '../users.api';

  describe('Users API', () => {
    describe('getUsers', () => {
      it('should fetch users successfully', async () => {
        server.use(
          http.get('/users', () => {
            return HttpResponse.json({
              data: [
                {
                  id: '1',
                  username: 'user1',
                  status: 'active',
                  createdAt: '2024-01-01T00:00:00Z',
                },
              ],
              pagination: {
                page: 1,
                limit: 10,
                total: 1,
                totalPages: 1,
              },
            });
          })
        );

        const result = await getUsers({ page: 1, limit: 10 });

        expect(result.data).toHaveLength(1);
        expect(result.pagination.page).toBe(1);
      });

      it('should pass query parameters correctly', async () => {
        let capturedParams: URLSearchParams | null = null;

        server.use(
          http.get('/users', ({ request }) => {
            capturedParams = new URL(request.url).searchParams;
            return HttpResponse.json({
              data: [],
              pagination: {
                page: 2,
                limit: 20,
                total: 0,
                totalPages: 0,
              },
            });
          })
        );

        await getUsers({ page: 2, limit: 20, status: 'active' });

        expect(capturedParams?.get('page')).toBe('2');
        expect(capturedParams?.get('limit')).toBe('20');
        expect(capturedParams?.get('status')).toBe('active');
      });

      it('should handle API errors', async () => {
        server.use(
          http.get('/users', () => {
            return HttpResponse.json(
              {
                success: false,
                error: {
                  code: 'INTERNAL_SERVER_ERROR',
                  message: 'Server error',
                },
              },
              { status: 500 }
            );
          })
        );

        await expect(getUsers({ page: 1, limit: 10 })).rejects.toThrow();
      });
    });
  });
  ```
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [MSW - Query Parameters](https://mswjs.io/docs/basics/request-matching)

**所需技能**：
- MSW Query Parameter Testing
- API Testing
- Error Scenario Testing

**預估時間**: 2 小時

---

## 4.3 使用者 Hooks

### 📋 任務：建立 `domains/users/users.hooks.ts` (TanStack Query)

**驗收標準**：
- [ ] 建立 `src/domains/users/users.hooks.ts`
  ```typescript
  import { useQuery } from '@tanstack/react-query';
  import { getUsers } from './users.api';
  import { GetUsersParams } from './users.types';

  export const USERS_QUERY_KEY = 'users';

  /**
   * 使用者列表 Query Hook
   */
  export function useUsers(params: GetUsersParams) {
    return useQuery({
      queryKey: [USERS_QUERY_KEY, params],
      queryFn: () => getUsers(params),
      staleTime: 1000 * 60 * 5, // 5 minutes
    });
  }
  ```
- [ ] Query Key 正確設定（包含參數）
- [ ] 錯誤自動處理（透過 TanStack Query）
- [ ] Loading 狀態自動管理

**相關文件**：
- [TanStack Query - useQuery](https://tanstack.com/query/latest/docs/react/reference/useQuery)
- [TanStack Query - Query Keys](https://tanstack.com/query/latest/docs/react/guides/query-keys)

**所需技能**：
- TanStack Query Hooks
- Query Key Management
- Cache Strategy

**預估時間**: 1 小時

---

### 📋 任務：建立 Hooks 測試

**驗收標準**：
- [ ] 建立 `src/domains/users/__tests__/users.hooks.test.ts`
  ```typescript
  import { describe, it, expect } from 'vitest';
  import { renderHook, waitFor } from '@testing-library/react';
  import { server } from '@/test/mocks/server';
  import { http, HttpResponse } from 'msw';
  import { renderWithProviders } from '@/test/utils';
  import { useUsers } from '../users.hooks';

  describe('Users Hooks', () => {
    describe('useUsers', () => {
      it('should fetch users successfully', async () => {
        server.use(
          http.get('/users', () => {
            return HttpResponse.json({
              data: [
                {
                  id: '1',
                  username: 'user1',
                  status: 'active',
                  createdAt: '2024-01-01T00:00:00Z',
                },
              ],
              pagination: {
                page: 1,
                limit: 10,
                total: 1,
                totalPages: 1,
              },
            });
          })
        );

        const { result } = renderHook(() => useUsers({ page: 1, limit: 10 }), {
          wrapper: ({ children }) => renderWithProviders(children).container,
        });

        await waitFor(() => expect(result.current.isSuccess).toBe(true));

        expect(result.current.data?.data).toHaveLength(1);
        expect(result.current.data?.data[0].username).toBe('user1');
      });

      it('should handle loading state', () => {
        const { result } = renderHook(() => useUsers({ page: 1, limit: 10 }), {
          wrapper: ({ children }) => renderWithProviders(children).container,
        });

        expect(result.current.isLoading).toBe(true);
      });

      it('should handle error state', async () => {
        server.use(
          http.get('/users', () => {
            return HttpResponse.json(
              {
                success: false,
                error: { code: 'ERROR', message: 'Failed' },
              },
              { status: 500 }
            );
          })
        );

        const { result } = renderHook(() => useUsers({ page: 1, limit: 10 }), {
          wrapper: ({ children }) => renderWithProviders(children).container,
        });

        await waitFor(() => expect(result.current.isError).toBe(true));
        expect(result.current.error).toBeDefined();
      });
    });
  });
  ```
- [ ] 測試覆蓋率 ≥ 80%

**相關文件**：
- [Testing React Hooks](https://react-hooks-testing-library.com/)
- [TanStack Query - Testing](https://tanstack.com/query/latest/docs/react/guides/testing)

**所需技能**：
- React Hook Testing
- TanStack Query Testing
- Async State Testing

**預估時間**: 2 小時

---

## 4.4 使用者列表 UI

### 📋 任務：建立 `domains/users/UsersTable.tsx`

**驗收標準**：
- [ ] 建立 `src/domains/users/UsersTable.tsx`
  ```typescript
  import { useUsers } from './users.hooks';
  import { useState } from 'react';

  export function UsersTable() {
    const [page, setPage] = useState(1);
    const limit = 10;

    const { data, isLoading, isError, error, refetch } = useUsers({ page, limit });

    if (isLoading) {
      return <UsersSkeleton />;
    }

    if (isError) {
      return (
        <div className="error-state">
          <p>{error.message}</p>
          <button onClick={() => refetch()}>重試</button>
        </div>
      );
    }

    if (!data || data.data.length === 0) {
      return <UsersEmptyState />;
    }

    return (
      <div>
        <table>
          <thead>
            <tr>
              <th>頭像</th>
              <th>使用者名稱</th>
              <th>Email</th>
              <th>狀態</th>
              <th>建立時間</th>
            </tr>
          </thead>
          <tbody>
            {data.data.map((user) => (
              <tr key={user.id}>
                <td>
                  {user.avatar ? (
                    <img src={user.avatar} alt={user.username} />
                  ) : (
                    <div className="avatar-placeholder">{user.username[0]}</div>
                  )}
                </td>
                <td>{user.username}</td>
                <td>{user.email || '-'}</td>
                <td>
                  <span className={`status-badge ${user.status}`}>
                    {user.status === 'active' ? '啟用' : '停用'}
                  </span>
                </td>
                <td>{new Date(user.createdAt).toLocaleDateString()}</td>
              </tr>
            ))}
          </tbody>
        </table>

        <Pagination
          currentPage={page}
          totalPages={data.pagination.totalPages}
          onPageChange={setPage}
        />
      </div>
    );
  }

  function UsersSkeleton() {
    return <div>Loading skeleton...</div>;
  }

  function UsersEmptyState() {
    return <div>目前沒有使用者</div>;
  }

  function Pagination({ currentPage, totalPages, onPageChange }) {
    return (
      <div className="pagination">
        <button
          disabled={currentPage === 1}
          onClick={() => onPageChange(currentPage - 1)}
        >
          上一頁
        </button>
        <span>{currentPage} / {totalPages}</span>
        <button
          disabled={currentPage === totalPages}
          onClick={() => onPageChange(currentPage + 1)}
        >
          下一頁
        </button>
      </div>
    );
  }
  ```
- [ ] 表格正確顯示使用者資料
- [ ] Loading 狀態顯示 Skeleton
- [ ] Error 狀態顯示錯誤訊息和重試按鈕
- [ ] Empty 狀態顯示友善提示
- [ ] 分頁功能正常

**相關文件**：
- [React - Conditional Rendering](https://react.dev/learn/conditional-rendering)
- [TanStack Query - UI Patterns](https://tanstack.com/query/latest/docs/react/guides/queries)

**所需技能**：
- React Component 設計
- Conditional Rendering
- State Management (useState)
- Table UI

**預估時間**: 3 小時

---

### 📋 任務：實作分頁功能

**驗收標準**：
- [ ] 分頁元件獨立抽離
  ```typescript
  // src/shared/ui/Pagination.tsx
  interface PaginationProps {
    currentPage: number;
    totalPages: number;
    onPageChange: (page: number) => void;
    isLoading?: boolean;
  }

  export function Pagination({
    currentPage,
    totalPages,
    onPageChange,
    isLoading = false,
  }: PaginationProps) {
    return (
      <div className="flex items-center justify-center gap-4 mt-4">
        <button
          className="btn"
          disabled={currentPage === 1 || isLoading}
          onClick={() => onPageChange(currentPage - 1)}
        >
          上一頁
        </button>

        <span className="text-sm">
          第 {currentPage} 頁，共 {totalPages} 頁
        </span>

        <button
          className="btn"
          disabled={currentPage === totalPages || isLoading}
          onClick={() => onPageChange(currentPage + 1)}
        >
          下一頁
        </button>
      </div>
    );
  }
  ```
- [ ] 切換頁面時顯示 Loading 指示
- [ ] 上一頁/下一頁按鈕禁用狀態正確
- [ ] 頁碼顯示正確

**相關文件**：
- [Pagination UI Patterns](https://ui-patterns.com/patterns/pagination)

**所需技能**：
- Pagination Component 設計
- Button States
- Loading Indicators

**預估時間**: 1.5 小時

---

### 📋 任務：實作 Skeleton Loading

**驗收標準**：
- [ ] 建立 `src/shared/ui/Skeleton.tsx`
  ```typescript
  interface SkeletonProps {
    className?: string;
    variant?: 'text' | 'circular' | 'rectangular';
  }

  export function Skeleton({ className = '', variant = 'text' }: SkeletonProps) {
    const baseClass = 'animate-pulse bg-gray-200 rounded';
    const variantClass = {
      text: 'h-4 w-full',
      circular: 'w-10 h-10 rounded-full',
      rectangular: 'w-full h-20',
    }[variant];

    return <div className={`${baseClass} ${variantClass} ${className}`} />;
  }
  ```
- [ ] 在 UsersTable 中使用 Skeleton
  ```typescript
  function UsersSkeleton() {
    return (
      <table>
        <thead>
          <tr>
            <th>頭像</th>
            <th>使用者名稱</th>
            <th>Email</th>
            <th>狀態</th>
            <th>建立時間</th>
          </tr>
        </thead>
        <tbody>
          {Array.from({ length: 5 }).map((_, i) => (
            <tr key={i}>
              <td><Skeleton variant="circular" /></td>
              <td><Skeleton /></td>
              <td><Skeleton /></td>
              <td><Skeleton className="w-20" /></td>
              <td><Skeleton className="w-32" /></td>
            </tr>
          ))}
        </tbody>
      </table>
    );
  }
  ```
- [ ] Loading 狀態不再顯示白屏
- [ ] Skeleton 動畫流暢

**相關文件**：
- [Skeleton Loading Pattern](https://uxdesign.cc/what-you-should-know-about-skeleton-screens-a820c45a571a)
- [Tailwind CSS - Animation](https://tailwindcss.com/docs/animation)

**所需技能**：
- Skeleton Component 設計
- CSS Animation
- Loading UX

**預估時間**: 2 小時

---

### 📋 任務：實作 Error 狀態（含重試按鈕）

**驗收標準**：
- [ ] 建立 `src/shared/ui/ErrorMessage.tsx`
  ```typescript
  interface ErrorMessageProps {
    message: string;
    onRetry?: () => void;
  }

  export function ErrorMessage({ message, onRetry }: ErrorMessageProps) {
    return (
      <div className="flex flex-col items-center justify-center p-8 text-center">
        <div className="text-red-500 mb-4">
          <svg className="w-16 h-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 className="text-lg font-semibold mb-2">載入失敗</h3>
        <p className="text-gray-600 mb-4">{message}</p>
        {onRetry && (
          <button
            onClick={onRetry}
            className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
          >
            重試
          </button>
        )}
      </div>
    );
  }
  ```
- [ ] 錯誤訊息清晰友善
- [ ] 重試按鈕功能正常
- [ ] 圖示清楚表達錯誤狀態

**相關文件**：
- [Error State Design](https://www.nngroup.com/articles/error-message-guidelines/)
- [Heroicons](https://heroicons.com/)

**所需技能**：
- Error UI 設計
- SVG Icons
- User Feedback

**預估時間**: 1 小時

---

### 📋 任務：實作 Empty 狀態

**驗收標準**：
- [ ] 建立 `src/shared/ui/EmptyState.tsx`
  ```typescript
  interface EmptyStateProps {
    icon?: React.ReactNode;
    title: string;
    description?: string;
    action?: {
      label: string;
      onClick: () => void;
    };
  }

  export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center">
        {icon && <div className="text-gray-400 mb-4">{icon}</div>}
        <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
        {description && <p className="text-gray-600 mb-4">{description}</p>}
        {action && (
          <button
            onClick={action.onClick}
            className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
          >
            {action.label}
          </button>
        )}
      </div>
    );
  }
  ```
- [ ] 在 UsersTable 中使用
  ```typescript
  function UsersEmptyState() {
    return (
      <EmptyState
        icon={
          <svg className="w-24 h-24" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
        }
        title="目前沒有使用者"
        description="新增第一位使用者開始使用系統"
      />
    );
  }
  ```
- [ ] 空狀態友善且具引導性

**相關文件**：
- [Empty State Design](https://www.nngroup.com/articles/empty-state/)

**所需技能**：
- Empty State UI 設計
- User Guidance
- Component Composition

**預估時間**: 1 小時

---

### 📋 任務：加入分頁載入動畫（切換頁面時的 Loading）

**驗收標準**：
- [ ] 在 UsersTable 中加入分頁載入指示
  ```typescript
  export function UsersTable() {
    const [page, setPage] = useState(1);
    const { data, isLoading, isFetching, isError, error, refetch } = useUsers({
      page,
      limit: 10,
    });

    // ... 其他邏輯

    return (
      <div className="relative">
        {isFetching && !isLoading && (
          <div className="absolute top-0 right-0 p-2">
            <Spinner size="sm" />
          </div>
        )}

        {/* 表格內容 */}

        <Pagination
          currentPage={page}
          totalPages={data.pagination.totalPages}
          onPageChange={setPage}
          isLoading={isFetching}
        />
      </div>
    );
  }
  ```
- [ ] 建立 Spinner 元件
  ```typescript
  // src/shared/ui/Spinner.tsx
  interface SpinnerProps {
    size?: 'sm' | 'md' | 'lg';
  }

  export function Spinner({ size = 'md' }: SpinnerProps) {
    const sizeClass = {
      sm: 'w-4 h-4',
      md: 'w-8 h-8',
      lg: 'w-12 h-12',
    }[size];

    return (
      <div className={`${sizeClass} border-4 border-gray-200 border-t-blue-500 rounded-full animate-spin`} />
    );
  }
  ```
- [ ] 分頁切換時顯示載入指示
- [ ] 不阻斷使用者操作

**相關文件**：
- [TanStack Query - isFetching vs isLoading](https://tanstack.com/query/latest/docs/react/guides/background-fetching-indicators)

**所需技能**：
- Loading Indicators
- isFetching vs isLoading
- CSS Spinner Animation

**預估時間**: 1 小時

---

# Phase 5: 頁面與路由

## 5.1 登入頁面（Form Experience UX）

### 📋 任務：建立 `pages/login.tsx`

**驗收標準**：
- [ ] 建立 `src/pages/login.tsx`
  ```typescript
  import { useForm } from 'react-hook-form';
  import { zodResolver } from '@hookform/resolvers/zod';
  import { loginCredentialsSchema, LoginCredentials } from '@/auth/auth.schemas';
  import { login } from '@/auth/auth.api';
  import { useAuthStore } from '@/auth/auth.store';
  import { useNavigate } from 'react-router-dom';
  import { useState } from 'react';

  export function LoginPage() {
    const navigate = useNavigate();
    const setAuth = useAuthStore((state) => state.setAuth);
    const [apiError, setApiError] = useState<string | null>(null);

    const {
      register,
      handleSubmit,
      formState: { errors, isSubmitting },
    } = useForm<LoginCredentials>({
      resolver: zodResolver(loginCredentialsSchema),
    });

    const onSubmit = async (data: LoginCredentials) => {
      try {
        setApiError(null);
        const response = await login(data);
        setAuth(response.user, response.tokens);
        navigate('/users');
      } catch (error: any) {
        setApiError(error.message || '登入失敗，請稍後再試');
      }
    };

    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="max-w-md w-full bg-white p-8 rounded-lg shadow">
          <h1 className="text-2xl font-bold mb-6 text-center">登入</h1>

          {apiError && (
            <div className="bg-red-50 text-red-600 p-3 rounded mb-4">
              {apiError}
            </div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-1">
                使用者名稱
              </label>
              <input
                {...register('username')}
                type="text"
                autoComplete="username"
                className="w-full px-3 py-2 border rounded"
                placeholder="請輸入使用者名稱"
              />
              {errors.username && (
                <p className="text-red-500 text-sm mt-1">
                  {errors.username.message}
                </p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">
                密碼
              </label>
              <input
                {...register('password')}
                type="password"
                autoComplete="current-password"
                className="w-full px-3 py-2 border rounded"
                placeholder="請輸入密碼"
              />
              {errors.password && (
                <p className="text-red-500 text-sm mt-1">
                  {errors.password.message}
                </p>
              )}
            </div>

            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 disabled:opacity-50"
            >
              {isSubmitting ? '登入中...' : '登入'}
            </button>
          </form>
        </div>
      </div>
    );
  }
  ```
- [ ] 表單驗證正常（React Hook Form + Zod）
- [ ] 錯誤訊息顯示在欄位下方
- [ ] 提交中按鈕禁用並顯示 Loading
- [ ] 登入成功後導向使用者列表頁

**相關文件**：
- [React Hook Form](https://react-hook-form.com/)
- [React Hook Form + Zod](https://react-hook-form.com/get-started#SchemaValidation)

**所需技能**：
- React Hook Form
- Zod Resolver
- Form Validation
- Error Handling

**預估時間**: 3 小時

---

由於文件已經非常長，我將繼續創建 Phase 6-8 的文件。**請稍等片刻...**
