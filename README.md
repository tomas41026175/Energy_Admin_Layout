# Energy Admin — Workspace

雙層 Git 架構的開發 Workspace。

## 架構說明

```
Energy_Admin_Layout/          ← Layer 1: Workspace（此 repo）
├── .gitignore                    追蹤 plan/、腳本、workspace 設定
├── setup.sh                      管理 Layer 2 的 clone/pull
├── plan/                         實作計畫文件
│   ├── implementation-roadmap.md
│   ├── task-breakdown-master.md
│   └── ...
└── Energy_Admin/             ← Layer 2: Project（獨立 repo）
    ├── .git/                     由 setup.sh 管理，不進 Layer 1
    ├── design-v1.pen             設計稿
    ├── docs/                     技術文件
    └── README.md
```

| 層級 | 目的 | Git 管理 |
|------|------|----------|
| Layer 1 (Workspace) | 計畫、腳本、workspace 設定 | 此 repo |
| Layer 2 (Project) | 實際程式碼、設計稿、技術文件 | 獨立 repo（Energy-Admin） |

## 快速開始

### 首次設定

```bash
# clone workspace
git clone <workspace-repo-url>
cd Energy_Admin_Layout

# 拉取 Energy-Admin project
bash setup.sh

# 拉取 + 安裝依賴
bash setup.sh --install
```

### 指定 repo URL

```bash
export ENERGY_ADMIN_REPO=https://github.com/<user>/Energy-Admin.git
bash setup.sh
```

### 日常更新

```bash
# 在 workspace 根目錄執行
bash setup.sh          # pull Layer 2 最新版本
```

## 文件

計畫文件位於 `plan/`，技術文件位於 `Energy_Admin/docs/`。

- [實作路線圖](./plan/implementation-roadmap.md)
- [任務拆解](./plan/task-breakdown-master.md)
