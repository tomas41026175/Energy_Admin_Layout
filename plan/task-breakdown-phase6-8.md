# 任務詳細分解 - Phase 6-8

> UI 優化、測試完善與效能優化、CI/CD 與 Vercel 部署的詳細驗收標準、參考文件和所需技能

**版本**: v1.0
**建立日期**: 2026-03-03
**最後更新**: 2026-03-03

---

## 📚 目錄

- [Phase 6: UI 優化](#phase-6-ui-優化)
- [Phase 7: 測試完善與效能優化](#phase-7-測試完善與效能優化)
- [Phase 8: CI/CD 與 Vercel 部署](#phase-8-cicd-與-vercel-部署)

---

# Phase 6: UI 優化

## 6.1 共用 UI 元件

### 📋 任務：建立 `shared/ui/Button.tsx`（含 Loading 狀態）

**驗收標準**：
- [ ] 建立 `src/shared/ui/Button.tsx`
  ```typescript
  import { ButtonHTMLAttributes } from 'react';

  interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
    variant?: 'primary' | 'secondary' | 'danger';
    size?: 'sm' | 'md' | 'lg';
    isLoading?: boolean;
  }

  export function Button({
    variant = 'primary',
    size = 'md',
    isLoading = false,
    disabled,
    children,
    className = '',
    ...props
  }: ButtonProps) {
    const baseClass = 'rounded font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2';

    const variantClass = {
      primary: 'bg-blue-500 text-white hover:bg-blue-600 focus:ring-blue-500',
      secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500',
      danger: 'bg-red-500 text-white hover:bg-red-600 focus:ring-red-500',
    }[variant];

    const sizeClass = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-base',
      lg: 'px-6 py-3 text-lg',
    }[size];

    return (
      <button
        className={`${baseClass} ${variantClass} ${sizeClass} ${className} disabled:opacity-50 disabled:cursor-not-allowed`}
        disabled={disabled || isLoading}
        {...props}
      >
        {isLoading ? (
          <span className="flex items-center justify-center">
            <svg className="animate-spin -ml-1 mr-2 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            處理中...
          </span>
        ) : (
          children
        )}
      </button>
    );
  }
  ```
- [ ] 支援 3 種 variant（primary、secondary、danger）
- [ ] 支援 3 種 size（sm、md、lg）
- [ ] Loading 狀態顯示 spinner 和「處理中」文字
- [ ] Focus 狀態有明顯樣式

**相關文件**：
- [Tailwind CSS - Button Component](https://tailwindui.com/components/application-ui/elements/buttons)
- [A11y - Button Best Practices](https://www.w3.org/WAI/ARIA/apg/patterns/button/)

**所需技能**：
- React Component Props
- TypeScript Generics
- Tailwind CSS Variants
- A11y Focus States

**預估時間**: 2 小時

---

### 📋 任務：建立 `shared/ui/Input.tsx`（含錯誤狀態與 Helper Text）

**驗收標準**：
- [ ] 建立 `src/shared/ui/Input.tsx`
  ```typescript
  import { InputHTMLAttributes, forwardRef } from 'react';

  interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
    label?: string;
    error?: string;
    helperText?: string;
  }

  export const Input = forwardRef<HTMLInputElement, InputProps>(
    ({ label, error, helperText, className = '', ...props }, ref) => {
      const inputClass = error
        ? 'border-red-500 focus:ring-red-500'
        : 'border-gray-300 focus:ring-blue-500';

      return (
        <div className="w-full">
          {label && (
            <label className="block text-sm font-medium text-gray-700 mb-1">
              {label}
              {props.required && <span className="text-red-500 ml-1">*</span>}
            </label>
          )}

          <input
            ref={ref}
            className={`w-full px-3 py-2 border rounded-md shadow-sm focus:outline-none focus:ring-2 ${inputClass} ${className}`}
            aria-invalid={!!error}
            aria-describedby={error ? `${props.id}-error` : helperText ? `${props.id}-helper` : undefined}
            {...props}
          />

          {helperText && !error && (
            <p id={`${props.id}-helper`} className="mt-1 text-sm text-gray-500">
              {helperText}
            </p>
          )}

          {error && (
            <p id={`${props.id}-error`} className="mt-1 text-sm text-red-500">
              {error}
            </p>
          )}
        </div>
      );
    }
  );

  Input.displayName = 'Input';
  ```
- [ ] 支援 label（含必填標記）
- [ ] 支援 error 狀態（紅色邊框 + 錯誤訊息）
- [ ] 支援 helperText（灰色提示文字）
- [ ] 使用 forwardRef（相容 React Hook Form）
- [ ] 正確的 ARIA 屬性（aria-invalid、aria-describedby）

**相關文件**：
- [React - forwardRef](https://react.dev/reference/react/forwardRef)
- [A11y - Input Accessibility](https://www.w3.org/WAI/tutorials/forms/)

**所需技能**：
- React forwardRef
- ARIA Attributes
- Form Accessibility
- Error States

**預估時間**: 2 小時

---

### 📋 任務：完善 `shared/ui/Skeleton.tsx`（多種形狀）

**驗收標準**：
- [ ] 擴充 Skeleton 元件支援更多變體
  ```typescript
  interface SkeletonProps {
    className?: string;
    variant?: 'text' | 'circular' | 'rectangular' | 'avatar' | 'card';
    width?: string | number;
    height?: string | number;
  }

  export function Skeleton({
    className = '',
    variant = 'text',
    width,
    height,
  }: SkeletonProps) {
    const baseClass = 'animate-pulse bg-gray-200';

    const variantClasses = {
      text: 'rounded h-4',
      circular: 'rounded-full',
      rectangular: 'rounded-md',
      avatar: 'rounded-full w-10 h-10',
      card: 'rounded-lg',
    };

    const style: React.CSSProperties = {};
    if (width) style.width = typeof width === 'number' ? `${width}px` : width;
    if (height) style.height = typeof height === 'number' ? `${height}px` : height;

    return (
      <div
        className={`${baseClass} ${variantClasses[variant]} ${className}`}
        style={style}
      />
    );
  }
  ```
- [ ] 支援 5 種 variant（text、circular、rectangular、avatar、card）
- [ ] 支援自訂 width 和 height
- [ ] 動畫流暢（animate-pulse）

**相關文件**：
- [Skeleton Screen Design](https://www.nngroup.com/articles/skeleton-screens/)

**所需技能**：
- CSS Animation
- Component Variants
- Inline Styles

**預估時間**: 1 小時

---

### 📋 任務：完善 `shared/ui/ErrorMessage.tsx`（含重試按鈕）

**驗收標準**：
- [ ] 已在 Phase 4 建立，確保符合規範
- [ ] 支援自訂圖示
- [ ] 支援多種錯誤等級（error、warning、info）
  ```typescript
  interface ErrorMessageProps {
    message: string;
    severity?: 'error' | 'warning' | 'info';
    onRetry?: () => void;
    icon?: React.ReactNode;
  }

  export function ErrorMessage({
    message,
    severity = 'error',
    onRetry,
    icon,
  }: ErrorMessageProps) {
    const severityStyles = {
      error: 'text-red-500 bg-red-50',
      warning: 'text-yellow-600 bg-yellow-50',
      info: 'text-blue-500 bg-blue-50',
    };

    return (
      <div className={`flex flex-col items-center justify-center p-8 rounded-lg ${severityStyles[severity]}`}>
        {icon || (
          <div className="mb-4">
            {/* Default icon based on severity */}
          </div>
        )}
        <h3 className="text-lg font-semibold mb-2">
          {severity === 'error' ? '載入失敗' : severity === 'warning' ? '注意' : '提示'}
        </h3>
        <p className="text-center mb-4">{message}</p>
        {onRetry && (
          <Button onClick={onRetry} variant="primary">
            重試
          </Button>
        )}
      </div>
    );
  }
  ```
- [ ] 測試所有 severity

**相關文件**：
- [Error Message Design](https://www.nngroup.com/articles/error-message-guidelines/)

**所需技能**：
- Error UI Design
- Severity Levels
- User Feedback

**預估時間**: 1 小時

---

### 📋 任務：建立 `shared/ui/ConfirmDialog.tsx`（確認對話框）

**驗收標準**：
- [ ] 建立 `src/shared/ui/ConfirmDialog.tsx`
  ```typescript
  interface ConfirmDialogProps {
    isOpen: boolean;
    onClose: () => void;
    onConfirm: () => void;
    title: string;
    message: string;
    confirmText?: string;
    cancelText?: string;
    variant?: 'danger' | 'warning' | 'info';
  }

  export function ConfirmDialog({
    isOpen,
    onClose,
    onConfirm,
    title,
    message,
    confirmText = '確認',
    cancelText = '取消',
    variant = 'info',
  }: ConfirmDialogProps) {
    if (!isOpen) return null;

    const variantStyles = {
      danger: 'text-red-600',
      warning: 'text-yellow-600',
      info: 'text-blue-600',
    };

    const handleConfirm = () => {
      onConfirm();
      onClose();
    };

    return (
      <>
        {/* Backdrop */}
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-40"
          onClick={onClose}
        />

        {/* Dialog */}
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
            <h3 className={`text-lg font-semibold mb-2 ${variantStyles[variant]}`}>
              {title}
            </h3>
            <p className="text-gray-600 mb-6">{message}</p>

            <div className="flex justify-end gap-3">
              <Button variant="secondary" onClick={onClose}>
                {cancelText}
              </Button>
              <Button
                variant={variant === 'danger' ? 'danger' : 'primary'}
                onClick={handleConfirm}
              >
                {confirmText}
              </Button>
            </div>
          </div>
        </div>
      </>
    );
  }
  ```
- [ ] 支援 3 種 variant（danger、warning、info）
- [ ] 點擊背景關閉
- [ ] 確認後自動關閉
- [ ] 正確的 z-index 層級

**相關文件**：
- [Dialog (Modal) Accessibility](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)
- [Headless UI - Dialog](https://headlessui.com/react/dialog)

**所需技能**：
- Modal/Dialog Pattern
- Portal Rendering
- Event Handling
- A11y Focus Management

**預估時間**: 2.5 小時

---

## 6.2 響應式設計（RWD）

### 📋 任務：實作手機版佈局（< 768px）

**驗收標準**：
- [ ] 導航選單適配
  ```typescript
  // src/shared/components/Navigation.tsx
  export function Navigation() {
    const [isMenuOpen, setIsMenuOpen] = useState(false);

    return (
      <nav className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            {/* Logo */}
            <div className="flex items-center">
              <h1 className="text-xl font-bold">Energy Admin</h1>
            </div>

            {/* Mobile menu button */}
            <div className="flex items-center md:hidden">
              <button
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="p-2"
                aria-label="Toggle menu"
              >
                {/* Hamburger icon */}
              </button>
            </div>

            {/* Desktop menu */}
            <div className="hidden md:flex items-center gap-4">
              <Link to="/users">使用者列表</Link>
              <button onClick={handleLogout}>登出</button>
            </div>
          </div>
        </div>

        {/* Mobile menu */}
        {isMenuOpen && (
          <div className="md:hidden">
            <div className="px-2 pt-2 pb-3 space-y-1">
              <Link to="/users" className="block px-3 py-2">
                使用者列表
              </Link>
              <button onClick={handleLogout} className="block w-full text-left px-3 py-2">
                登出
              </button>
            </div>
          </div>
        )}
      </nav>
    );
  }
  ```
- [ ] 表格轉為卡片式呈現
  ```typescript
  // src/domains/users/UserCard.tsx (mobile view)
  export function UserCard({ user }: { user: User }) {
    return (
      <div className="bg-white p-4 rounded-lg shadow mb-4 md:hidden">
        <div className="flex items-center gap-3 mb-3">
          {user.avatar ? (
            <img src={user.avatar} alt={user.username} className="w-12 h-12 rounded-full" />
          ) : (
            <div className="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center">
              {user.username[0]}
            </div>
          )}
          <div>
            <h3 className="font-medium">{user.username}</h3>
            <p className="text-sm text-gray-500">{user.email || '-'}</p>
          </div>
        </div>
        <div className="flex justify-between items-center">
          <span className={`px-2 py-1 rounded text-sm ${user.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}`}>
            {user.status === 'active' ? '啟用' : '停用'}
          </span>
          <span className="text-sm text-gray-500">
            {new Date(user.createdAt).toLocaleDateString()}
          </span>
        </div>
      </div>
    );
  }
  ```
- [ ] 表單欄位垂直排列
  ```tsx
  <form className="space-y-4">
    {/* 手機版自動垂直排列 */}
  </form>
  ```
- [ ] 測試在 iPhone SE (375px)、iPhone 12 (390px) 正常

**相關文件**：
- [Tailwind CSS - Responsive Design](https://tailwindcss.com/docs/responsive-design)
- [Mobile First Design](https://www.lukew.com/ff/entry.asp?933)

**所需技能**：
- Tailwind Responsive Utilities (sm:, md:, lg:)
- Mobile-first Design
- Hamburger Menu Pattern
- Card Layout

**預估時間**: 4 小時

---

### 📋 任務：實作平板版佈局（768-1024px）

**驗收標準**：
- [ ] 側邊欄摺疊功能（如果有側邊欄）
- [ ] 表格簡化顯示（隱藏次要欄位）
  ```typescript
  <table>
    <thead>
      <tr>
        <th>頭像</th>
        <th>使用者名稱</th>
        <th className="hidden lg:table-cell">Email</th>
        <th>狀態</th>
        <th className="hidden lg:table-cell">建立時間</th>
      </tr>
    </thead>
    <tbody>
      {users.map((user) => (
        <tr key={user.id}>
          <td>{/* avatar */}</td>
          <td>{user.username}</td>
          <td className="hidden lg:table-cell">{user.email}</td>
          <td>{/* status */}</td>
          <td className="hidden lg:table-cell">{user.createdAt}</td>
        </tr>
      ))}
    </tbody>
  </table>
  ```
- [ ] 測試在 iPad (768px)、iPad Pro (1024px) 正常

**相關文件**：
- [Responsive Tables](https://css-tricks.com/responsive-data-tables/)

**所需技能**：
- Tailwind md: lg: Breakpoints
- Progressive Disclosure
- Table Responsiveness

**預估時間**: 2 小時

---

### 📋 任務：實作桌面版佈局（> 1024px）

**驗收標準**：
- [ ] 完整表格顯示（所有欄位）
- [ ] 側邊欄展開（如果有）
- [ ] 最佳閱讀寬度（max-w-7xl）
- [ ] 測試在 1920x1080、2560x1440 正常

**相關文件**：
- [Desktop Layout Best Practices](https://www.nngroup.com/articles/page-layout/)

**所需技能**：
- Container Constraints
- Grid/Flexbox Layout
- Wide Screen Optimization

**預估時間**: 1 小時

---

## 6.3 無障礙性（Accessibility）

### 📋 任務：實作鍵盤導航支援（Tab、Enter、Escape）

**驗收標準**：
- [ ] 所有互動元素可用 Tab 鍵導航
  - [ ] 按鈕
  - [ ] 連結
  - [ ] 表單輸入框
  - [ ] 分頁按鈕
- [ ] Enter 鍵可觸發主要操作
  - [ ] 登入表單按 Enter 提交
  - [ ] 按鈕按 Enter 觸發
- [ ] Escape 鍵關閉對話框
  ```typescript
  // ConfirmDialog.tsx
  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      return () => document.removeEventListener('keydown', handleEscape);
    }
  }, [isOpen, onClose]);
  ```
- [ ] Tab 順序符合視覺順序

**相關文件**：
- [Keyboard Accessibility](https://webaim.org/techniques/keyboard/)
- [WCAG 2.1 - Keyboard Accessible](https://www.w3.org/WAI/WCAG21/Understanding/keyboard.html)

**所需技能**：
- Keyboard Events
- Tab Index Management
- Focus Management
- Event Listeners

**預估時間**: 3 小時

---

### 📋 任務：加入 ARIA 屬性（aria-label、aria-describedby）

**驗收標準**：
- [ ] 按鈕有 aria-label（尤其是圖示按鈕）
  ```tsx
  <button aria-label="關閉選單" onClick={handleClose}>
    <XIcon />
  </button>
  ```
- [ ] 表單輸入框有 aria-describedby
  ```tsx
  <input
    id="username"
    aria-describedby="username-helper"
    {...register('username')}
  />
  <p id="username-helper">請輸入 3-20 個字元</p>
  ```
- [ ] 錯誤訊息有 aria-live
  ```tsx
  <div role="alert" aria-live="assertive">
    {error.message}
  </div>
  ```
- [ ] Loading 狀態有 aria-busy
  ```tsx
  <div aria-busy={isLoading}>
    {/* content */}
  </div>
  ```

**相關文件**：
- [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [MDN - ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA)

**所需技能**：
- ARIA Attributes
- Screen Reader Testing
- Semantic HTML

**預估時間**: 2 小時

---

### 📋 任務：實作 Focus 狀態樣式

**驗收標準**：
- [ ] 所有互動元素有明顯的 Focus 樣式
  ```css
  /* Tailwind CSS */
  .btn {
    @apply focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2;
  }

  input {
    @apply focus:ring-2 focus:ring-blue-500 focus:border-blue-500;
  }
  ```
- [ ] Focus 樣式符合 WCAG 對比度要求
- [ ] 不要使用 `outline: none` 而沒有替代的 Focus 指示

**相關文件**：
- [Focus Visible](https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible)
- [WCAG - Focus Indicator](https://www.w3.org/WAI/WCAG21/Understanding/focus-visible.html)

**所需技能**：
- CSS Focus States
- Tailwind Focus Utilities
- Contrast Ratios

**預估時間**: 1.5 小時

---

### 📋 任務：確保色彩對比度符合 WCAG AA（4.5:1）

**驗收標準**：
- [ ] 使用對比度檢查工具驗證
  - [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
  - [Colorable](https://colorable.jxnblk.com/)
- [ ] 主要文字對比度 ≥ 4.5:1
- [ ] 大文字（18pt+）對比度 ≥ 3:1
- [ ] UI 元件（按鈕、輸入框邊框）對比度 ≥ 3:1
- [ ] 修正不符合標準的顏色
  ```css
  /* 不佳 */
  .text-gray-400 on bg-white /* 對比度 2.5:1 */

  /* 良好 */
  .text-gray-600 on bg-white /* 對比度 4.6:1 */
  ```

**相關文件**：
- [WCAG 2.1 - Contrast Minimum](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)

**所需技能**：
- Color Theory
- Contrast Checking
- Accessible Color Palettes

**預估時間**: 2 小時

---

### 📋 任務：加入 Skip to Content 連結

**驗收標準**：
- [ ] 在 `App.tsx` 最頂層加入 Skip Link
  ```typescript
  export function App() {
    return (
      <>
        <a
          href="#main-content"
          className="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-blue-500 focus:text-white focus:rounded"
        >
          跳到主要內容
        </a>

        <Navigation />

        <main id="main-content" tabIndex={-1}>
          <Outlet />
        </main>
      </>
    );
  }
  ```
- [ ] Skip Link 只在鍵盤 Focus 時顯示
- [ ] 點擊後正確跳到主要內容

**相關文件**：
- [Skip Navigation Links](https://webaim.org/techniques/skipnav/)

**所需技能**：
- Skip Link Pattern
- Screen Reader Only Styles
- Focus Management

**預估時間**: 1 小時

---

由於篇幅限制，我將繼續創建 master index 文件。**請稍等...**
