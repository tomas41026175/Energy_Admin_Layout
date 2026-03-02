# Design Spec — Energy Admin

> 從 `design-v1.pen` 提取的精確設計規格，實作時以此為準。

---

## 設計 Tokens

### 顏色

```ts
// src/shared/styles/tokens.ts
export const colors = {
  primary:        '#E42313',   // 主色（紅）
  primaryLight:   '#FEF2F2',   // 主色淺背景（nav active）
  primaryShadow:  '#E4231340', // 主色40%（按鈕 shadow）
  primaryHover:   '#E4231315', // 主色15%（nav item shadow）

  textPrimary:   '#0D0D0D',   // 主文字
  textSecondary: '#7A7A7A',   // 次要文字、標籤、placeholder
  border:        '#E8E8E8',   // 所有 border
  background:    '#FFFFFF',   // 背景

  statusActive:  '#22C55E',   // 啟用狀態（green-500）
  statusInactive:'#E42313',   // 停用狀態（primary red）
} as const;
```

### 字型

```ts
export const typography = {
  fontDisplay: 'Space Grotesk', // Logo、頁面標題、按鈕
  fontBody:    'Inter',          // 內文、標籤、表單

  // 大小
  pageTitle:   { size: 32, weight: 600, letterSpacing: -0.5 },
  logoText:    { size: 18, weight: 600 },
  navLabel:    { size: 14 },
  button:      { size: 14, weight: 500 },
  formLabel:   { size: 14, weight: 500 },
  formInput:   { size: 14 },
  bodySmall:   { size: 12 },
} as const;
```

### Shadow 系統

```ts
export const shadows = {
  card:    'shadow: blur 8px offset(0,2) color #00000008',   // 卡片
  sidebar: 'shadow: blur 8px offset(2,0) color #00000008',  // 側邊欄
  login:   'shadow: blur 24px offset(0,4) color #00000015', // Login card
  input:   'shadow: blur 3px offset(0,1) color #00000005',  // 表單輸入
  button:  'shadow: blur 12px offset(0,4) color #E4231340', // 主按鈕
  navItem: 'shadow: blur 4px offset(0,2) color #E4231315',  // Nav 選中項
} as const;

// Tailwind 對應
// card:    shadow-[0_2px_8px_rgba(0,0,0,0.03)]
// sidebar: shadow-[2px_0_8px_rgba(0,0,0,0.03)]
// login:   shadow-[0_4px_24px_rgba(0,0,0,0.08)]
// button:  shadow-[0_4px_12px_rgba(228,35,19,0.25)]
```

---

## 元件規格

### Sidebar

```
寬度: 240px（桌面）/ 0+overlay（平板、手機）
背景: #FFFFFF
右邊框: 1px solid #E8E8E8
Shadow: 2px 0 8px rgba(0,0,0,0.03)
Padding: 32px（桌面）/ 24px（平板）/ 20px（手機展開）
Gap（sections）: 16px
```

**Logo 區塊**:
```
Icon: Lucide Shield, 24px, #E42313
Text: Space Grotesk 18px 600, #0D0D0D
Gap: 12px
Bottom padding: 16px（與 nav 分隔）
```

**Nav Item（未選中）**:
```
背景: #FFFFFF
Padding: 8px 16px
Icon: 18px, #7A7A7A
Label: Inter 14px normal, #7A7A7A
Gap: 12px
```

**Nav Item（選中）**:
```
背景: #FEF2F2
Left border: 2px solid #E42313
Shadow: 0 2px 4px #E4231315
Padding: 8px 16px
Icon: 18px, #E42313
Label: Inter 14px 500, #0D0D0D
Gap: 12px
```

**Nav 項目清單（by 設計稿）**:
| Icon | Label | Route |
|------|-------|-------|
| layout-dashboard | 儀表板 | /dashboard |
| users | 使用者管理 | /users |
| settings | 設定 | /settings |

**User Section（底部）**:
```
Top border: 1px solid #E8E8E8
Top padding: 32px
Avatar: 40px 圓形, 背景 #E42313
Padding: 12px 16px
```

---

### Login Card

```
寬度: 400px
Padding: 48px top/bottom, 40px left/right
Gap: 32px
背景: #FFFFFF
Border: 1px solid #E8E8E8
Shadow: 0 4px 24px rgba(0,0,0,0.08)
頁面背景: #FFFFFF, 垂直置中
```

**Login Header**:
```
Icon: Lucide Shield 48px, #E42313
Title: Space Grotesk 32px 600, #0D0D0D
Subtitle: Inter 14px normal, #7A7A7A — "後台管理系統"
Gap: 8px
Layout: vertical, 置中對齊
```

**Form 欄位**:
```
Label: Inter 14px 500, #0D0D0D
Input height: 44px
Input padding: 0 16px
Input border: 1px solid #E8E8E8
Input shadow: 0 1px 3px rgba(0,0,0,0.02)
Input font: Inter 14px normal, #0D0D0D
Gap（label→input）: 8px
Gap（fields）: 24px（loginForm gap）
```

**密碼欄位**: 右側顯示 eye-off icon (18px, #7A7A7A)

**Login Button**:
```
高度: 44px
背景: #E42313
文字: Space Grotesk 14px 500, #FFFFFF — "登入"
Shadow: 0 4px 12px rgba(228,35,19,0.25)
Width: fill
Layout: 置中
```

---

### Users Table

**Page Header**:
```
Title: Space Grotesk 32px 600 letter-spacing -0.5, #0D0D0D — "使用者管理"
```

**Pagination 資訊**: Inter, "顯示 {from}-{to} 筆, 共 {total} 筆"
**Table Container**:
```
cornerRadius: 8px
Border: 1px solid #E8E8E8
Shadow: 0 2px 8px rgba(0,0,0,0.03)
背景: #FFFFFF
```

**Table Columns（by 設計稿）**:
| 欄位 | 寬度 | 說明 |
|------|------|------|
| 狀態 | ~80px | Status badge |
| 使用者帳號 | flex | Name + email |
| （空欄） | flex | 待確認 |
| 最後停用 | ~120px | Date |
| 操作 | ~80px | Edit + Delete icons |

**Status Badge**:
```
啟用: 背景 #22C55E, 文字白色, 圓角
停用: 背景 #E42313, 文字白色, 圓角
```

**Row Actions**:
```
Edit: Lucide pencil icon
Delete: Lucide trash icon
```

---

## RWD 斷點

| 裝置 | 寬度 | Sidebar |
|------|------|---------|
| 桌面 | 1440px | 固定 240px |
| 平板 | 768px | 收合（漢堡選單展開 Overlay） |
| 手機 | 375px | 收合（漢堡選單展開 Overlay） |

**手機/平板 Header**:
```
高度: 64px
左側: 漢堡按鈕 44×44px padding 12px
Title: Space Grotesk 20px 600, #0D0D0D — "儀表板"
底部 border: 1px solid #E8E8E8
Shadow: 0 2px 8px rgba(0,0,0,0.03)
```

**Overlay（展開時）**:
```
背景: rgba(0,0,0,0.25)
Sidebar width: 320px（手機展開）/ 240px（平板展開）
Shadow: 4px 0 16px rgba(0,0,0,0.08)
```

---

## 實作注意事項

1. **字型引入**: Google Fonts — Space Grotesk (400, 500, 600), Inter (400, 500, 600)
2. **Icon 套件**: Lucide React (`lucide-react`)，以設計稿 icon name 為準
3. **Tailwind 自訂顏色**: 在 `tailwind.config.ts` 擴充 `colors.primary`
4. **有疑慮的設計細節**:
   - 第三個 table column（空欄）內容不明確 → 待確認
   - Dashboard 的 chart 區塊設計稿為空白 → 此版本可能不實作 chart

---

**來源**: `Energy_Admin/design-v1.pen`
**提取日期**: 2026-03-03
