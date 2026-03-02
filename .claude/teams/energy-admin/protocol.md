# Energy Admin Team Protocol

## 團隊成員

| Agent | 職責 | 定義檔 |
|-------|------|--------|
| frontend-dev | React 開發、API 整合、UI 元件 | `.claude/agents/frontend-dev.md` |
| test-writer | 測試撰寫、覆蓋率維護 | `.claude/agents/test-writer.md` |
| architect | 架構審查、技術決策 | `.claude/agents/architect.md` |

## 工作流程

```
需求分析 → frontend-dev 實作 → test-writer 補測試 → architect 審查 → merge
```

## 任務分配原則

1. **frontend-dev** 先完成功能實作（Phase 0-5）
2. **test-writer** 與 frontend-dev 並行或緊跟（Phase 4-7）
3. **architect** 在 Phase 完成時做架構審查
4. 有競態條件 / Token 策略問題時，architect 優先介入

## 溝通規範

- 每個 Phase 完成後發摘要（含交付物清單）
- 遇到阻礙立即通報，不要卡超過 30 分鐘
- 架構疑問找 architect，測試疑問找 test-writer

## 實作路線圖

詳見 `plan/implementation-roadmap.md`。

當前狀態：**Phase 0（專案設定）— 進行中**

## 模型使用標準
本次僅限使用 sonnet / haiku 模型進行

## 驗收標準

每個 Phase 的驗收標準見 `plan/implementation-roadmap.md`。
關鍵指標：
- 測試覆蓋率 ≥ 70%
- TypeScript strict 無錯誤
- ESLint 無錯誤
- Lighthouse Performance ≥ 90
