# 📋 Claude Code 速查表 (Claude Code Cheat Sheet)

**日期**: 2026-03-24
**原文链接**: [storyfox.cz](https://storyfox.cz) | [HN](https://news.ycombinator.com/item?id=47495527)
**HN 热度**: ~330 points | ~180+ comments

---

## 🎯 核心内容/论点

这是一份 **Anthropic Claude Code 终端编程助手的完整命令参考速查表**，由社区维护并每周自动更新。Claude Code 是 Anthropic 推出的**终端原生 AI 编程代理**，直接在命令行中与 AI 协作编写代码。

### 🔧 Claude Code 核心概念

#### 启动方式
```bash
# 基本启动
claude

# 指定项目目录
claude /path/to/project

# 使用特定模型
claude --model claude-sonnet-4-20250514

# 非交互模式（管道输入）
echo "fix the bug in auth.ts" | claude -p
```

#### 核心交互模式

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **对话模式**（默认） | 自由对话，多轮交互 | 探索性编程、架构讨论 |
| **Agent 模式** (`/agent`) | 自主执行复杂任务 | 重构、功能实现、调试 |
| **编辑模式** | 精确文件编辑 | 小改动、bug 修复 |
| **搜索模式** | 代码库语义搜索 | 理解大型代码库 |

#### 关键命令速查

```
/help              显示帮助信息
/clear             清除当前会话
/compress          压缩上下文（节省 token）
/doctor            诊断环境问题
/init              初始化项目配置
/login             登录 Anthropic 账户
/logout            登出
/model [name]      切换模型
/status            显示当前状态
/cost              查看 token 用量和费用
/config            打开配置文件
/memory            管理持久化记忆
/tools             查看/切换可用工具
/mcp               管理 MCP 服务器
/permissions       管理权限设置
/focus <file>      聚焦到特定文件
/ls                列出当前目录
/cat <file>        查看文件内容
/find <pattern>    搜索代码
/grep <pattern>    正则搜索
/diff              查看变更
/undo              撤销上次操作
/bug report        报告问题
```

### 🧠 高级特性

1. **MCP (Model Context Protocol) 集成**
   - 连接外部工具和数据源
   - 支持 GitHub、Linear、PostgreSQL 等 20+ 服务
   - `.claude/mcp.json` 配置文件管理

2. **记忆系统 (Memory)**
   - 跨会话持久化上下文
   - 项目级和全局级记忆分离
   - 支持自然语言记忆指令

3. **权限控制**
   - 自动确认 vs 手动确认模式
   - 按操作类型分级（读/写/执行/网络）
   - 自定义允许/拒绝规则

4. **多模型支持**
   - Claude Opus / Sonnet / Haiku
   - 可配置 fallback 链
   - 成本优化的自动模型选择（小任务用 Haiku）

## 💡 关键洞察 / 为什么重要

### 🤖 **"AI 编程助手"品类的分水岭**

Claude Code 代表了一种不同于 Cursor / Copilot 的哲学：

| 维度 | Claude Code | Cursor | GitHub Copilot |
|------|-------------|--------|----------------|
| **交互界面** | 终端 TUI | IDE 插件 | IDE 内联 |
| **自主性** | 高（Agent 模式） | 中 | 低（补全为主） |
| **上下文窗口** | 200K+ tokens | 受限于 IDE | 单文件级别 |
| **工具使用** | MCP 扩展生态 | 内置有限 | VS Code API |
| **定价** | 按 token 计费 | 订阅制 | 订阅制 |
| **开源** | ❌ | ❌ | ❌ |

### 🎯 **为什么终端是 AI 编程的正确形态？**

HN 社区讨论中一个有趣的共识：
> **"真正的程序员住在终端里"**

理由：
- 终端是所有开发工作流的**最大公约数**
- 可以与任何编辑器/IDE 配合使用
- 天然支持脚本化和自动化
- 远程开发场景下更实用（SSH）
- 更容易审计 AI 的操作记录

### 📊 **Token 经济学实战**

使用 Claude Code 的成本意识很重要：

| 操作类型 | 大约 Token 消耗 | 成本估算（Opus）|
|----------|------------------|-------------------|
| 简单问答 | ~1K input | ~$0.01 |
| 单文件修改 | ~5K input + 2K output | ~$0.08 |
| 多文件重构 | ~50K input + 10K output | ~$0.80 |
| 全项目理解 | ~100K+ input | ~$1.60+ |

**省钱技巧：**
- 日常用 Sonnet/Haiku，复杂任务才上 Opus
- 善用 `/compress` 减少上下文膨胀
- 用 `--model` 参数按需切换
- 设置月度预算上限

## 💬 HN 社区精彩评论

> "Claude Code has become an essential part of my workflow. I start my day with it and end with it. It's like having a senior developer pair programming with you all the time." — 已成为日常工作流的核心部分

> "The TUI is actually a feature, not a limitation. It forces you to think about what you're asking for, rather than just accepting whatever autocomplete suggests." — TUI 是特性而非限制

> "I wish there was a way to share useful 'memories' across projects — like a community-maintained best practices memory pack." — 希望有跨项目的共享记忆功能

> "The cost adds up quickly if you don't pay attention. I set up a monthly budget alert after a $200 surprise bill." — 注意成本控制的教训

> ".claude folder is becoming the new .vimrc — everyone has their own heavily customized setup." — .claude 文件夹成为新的 dotfiles 文化

---

## 📎 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code)
- [MCP 协议规范](https://modelcontextprotocol.io)
- [awesome-claude-code](https://github.com) — 社区整理的技巧合集
- [Claude Code Pricing](https://www.anthropic.com/pricing) — 最新价格表
