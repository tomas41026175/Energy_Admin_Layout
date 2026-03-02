# energy-phase-verify

對照 Energy Admin 文件的驗收標準，驗證指定 Phase 是否達成。

## 觸發條件

用戶說「驗收 Phase X」「驗證 Phase X」「phase-verify X」

## 執行流程

### Step 1: 讀取驗收標準

從 `plan/implementation-roadmap.md` 讀取 `### Phase X` 的「驗收標準」和「產出確認」區段。

### Step 2: 逐項驗證

對每個驗收項目，使用對應工具確認：

```
對每個 - [ ] 項目：

  若為「檔案存在」→ Glob 確認路徑
  若為「命令可執行」→ Bash 執行命令
  若為「TypeScript 無錯誤」→ Bash: tsc --noEmit
  若為「測試通過」→ Bash: npm test
  若為「覆蓋率達標」→ Bash: npm run test:coverage
  若為「ESLint 無錯誤」→ Bash: npm run lint
  若為「Lighthouse 分數」→ 標記為「需手動驗證」
  若為「功能行為」→ Read 相關源碼 + 邏輯審查
```

### Step 3: 產出驗收報告

```markdown
# Phase {X} 驗收報告

**時間**: {YYYY-MM-DD HH:mm}
**整體狀態**: ✅ 通過 / ❌ 未通過

## 驗收標準

| 項目 | 狀態 | 說明 |
|------|------|------|
| TypeScript 無錯誤 | ✅ | tsc --noEmit 通過 |
| 測試覆蓋率 ≥ 70% | ✅ | 目前: 78% |
| ESLint 無錯誤 | ❌ | 3 個 warnings 待修正 |
| ...  | ... | ... |

## 未通過項目（需修正）

1. ESLint warnings: ...
   修正方式: ...

## 下一步

- [ ] 修正未通過項目
- [ ] 重新執行驗收
- [ ] 通過後切換到下一個 Phase
```

## PR Review 標準

Phase verify 通過才能建立 PR。
PR 描述必須包含：
1. 對照驗收標準的勾選清單
2. 測試覆蓋率數字
3. 設計稿對照（截圖或說明）

## 注意事項

- 驗收「必須完全符合」，不接受「大致符合」
- 功能行為類項目，無把握時主動提出疑問
- 設計稿相關驗收，使用 Pencil MCP 工具對照
