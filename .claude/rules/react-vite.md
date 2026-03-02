# React + Vite 開發規範

## 元件規範

- 元件使用 **function + arrow function** 風格
- Props 一律定義 `interface`（PascalCase），放在元件上方
- 無 children 的元件使用自閉合標籤

```tsx
// ✅ Good
interface UserCardProps {
  user: User;
  onSelect: (id: string) => void;
}

const UserCard = ({ user, onSelect }: UserCardProps) => {
  return <div onClick={() => onSelect(user.id)}>{user.name}</div>;
};

// ❌ Bad
const UserCard = (props: any) => { ... }
```

## 狀態管理

- **Server State**: TanStack Query（所有 API 呼叫）
- **Global Client State**: Zustand（僅 Auth）
- **Local State**: useState/useReducer
- 禁止在 TanStack Query 之外直接呼叫 API

```ts
// ✅ Good — domain hook 封裝 query
export const useUsers = (params: UsersParams) =>
  useQuery({
    queryKey: ['users', params],
    queryFn: () => usersApi.getUsers(params),
  });

// ❌ Bad — 直接在元件內呼叫 API
const [users, setUsers] = useState([]);
useEffect(() => { axios.get('/users').then(setUsers) }, []);
```

## 資料夾規範

- `domains/{name}/` 內放：`types`, `schemas`, `api`, `hooks`, `components`
- `pages/` 只做路由組合，不放業務邏輯
- `shared/` 放跨 domain 的通用邏輯

## Tailwind CSS

- 使用 `cn()` (clsx + tailwind-merge) 合併 class
- 響應式優先使用 mobile-first (`sm:`, `md:`, `lg:`)
- 禁止 inline style（除動態值）

## TypeScript

- 啟用 strict mode
- 禁止 `any`（用 `unknown` + type guard）
- API 回應型別用 Zod schema 推導（`z.infer<typeof Schema>`）

## useEffect 使用原則（重要）

**原則：盡可能避免 useEffect。** 大多數情況都有更好的替代方案。

| 情境 | 替代方案 |
|------|---------|
| 資料獲取 | TanStack Query `useQuery` |
| 提交後更新 | `useMutation` 的 `onSuccess` |
| URL 同步狀態 | `useSearchParams` |
| 計算衍生值 | `useMemo` 或 render 中直接計算 |
| 表單初始值 | `useForm` 的 `defaultValues` |

```tsx
// ❌ 禁止
useEffect(() => { fetchUsers().then(setUsers); }, [page]);

// ✅ 正確
const { data } = useUsers({ page });
```

若確實需要 useEffect，必須留下說明註解。

## 元件設計

- 超過 100 行考慮拆分
- Props drilling 超過 2 層改用 Context
- 列表 item 元件獨立抽取

## 設計稿對照

- 實作前先確認設計稿（`Energy_Admin/design-v1.pen`）
- 像素級對照 spacing / color / typography
- 有疑慮主動提出，不自行猜測

## 效能

- 路由層級使用 `React.lazy` + `Suspense`
- 列表元件避免不必要的 re-render（React.memo）
- TanStack Query 善用 `staleTime` 減少重複請求
