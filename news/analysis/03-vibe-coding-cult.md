# 深度解读：The Cult of Vibe Coding Is Insane

> 原文：[bramcohen.com](https://bramcohen.com/p/the-cult-of-vibe-coding-is-insane)
> 作者：Bram Cohen（BitTorrent 发明者）
> HN 热度：⬆️ 606 pts / 💬 504 评论
> 发布日期：2026-04-07

---

## 核心论点

Bram Cohen 猛批 Claude 团队的"纯 vibe coding"文化——**完全不看代码就让它自己写，出了大量的重复和冗余**。他认为 vibe coding 已从一种工作方式退化成了宗教狂热。

---

## 什么是 Vibe Coding？

Vibe coding 的核心理念：**你只描述想要什么，绝不碰代码底层**。你用自然语言和 AI "聊"，它负责生成、修改、维护所有代码。

Bram 认为这种做法本身不坏，但 Claude 团队把它推到了荒谬的极端——**连看一眼代码都视为"作弊"**。

---

## 导火索：Claude 源码泄露

Claude 最近发生了源码泄露（之前 ccunpacked.dev 的可视化分析也是基于此），人们看了之后发现：

- **大量重复代码**：agent 和 tool 的概念严重重叠
- **冗余的规则和技能定义**：相同逻辑被不同格式重复写了多遍
- **结构混乱**：项目内部缺乏合理的抽象层级

更讽刺的是：**这些问题任何人花几分钟看看代码就能发现**——因为 Claude 的代码本身就是用自然语言写的，不是什么高深的技术实现。但 Claude 团队就是没人去看。

---

## Bram 的正确方法论

Bram 分享了他自己使用 AI 编程的工作方式，值得每个开发者参考：

### 1. 先审计，再动工
```
"Let's audit this codebase for unreachable code"
"这个函数让我眼睛流血"
```
先和 AI 讨论"这段代码哪里有问题"，而不是直接让它"修好一切"。

### 2. AI 擅长清理，但不擅长发现
> "AI 不会主动说'我有一堆意大利面代码，我应该清理'。但如果你告诉它这里有意大利面代码并给一些指导，它能很好地清理。"

### 3. Ask 模式 > 直接生成
- 先讨论：walks through examples, share your reasoning
- 纠正 AI 的谄媚：correct the wrong things it says when trying to sycophantically agree with you
- 充分讨论后再执行：tell it to make a plan and hit build

### 4. 讨论是"预训练"
> "当你最终让它动手时，它飞速前进——因为你已经澄清了奇怪的边界情况和可能出现的所有问题。这不是 one-shotting。之前有大量的、与你的来回讨论。"

### 5. 质量是决策
> "People have bad quality software because they decide to have bad quality software."
> （人们写出烂软件，是因为他们决定要烂。）

---

## 具体修复示例

当发现 Claude 代码中 agent 和 tool 大量重叠时，Bram 建议的正确做法是：

> "有很多东西既是 agent 又是 tool。让我们列出所有这样的东西，看一些例子，我告诉你哪些应该是 agent 哪些应该是 tool。我们讨论一下，搞清楚通用准则。然后审计整个集合，确定每个属于哪一类，把放错类型的移植过去，对于同时是两者的，通读两个版本，整合成一个文档。"

而不是：什么都不看，让 AI 自己去"感受"应该怎么改。

---

## 反面论点（来自 HN 评论）

504 条评论中也有一些反对声音：

1. **Vibe coding 对原型有效**：对于 MVP 和探索性项目，快速迭代比代码质量更重要
2. **不是所有人都懂代码**：非技术创始人用 vibe coding 是合理的选择
3. **AI 在进步**：未来的 AI 可能真的不需要人类审查
4. **Bram 本身是顶级程序员**：他的方法论对普通开发者门槛太高

---

## 分析：Vibe Coding 的真正陷阱

Bram 的核心观点是对的：**"纯" vibe coding 是神话**。

即使你声称不碰代码，你仍然在：
- 用人类语言描述需求（LLM 的训练数据来自人类）
- 构建 plan files（本质是 todo lists）
- 定义 skills 和 rules
- 撰写 CLAUDE.md

这些都是**人类贡献**，只是形式不同。问题不在于用不用 AI，而在于**你愿不愿意审查 AI 的输出质量**。

Claude 团队的事件特别讽刺——一个做代码工具的公司，自己的代码都没人 review。这说明 vibe coding 的陷阱不是"用了 AI"，而是**放弃了对产出的责任**。

---

## 对开发者的启示

| 场景 | 推荐方式 |
|------|---------|
| 原型/MVP | Vibe coding ✅ 快速迭代优先 |
| 生产代码 | Ask → Discuss → Plan → Build ✅ Bram 模式 |
| 重构/清理 | 先审计，再让 AI 执行 ✅ AI 擅长清理但需要你指出问题 |
| 日常小修改 | Vibe coding ✅ 信任 AI 的能力 |
| 大规模架构变更 | 必须人类主导设计 ✅ AI 辅助实现 |

**记住：AI 是超级实习生，不是超级工程师。你需要指导它、审查它、纠正它。**
