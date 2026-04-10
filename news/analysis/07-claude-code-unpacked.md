# 深度解读：Claude Code Unpacked — 把 Claude Code 扒个精光

> 原文：[ccunpacked.dev](https://ccunpacked.dev/)
> HN 热度：🔥 ⬆️ 1124 pts / 💬 403 评论
> 发布日期：2026-04-01
> 数据来源：Claude Code 意外泄露的 NPM bundle（2026 年 3 月）

---

## 核心论点

Claude Code 的源码意外泄露后，有人做了一个交互式可视化网站，把整个 Claude Code 的内部架构——从按键到响应的 11 步、40+ 工具、87 个命令、隐藏功能——全部拆解出来。**本质上是把 Anthropic 的底裤扒了个精光。**

---

## 网站结构：5 大交互章节

### Chapter 1: Agent Loop（智能体循环）

从用户按键到渲染响应的 11 步完整流程：

```
用户输入消息 → Ink TextInput 组件（非交互模式读 stdin）
    ↓
initState() — token 预算、上下文窗口、钩子初始化
    ↓
compressIfNeeded() — 4 层压缩栈
    ↓
callModel() — 流式调用，带回退和错误缓冲
    ↓
executeTools() — 并行批执行，AbortController 中断
    ↓
decideContinue() — 10 种终止理由 vs 7 种继续理由
    ↓
yield* recurse — 状态不可变，每次 continue 重建
```

**关键设计模式："先吞后吐"（Withhold-then-Surface）**
- 可恢复错误（413、token 超限、限流）被缓冲
- 只有所有重试路径耗尽后才报错
- 目的：避免客户端断连，保持用户体验

---

### Chapter 2: Architecture Explorer（架构探索器）

项目源码树的可视化浏览：

```
src/
├── query.ts           ← 1,730 行异步生成器 —— THE loop
├── tools/             ← 40+ MCP 工具
├── commands/          ← 87 个斜杠命令
├── components/        ← React-Ink 终端 UI
├── bridge/            ← stdin/stdout NDJSON SDK 桥接
├── services/          ← 权限、遥测、定时任务
└── skills/            ← 高级技能封装（review, commit 等）
```

核心就是一个 1,730 行的 `query.ts`。整个 Claude Code 的复杂性都隐藏在这一个文件里。

---

### Chapter 3: 4 层上下文压缩系统

这是整个系统**最有技术含量**的设计：

| 层级 | 名称 | 策略 | 触发条件 |
|------|------|------|---------|
| Layer-0 | 工具结果预算 | 限制每条消息的大小上限 | 始终生效 |
| Layer-1 | Snip-compact | 删除最老的消息，注入边界标记 | 接近上限时 |
| Layer-2 | Micro-compact | 删除缓存的 tool_use_ids | Layer-1 后仍超限 |
| Layer-3 | Context-collapse | 用摘要替换一段历史 | Layer-2 后仍超限 |
| Layer-4 | Auto-compact | fork 一个 Haiku 小模型来总结整个历史 | 接近硬性停止线 |

**阈值数学（以 Opus 200K 窗口为例）：**
```
有效窗口    = 200K - min(max_output, 20K) = 180K
自动压缩    = 180K - 13K = 167K  ← 触发 Layer-4
硬性停止    = 180K - 3K  = 177K  ← 强制停止
```

**安全阀**：连续 3 次压缩失败 → 停止重试（circuit breaker）。

**设计哲学**：轻压缩优先，重压缩兜底——尽可能保留细粒度上下文。

---

### Chapter 4: Tool System（工具系统）

40+ 个 MCP 工具的完整目录：

| 类别 | 数量 | 代表工具 |
|------|------|---------|
| 文件操作 | 6 | FileRead, FileWrite, FileEdit, FileCreate, FileDelete, FilePatch |
| 搜索 | 3 | Glob, Grep, RG |
| 执行 | 3 | Bash, NotebookEdit, REPL |
| Git | 4 | GitDiff, GitCommit, GitPush, EnterWorktree/ExitWorktree |
| Agent & 任务 | 11 | AgentTool, TaskCreate, TaskUpdate, TaskGet, TaskList, TaskCancel |
| 规划 | 5 | TodoWrite, EnterPlanMode, ExitPlanMode, ListTodos |
| MCP 客户端 | 4 | MCPTool, MCPInstall, MCPList, MCPRemove |
| 系统 | 11 | Config, AskUser, Sleep, ScheduleCron, RemoteTrigger, Clipboard |
| 实验性 | 8 | LSPTool, ImageEdit, WebFetch, WebSearch |

**并行规则**：独立的 tool_use 块会被自动批处理。提示词中用"同时做 A 和 B"即可触发。

---

### Chapter 5: Command Catalog（命令目录）

87 个斜杠命令完整列表：

| 类别 | 数量 | 代表命令 |
|------|------|---------|
| 设置与配置 | 12 | /config, /theme, /vim, /permissions, /mcp |
| 日常工作流 | 24 | /commit, /commit-push-pr, /review, /resume, /session, /memory |
| 代码审查 & Git | 13 | /diff, /log, /blame, /pr, /push, /stash |
| 调试 & 诊断 | 23 | /test, /trace, /debug, /profile, /lint, /format |
| 高级 & 实验性 | 23 | /voice, /desktop, /skills, /experimental, /hidden |

---

## 🕵️ 隐藏/未发布功能（最劲爆部分）

### 环境变量控制的隐藏开关

| 环境变量 | 名称 | 功能 |
|---------|------|------|
| `TENGU_BRAMBLE_LINTEL` | 记忆提取稀释 | 控制记忆提取的激进程度 |
| `KAIROS_MODE` | 自主代理循环 | 无需人类逐轮审批的自主模式（WIP） |
| `UNDERCOVER_MODE` | 卧底模式 | 对 Anthropic 员工在公共仓库上自动降级为只读 |
| `DREAM_COMPACT` | 梦境压缩 | 24 小时自动梦境总结 |

### 功能开关控制的未发布功能

| # | 功能 | 状态 | 说明 |
|---|------|------|------|
| 1 | **KAIROS 自主代理** | WIP | 无需人类审批，全自动运行 |
| 2 | **语音模式** | 接近完成 | 实时音频流，WebRTC 桥已存在 |
| 3 | **17 个额外 MCP 工具** | 已实现 | swagger-codegen, docker-build, kube-deploy 等 |
| 4 | **远程终止开关** | 已实现 | 6 个不同的紧急开关，每小时轮询 |
| 5 | **卧底模式** | 已实现 | 当仓库属于 Anthropic 时自动只读 |
| 6 | **梦境压缩** | 已实现 | 夜间 cron 将整个会话总结到 CLAUDE.md |
| 7 | **图转代码** | 80% 完成 | 剪贴板图片 → 内联 SVG → React 组件 |
| 8 | **记忆提取 Agent** | 已实现 | 后台任务，每 N 个 token + M 次工具调用后更新 CLAUDE.md |

---

## SDK 集成钩子

### NDJSON over stdin/stdout
三种粒度级别：
- **级别 0**：仅最终结果
- **级别 1**：进度更新
- **级别 2**：实时 token 流

### 权限三元组
```
allowed_tools[]     → 自动批准
disallowed_tools[]  → 自动拒绝（覆盖允许）
permission_mode     → ask | bypass | strict
```

### 子 Agent 上下文隔离
10K token 窗口，返回 1-2K token 摘要。

---

## 最小 Agent 循环（提炼版）

```javascript
async function* agentLoop(params) {
  let state = initState(params);
  while (true) {
    const ctx  = compress(state.messages);
    const res  = await callModel(ctx);
    if (res.error) {
      if (canRecover(res.error, state)) { state = recover(state); continue; }
      return { reason: 'error' };
    }
    if (!res.toolCalls.length) return { reason: 'completed' };
    const results = await executeTools(res.toolCalls);
    state = { ...state, messages: [...ctx, res.message, ...results] };
  }
}
```

这就是整个 Claude Code 的骨架。

---

## 值得贴在墙上的设计原则

1. **Generator = 背压 + 返回值 + yield* 组合** — 流式架构的最佳实践
2. **每次 continue 重建整个 state，永不就地修改** — 不可变性的极致
3. **先吞后吐错误** — 用户体验优先于透明度
4. **轻压缩优先，重压缩兜底** — 保留细粒度上下文
5. **每次重试都有 circuit breaker** — 3 次失败就停
6. **并行工具调用是免费的** — 只要你明确要求

---

## 与 Claude Code 退化 Issue 的关联

结合 Issue #42796 的数据来看：

| ccunpacked.dev 发现 | Issue #42796 验证 |
|---------------------|-------------------|
| Layer-4 Auto-compact 用 Haiku 总结历史 | 思考深度从 2,200 字符降至 600 字符 |
| 4 层压缩可能丢弃推理链条细节 | Read:Edit 比例从 6.6 暴降到 2.0 |
| 决定继续的 7 种理由 | 173 次推诿/偷懒行为 |
| KAIROS 自主代理（WIP） | 用户打断率增加 12 倍 |

ccunpacked.dev 揭示了"应该怎么设计"，Issue #42796 证明了"实际效果已经偏离设计"。两者结合，构成了对 Claude Code 最完整的评估。

---

## 启示

1. **Claude Code 的架构并不神秘** — 一个 1,730 行的生成器 + 40 个工具 + 4 层压缩
2. **Anthropic 正在向 AI 操作系统演进** — 自主代理、语音模式、图转代码、记忆提取……
3. **卧底模式暴露了 Anthropic 的自省** — 他们预料到代码会被分析，提前做了准备
4. **隐藏功能的数量和质量惊人** — Claude Code 还远未到最终形态
5. **理解内部机制有助于更好的使用** — 知道压缩逻辑后，能更聪明地写 CLAUDE.md

这是 2026 年最精彩的逆向工程作品之一——一个网站，把一个价值数十亿美元产品的内部架构展现在所有人面前。
