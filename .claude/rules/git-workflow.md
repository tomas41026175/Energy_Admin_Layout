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

## 規則

- 不直接 commit 到 main
- 小步提交，每次一個邏輯變更
- PR 通過 review 才 merge
- 永遠不要 force push 到 main
