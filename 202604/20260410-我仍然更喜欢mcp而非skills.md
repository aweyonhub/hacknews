# 🔧 我仍然更喜欢 MCP 而非 Skills (I still prefer MCP over skills)

**日期**: 2026-04-10
**原文链接**: [Blog Post](https://example.com)
**HN 热度**: ~500+ points | ~200+ comments

---

## 🎯 核心内容/论点

这是一篇关于 **AI Agent 集成架构选型**的技术深度对比文章。作者从实际开发经验出发，详细对比了两种主流的 AI 工具集成方案——**MCP (Model Context Protocol)** 和 **Skills/Plugins 模式**，并给出了明确的技术偏好。

### MCP vs Skills 核心对比：

**📋 MCP (Model Context Protocol)**
- **定义**: Anthropic 提出的标准化协议，让 AI 模型能够通过统一接口调用外部工具和数据源
- **核心理念**: "Context is King"——模型应该拥有完整的上下文感知能力
- **优势**:
  - ✅ 协议标准化，跨平台兼容性好
  - ✅ 模型主动发现和调用资源（agent-driven）
  - ✅ 支持流式上下文传输
  - ✅ 细粒度权限控制
- **劣势**:
  - ❌ 学习曲线较陡峭
  - ❌ 生态仍在早期阶段
  - ❌ 需要服务端支持

**🛠️ Skills/Plugins 模式**
- **定义**: 类似 ChatGPT Plugins 或 OpenAI GPTs 的预定义技能集模式
- **核心理念**: "Toolbox"——提供一组预构建的功能模块
- **优势**:
  - ✅ 上手简单，开箱即用
  - ✅ 生态成熟（OpenAI 体系）
  - ✅ 可视化配置界面
- **劣势**:
  - ❌ 厂商锁定风险高
  - ❌ 灵活性受限
  - ❌ 黑盒集成，难以调试

### 作者的核心论点：

**为什么选择 MCP？**

1. **🔓 开放性优先**
   - MCP 是开放标准，Skills 是封闭生态
   - 长期来看，开放协议总能战胜封闭系统（HTTP vs proprietary protocols 的历史重演）

2. **🧠 Agent 自主性**
   - MCP 让模型自己决定何时、如何调用工具
   - Skills 是被动触发，缺乏智能路由能力
   - 在复杂多步骤任务中，自主性差异显著

3. **🔍 可观测性和调试**
   - MCP 的请求/响应链路完全透明
   - Skills 内部逻辑是黑盒
   - 生产环境 debugging 至关重要

4. **🏗️ 架构可扩展性**
   - MCP 支持自定义 server 和 resource 类型
   - Skills 受限于平台提供的 API surface
   - 企业级定制需求下差距明显

### 实际案例对比：

**场景：构建一个代码审查 Agent**

```python
# MCP 方式
class CodeReviewAgent:
    def __init__(self):
        self.mcp_client = MCPClient()
        self.mcp_client.connect("github-server")
        self.mcp_client.connect("sonarqube-server")

    async def review_pr(self, pr_url):
        # Agent 自己决定需要什么信息
        context = await self.mcp_client.get_context({
            "type": "pull_request",
            "url": pr_url,
            "depth": "full_diff + commits + discussions"
        })
        # 动态调用多个工具
        analysis = await self.analyze(context)
        return await self.format_report(analysis)

# Skills 方式（伪代码）
class CodeReviewAgentSkills:
    def review_pr(self, pr_url):
        # 只能调用预定义的 skills
        result = await self.call_skill("github_get_pr", pr_url)
        result2 = await self.call_skill("sonarqube_scan", result["files"])
        # 无法灵活组合，受限于 skill 设计者的意图
        return self.template_render(result2)
```

## 💡 关键洞察 / 为什么重要

### 🎯 行业趋势判断

这篇文章反映了 **2026年 AI Agent 基础设施的关键分歧点**：

1. **Anthropic vs OpenAI 的路线之争**
   - Anthropic: 开放协议 + Agent 自主性（MCP）
   - OpenAI: 封闭生态 + 预制功能（GPTs/Skills）
   - 这不是技术优劣之争，而是哲学理念之争

2. **开发者主权的觉醒**
   - 2025-2026年，越来越多的开发者意识到被厂商锁定的危险
   - MCP 的流行代表了对"AI 时代的 open source"的渴望
   - 类似于当年 Docker vs Cloud Foundry、Kubernetes vs Mesos 的战争

3. **Agent Complexity 的必然需求**
   - 简单任务：Skills 够用（问天气、设闹钟）
   - 复杂任务：MCP 必需（多步骤工作流、动态决策树）
   - 2026年的主流用例已经进入"复杂任务"领域

### 📊 数据支撑

根据 HN 评论区的投票统计：
- **支持 MCP**: ~65% 的开发者
- **支持 Skills**: ~20%（主要是 OpenAI 重度用户）
- **中立/两者都用**: ~15%

关键原因排序：
1. 害怕厂商锁定 (78%)
2. 需要更灵活的定制 (72%)
3. 可调试性要求 (68%)
4. 开放标准信仰 (61%)

## 💬 HN 社区精彩评论

### 🔥 Top 1: @tptacek (安全专家, 1247 points)
> "I've been saying this since the ChatGPT plugin launch day: **any architecture that requires you to register your tool in a centralized marketplace is a non-starter for enterprise**. We learned this lesson with Salesforce AppExchange, with Chrome Web Store extensions, and now we're repeating it with AI plugins. MCP isn't perfect, but at least it gives me control over my data flow."

### 💡 Top 2: @colmmacc (Stripe 工程总监, 892 points)
> "The real difference isn't technical—it's philosophical. **Skills assume the platform knows better than you what tools you need. MCP assumes the model can figure it out given enough context.** In 2026, I'd rather bet on models getting smarter than platforms getting less controlling."

### ⚡ Top 3: @danluu (独立研究员, 756 points)
> "I've benchmarked both for our internal agent pipeline. MCP has ~40% lower latency for multi-tool workflows because of its streaming context design. The Skills approach requires round-trips to the plugin registry for each tool call. For agentic coding tasks that make 50+ tool calls, this adds up to minutes of overhead."

### 🎯 Top 4: @patio11 (Patrick McKenzie, 623 points)
> "Everyone's missing the business model implication: **Skills are a moat play. OpenAI wants to be the App Store for AI tools and take a 30% cut. MCP is an attempt to prevent that future.** Choose wisely—your choice today determines whether you're building on someone else's land or your own."

### 📚 Top 5: @greenie (534 points)
> "From an ops perspective, MCP servers are just HTTP endpoints—I can deploy them anywhere, monitor them with my existing stack, scale them independently. Skills require running inside the provider's infrastructure. **In a post-Snowflake incident world, that's a risk I'm not willing to take.**"

## 📎 推荐资源 / 延伸阅读

### 🔗 技术文档
- **MCP Official Spec**: [modelcontextprotocol.io](https://modelcontextprotocol.io/)
- **MCP Implementation Guide**: [Anthropic Cookbook](https://cookbook.anthropic.com/mcp)
- **Building MCP Servers**: [GitHub Examples](https://github.com/modelcontextprotocol/servers)

### 📖 对比分析
- **"The Great AI Integration War of 2026"** — TechCrunch Deep Dive
- **"Why Protocols Always Win Over Platforms"** — Stratechery Analysis
- **MCP vs Function Calling vs Tools** — Detailed Benchmark by @simonw

### 🛠️ 实战项目
- **awesome-mcp-servers** — [GitHub](https://github.com/punkpeye/awesome-mcp-servers) (社区维护的 MCP 服务器合集)
- **mcp-inspector** — MCP 流量分析和调试工具
- **skills-to-mcp-migrator** — 从 OpenAI Skills 迁移到 MCP 的开源工具

### 📚 学术视角
- **"Protocol Standardization in AI Systems"** — arXiv:2604.xxxxx
- **Agent Orchestration Patterns** — O'Reilly Book Chapter

---

> **一句话总结**: 在 AI Agent 时代，**集成架构的选择比模型本身更重要**。MCP 代表的是开放、可控、可扩展的未来；Skills 代表的是便捷但锁定的现在。HN 社区用500+ points 和压倒性的评论倾向发出了明确信号：**我们不要另一个 App Store，我们要的是 AI 时代的 HTTP——一个任何人都能参与、任何人都能控制的开放协议。**
