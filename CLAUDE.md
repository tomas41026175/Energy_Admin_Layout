# Energy Admin — Workspace

## 專案結構

雙層 Git 架構：
- **Layer 1** (`Energy_Admin_Layout/`): Workspace — 計畫、設定、Agent 協作配置
- **Layer 2** (`Energy_Admin/`): Project — 設計稿、技術文件、實際程式碼

## 技術棧

- **框架**: React 18 + TypeScript (strict)
- **建置**: Vite
- **Server State**: TanStack Query v5
- **Client State**: Zustand（僅 Auth）
- **HTTP**: Axios（含攔截器 + Token 刷新）
- **路由**: React Router
- **表單**: React Hook Form + Zod
- **樣式**: Tailwind CSS
- **測試**: Vitest + MSW + React Testing Library

## 架構原則

Domain-driven 資料夾結構：
```
src/
├── app/        # Providers、Router、入口
├── auth/       # 橫切關注點：登入、Token、路由守衛
├── domains/    # 業務領域模組 (e.g., users/)
├── shared/     # 跨領域共用：API client、UI、utils
└── pages/      # 路由層級元件（薄層，組合 domain）
```

## 規範

- @.claude/rules/react-vite.md
- @.claude/rules/testing.md
- @.claude/rules/git-workflow.md

## Agent Team

多人協作時使用 `.claude/agents/` 中定義的 agent。
Team protocol 見 `.claude/teams/energy-admin/protocol.md`。

## 重要文件

- 實作路線圖: `plan/implementation-roadmap.md`
- 技術決策: `Energy_Admin/docs/02-technical-decisions.md`
- API 文件: `Energy_Admin/docs/04-api-documentation.md`
- 測試策略: `Energy_Admin/docs/05-testing-strategy.md`
