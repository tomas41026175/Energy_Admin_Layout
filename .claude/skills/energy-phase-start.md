# energy-phase-start

從 Energy Admin 任務拆分文件，載入指定 Phase 的任務到 TaskList。

## 觸發條件

用戶說「開始 Phase X」「載入 Phase X 任務」「phase-start X」

## 文件對應表

| Phase | 文件 | 節數 |
|-------|------|------|
| 0, 1, 2 | `plan/task-breakdown-detailed.md` | `## 0.x` / `## 1.x` / `## 2.x` |
| 3, 4, 5 | `plan/task-breakdown-phase3-5.md` | `## 3.x` / `## 4.x` / `## 5.x` |
| 6, 7, 8 | `plan/task-breakdown-phase6-8.md` | `## 6.x` / `## 7.x` / `## 8.x` |

## 執行流程

### Step 1: 確認 Phase

```
讀取 plan/implementation-roadmap.md
確認：
- Phase 目標是什麼
- 預計交付物清單
- 依賴的前置 Phase
```

### Step 2: 讀取任務清單

根據對應表，讀取該 Phase 的 task-breakdown 文件。
解析每個 `### 📋 任務：` 區塊，提取：
- 任務名稱
- 驗收標準
- 預估時間
- 所需技能

### Step 3: 建立 TaskList

對每個任務呼叫 TaskCreate：

```
subject: "[Phase X.Y] {任務名稱}"
description: """
驗收標準：
{逐條列出 - [ ] 項目}

預估時間: {時間}
參考文件: {文件連結}
"""
activeForm: "{進行式動詞} {任務名稱}"
```

設定依賴：Phase 內的子任務按 X.1 → X.2 → X.3 依序 blockedBy。

### Step 4: 顯示摘要

```
✅ Phase {X} 任務載入完成

載入任務（{N} 個）：
  #ID [Phase X.1] 任務名稱      (預估 30 分鐘)
  #ID [Phase X.2] 任務名稱      (預估 1 小時)
  ...

下一步：
  用 TaskList 查看任務狀態
  用 TaskUpdate 認領並開始任務
  完成後用 /energy-phase-verify {X} 驗收
```

## 注意事項

- 執行前先確認前置 Phase 是否完成（讀 TaskList 確認）
- Phase 0 沒有前置依賴，可直接開始
- Phase 8 需在 Phase 5 後立即執行（見 roadmap）
