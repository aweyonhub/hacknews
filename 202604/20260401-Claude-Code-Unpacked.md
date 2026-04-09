# 🔍 Claude Code 解包：可视化指南

**日期**: 2026-04-01
**项目地址**: [ccunpacked.dev](https://ccunpacked.dev)
**HN 讨论**: https://news.ycombinator.com/item?id=47595935
**规模**: **1,900+ 文件 | 519,000+ 行代码 | 53+ 工具 | 95+ 命令**

---

## 📦 这是什么项目？

**Claude Code Unpacked** 是对 Anthropic 的 **Claude Code**（AI 编程 Agent CLI 工具）进行**完整的源码级逆向分析和可视化**的项目。它将 50 万行代码拆解为可交互式探索的知识图谱。

## 五大核心模块

### ① Agent Loop（代理循环）— 从按键到响应的完整流程

```
用户输入消息
    ↓
[输入预处理] → 清洗、截断、注入系统提示
    ↓
[上下文组装] → 收集相关文件、历史对话、工具定义
    ↓
[LLM 推理] → 发送至 Claude API → 流式返回
    ↓
[响应解析] → 区分：文本输出 / 工具调用 / 思考过程
    ↓
[工具执行] → 如果需要调用工具（读文件、运行命令等）
    ↓         ↓
    循环回 [上下文组装] ← 直到任务完成
    ↓
[输出渲染] → 终端 UI 渲染结果
```

### ② Architecture Explorer（架构浏览器） — 可点击的源码树

```
src/
├── components/  (389 files)  ← UI 层
├── commands/    (189 files)  ← 斜杠命令 (/help, /debug...)
├── tools/       (184 files)  ← 内置工具集
├── services/    (130 files)  ← 核心服务
├── hooks/       (104 files)  ← 生命周期钩子
├── ink/         (96 files)   ← 终端渲染引擎
├── bridge/      (31 files)   ← API 桥接层
├── constants/   (21 files)   ← 常量定义
├── skills/      (20 files)   ← 技能插件
└── cli/                      ← 入口文件
```

用不同颜色标记各模块，点击即可查看源码。

### ③ Tool System（工具系统） — 53个内置工具全景图

| 类别 | 数量 | 示例 |
|------|------|------|
| **文件操作** | 6 | Read, Write, Edit, Glob, Search, LSP |
| **代码执行** | 3 | Bash, Python, Node |
| **搜索与获取** | 4 | WebFetch, WebSearch, GitHub API, URL Read |
| **Agent 与任务** | 11 | Task, Subagent, Parallel, Sequential |
| **规划** | 5 | Plan, TodoList, Milestone, Reflect |
| **MCP 协议** | 4 | MCP Tool, MCP Resource, MCP Prompt |
| **系统** | 11 | Memory, Context, Config, Auth |
| **实验性** | 8 | Vision, Voice, Sandbox... |

### ④ Command Catalog（命令目录） — 95+ 斜杠命令

按功能分为 7 大类：

- **设置与配置** (12): `/config`, `/model`, `/permissions`...
- **日常工作流** (24): `/commit`, `/pr-review`, `/test`...
- **代码审查与 Git** (13): `/diff`, `/blame`, `/log`...
- **调试与诊断** (23): `/debug`, `/trace`, `/profile`...
- **高级与实验性** (23): `/agent-mode`, `/sandbox`, `/multi-model`...

### ⑤ Hidden Features（隐藏功能） — 未发布但存在于代码中的功能

这是最引人注目的部分！通过源码分析发现的**未上线功能**：

| 隐藏功能 | 状态 | 描述 |
|----------|------|------|
| **多模型路由** | Feature Flag | 同一会话中动态切换 Claude/GPT/Gemini |
| **视觉模式增强** | Env Gated | 截图理解 + GUI 操作 |
| **语音交互** | Commented Out | 语音输入/输出的完整管道 |
| **沙箱执行** | Partial | 容器化代码执行环境 |
| **团队协作模式** | Stub Code | 多用户共享 Agent 会话 |
| **持久化记忆** | In Dev | 跨会话长期记忆存储 |

## HN 最精彩的评论

> **"一个 50 万行代码的 Agent CLI 证明了一件事：让概率性的 LLM 表现出确定性行为是一场巨大的状态管理噩梦。"**
>
> *"目前它们在简单网站/平台上表现出色，但在面对大型企业代码库时会失效。如果没有刚性的外部状态机来控制工作流，你就必须强行确保可靠性。那个庞大的代码库中可能有 **90% 是防御性编程**——令人抓狂的正则匹配、上下文清洗、工具重试循环、状态回滚，仅仅是为了防止 Agent 走偏或静默地破坏东西。"*

## 这个项目的意义

1. **透明度革命** — 首次将闭源 AI 工具的内部运作完全可视化
2. **安全审计基础** — 让社区能够审查 AI Agent 的行为逻辑
3. **竞品参考** — 为 Cursor、Windsurf、Aider 等竞品提供架构对标
4. **开源克隆的种子** — 有人已经基于此用 Python 重写了 DMCA-proof 版本
