# Git Workflow

## Commit 格式

```
<type>(<scope>): <中文摘要>
```

- type: `feat` / `fix` / `refactor` / `test` / `docs` / `chore` / `style`
- scope: `auth` / `users` / `shared` / `ui` / `api` / `config`

範例:
```
feat(auth): 實作登入與 Token 刷新機制
fix(users): 修正分頁查詢參數錯誤
test(auth): 補充 Session Restore 整合測試
```

## Branch Naming

- Feature: `feat/{description}`
- Bugfix: `fix/{description}`
- Refactor: `refactor/{description}`

## 強制規則

- **禁止直接修改 main** — 所有實作必須先建立 feature branch
- 小步提交，每次一個邏輯變更
- **PR 必須完全符合驗收標準** — 使用 `energy-phase-verify` 確認後才建立 PR
- **並行任務必須使用 worktree** — `git worktree add .worktrees/{branch} {branch}`
- 永遠不要 force push 到 main

## Worktree 工作流程

```bash
# 建立 worktree（並行任務）
git worktree add .worktrees/feat-auth feat/auth
cd .worktrees/feat-auth

# 完成後移除
git worktree remove .worktrees/feat-auth
git branch -d feat/auth
```

## PR 驗收標準

PR 描述必須包含：
1. 對應 Phase 的驗收標準勾選清單（逐條確認）
2. 測試覆蓋率數字
3. 設計稿對照說明（若涉及 UI）
