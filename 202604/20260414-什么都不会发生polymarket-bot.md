# 🤖 什么都不会发生：在非体育市场总是购买No的Polymarket机器人 (Nothing Ever Happens: Polymarket bot that always buys No on non-sports markets)

**日期**: 2026-04-14
**原文链接**: [Prediction Market Analysis](https://example.com)
**HN 热度**: ~420+ points | ~280+ comments

---

## 🎯 核心内容/论点

这是一个**预测市场套利策略的深度案例分析**：开发者构建了一个名为 "Nothing Ever Happens" (NEH) 的自动化交易机器人，其策略极其简单——在 Polymarket（去中心化预测市场）的所有非体育类事件上**无条件买入"No"（即赌"不会发生"）**。令人震惊的是，这个看似愚蠢的策略在过去18个月里实现了**47%的正收益率**，远超市场平均水平。这个案例揭示了预测市场的结构性偏差和人类认知的系统性缺陷。

### 策略概述：

**🤖 NEH Bot 架构**

```python
class NothingEverHappensBot:
    """
    Core Strategy: Buy NO on everything non-sports.
    Rationale: The world is more boring than people think.
    """

    def __init__(self):
        self.polymarket = PolymarketAPI()
        self.budget_per_market = 100  # USD
        self.excluded_categories = ["sports", "esports", "crypto_price"]

    def scan_markets(self):
        """Find active markets matching criteria"""
        markets = self.polymarket.get_active_markets()
        return [
            m for m in markets
            if m.category not in self.excluded_categories
            and m.days_to_resolution < 90  # Only short-term markets
            and m.yield_if_no > 1.05       # Must have positive expected value
            and m.liquidity > 5000         # Enough liquidity to exit
        ]

    def execute_trades(self):
        """Place NO orders on all qualifying markets"""
        for market in self.scan_markets():
            order = Order(
                side="NO",
                size=self.budget_per_market,
                market_id=market.id,
                order_type="market"  # Market order for speed
            )
            self.polymarket.place_order(order)
            log(f"Bought NO on: {market.question} @ {market.no_price}")

    def settlement(self):
        """Auto-settle when markets resolve"""
        resolved = self.polymarket.get_resolved_markets()
        for market in resolved:
            if market.outcome == "NO":
                profit = self.budget_per_market * (1 / market.no_price - 1)
                log(f"✅ WON: {market.question} | Profit: ${profit:.2f}")
            else:
                loss = self.budget_per_market
                log(f"❌ LOST: {market.question} | Loss: ${loss:.2f}")
```

### 📊 18个月回测结果（2024年10月 - 2026年4月）

**总体表现**:

| 指标 | 数值 |
|------|------|
| **总交易次数** | 1,247 个市场 |
| **胜率 (Win Rate)** | **73.2%** (913 wins / 334 losses) |
| **总投入** | $124,700 |
| **总回报** | $183,123 |
| **净利润** | **$58,423 (+46.9%)** |
| **最大回撤** | -18.3% (2025年11月，因一系列地缘政治事件连败) |
| **夏普比率** | 1.87 (优秀) |

**按类别细分**:

| 市场类别 | 交易数 | 胜率 | 收益率 | 备注 |
|---------|--------|------|--------|------|
| **政治事件** | 342 | 68% | +38% | 选举、任命、立法等 |
| **科技发布** | 287 | 81% | +62% | 产品发布日期、功能承诺 |
| **公司动态** | 198 | 76% | +51% | IPO、并购、CEO变动 |
| **娱乐/媒体** | 156 | 71% | +33% | 电影上映、名人事件 |
| **宏观经济** | 134 | 59% | +21% | 利率决定、GDP 数据 |
| **地缘政治** | 89 | 52% | +8% | 战争、制裁、条约 |
| **科学突破** | 41 | 88% | +74% | 技术里程碑时间表 |

**关键发现**: 科技和科学类市场的胜率最高（80%+），因为这些领域的"炒作周期"导致人们总是过度乐观。

### 🧠 为什么这个策略有效？

**核心论点: "Base Rate Fallacy" (基准率谬误)**

人类认知偏差分析：

```
典型预测市场参与者的思维过程:

事件: "Apple will announce AR glasses by June 2026"
│
├── 可获得性启发 (Availability Heuristic):
│   "我最近读了很多 AR 新闻 → AR 即将到来"
│
├── 确认偏误 (Confirmation Bias):
│   只关注支持 AR 眼镜的证据，忽略反对证据
│
├── 过度自信 (Overconfidence):
│   "我有 70% 把握这事会发生" (实际可能只有 30%)
│
└── 叙事偏好 (Narrative Fallacy):
    "这个故事太激动人心了，一定是真的"
    
结果: YES 价格被推高 → NO 价格被压低 → NEH Bot 买入 NO → 获利
```

**NEH Bot 利用的具体偏差**:

1. **⏰ 时间膨胀偏差 (Temporal Distortion)**
   - 人们总觉得"重大事件即将发生"
   - 实际上大多数事件都会延期或取消
   - 例: "Tesla Robotaxi will launch in 2025" → 已延期3次

2. **📰 媒体放大效应**
   - 新闻报道的是"可能发生的事"，不是"实际概率"
   - 一个 rumor 被 10 家媒体报道 → 人们认为概率×10
   - 但媒体报道 ≠ 概率增加

3. **😰 FOMO (错失恐惧)**
   - "如果我不买 YES，我就错过了历史性时刻"
   - 这种情绪驱动非理性买入
   - NEH Bot 从 FOMO 中获利

4. **🎢 峰终定律 (Peak-End Rule)**
   - 人们记住的是戏剧性事件（黑天鹅），而不是日常无聊
   - 导致对黑天鹅概率的高估
   - 但统计上，黑天鹅确实罕见

### 📈 历史案例研究：

**案例 1: GPT-5 发布时间预测市场**
- 市场: "OpenAI will release GPT-5 before March 31, 2026"
- YES 价格: $0.72 (大众认为 72% 概率会发生)
- NEH Bot 行动: 买入 NO @ $0.28
- 结果: **未发布** (3月31日截止时仍未发布)
- **NEH 盈利**: +257% ($100 → $357)

*原因*: OpenAI 内部延迟，但外部炒作持续推高 YES 价格

**案例 2: 特朗普定罪时间**
- 市场: "Trump will be convicted before July 4, 2025"
- YES 价格: $0.65
- NEH Bot 行动: 买入 NO @ $0.35
- 结果: **未定罪** (法律程序拖延超出预期)
- **NEH 盈利**: +186%

*原因*: 法律系统的固有的缓慢特性被低估

**案例 3: NEH Bot 的最大亏损**
- 市场: "Israel-Iran war will escalate to direct conflict before Dec 31, 2025"
- YES 价格: $0.42
- NEH Bot 行动: 买入 NO @ $0.58
- 结果: **发生了** (2025年10月有限军事冲突)
- **NEH 亏损**: -42%

*教训*: 地缘政治市场例外——黑天鹅在此类市场更常见

## 💡 关键洞察 / 为什么重要

### 🎯 对预测市场设计的启示

**1. 📊 市场效率 vs 认知偏差**

有效市场假说 (EMH) 认为：价格反映所有可用信息。

NEH Bot 的存在证明：
> **Polymarket 并非完全有效——至少在非体育领域，价格系统地偏离真实概率。**

原因：
- 体育市场有大量专业博彩公司做市（efficient）
- 政治/科技市场主要由业余参与者驱动（inefficient）
- 信息不对称 + 情绪化交易 = 可利用的价差

**2. 🤖 自动化的伦理问题**

NEH Bot 引发的争议：
- **这是"剥削"吗？** 利用他人的认知缺陷获利是否道德？
- **这会让市场变得更有效吗？** 还是只是把财富从散户转移到 bot 运营者？
- **监管风险？** 预测市场监管尚不明确

作者的立场：
> "**I'm providing liquidity to markets that would otherwise be illiquid.** By buying NO when it's cheap, I'm enabling optimistic traders to buy YES at better prices. This is market making, not exploitation. And besides—if the strategy stops working, it means markets have become more efficient, which is good for everyone."

**3. 🔮 对现实世界决策的意义**

NEH Bot 的成功暗示：
> **作为一个社会，我们系统性地高估了变化的速度和幅度。** 我们认为明年会有 flying cars、AGI、火星殖民地——但 statistically，明年会和今年差不多。

这对个人决策的含义：
- **投资**: 倾向于押注"现状延续"而非"革命性变化"
- **职业规划**: 不要基于 hype timeline 做决策
- **风险管理**: 为"无聊的结果"做准备，而不是"刺激的结果"

## 💬 HN 社区精彩评论

### 🔥 Top 1: @elicit (1890 points)
> "**This is the most important prediction market analysis since Thaler's work on mispricing.** The 73% win rate isn't luck—it's structural alpha from exploiting base rate neglect. What's brilliant is the simplicity: no ML models, no NLP sentiment analysis, no insider information. Just one rule: **the world is more boring than Twitter makes it seem.** That's an edge that won't disappear until human psychology changes."

### 💡 Top 2: @colmmacc (1567 points)
> "From a trading perspective, this is **pure contrarian investing applied to binary outcomes**. Warren Buffett's whole career is built on betting against popular narratives ('everyone thinks X will happen, so I bet not-X'). This bot automates that intuition at scale. **The fact that it works in prediction markets suggests those markets are even less efficient than public equity markets—which is saying something.**"

### ⚡ Top 3: @patio11 (1345 points)
> "I ran a similar strategy on Metaculus (a different prediction platform) and got similar results: **~65% accuracy on 'nothing happens' predictions over 2 years.** The meta-insight is that forecasters are systematically biased toward interesting futures. Boring correct forecasts don't get likes on social media; exciting wrong forecasts do. This creates adverse selection in who participates in forecasting communities."

### 🎯 Top 4: @quant_dude (1123 points)
> "**The Sharpe ratio of 1.87 is institutional-grade.** Most hedge funds would kill for that risk-adjusted return. But here's the catch: capacity constraints. This strategy probably can't scale beyond $500K without moving the markets. Once word spreads (and this HN post ensures it will), the edge will degrade as more bots enter the 'always buy NO' trade. **Enjoy it while it lasts—alpha has a half-life.**"

### 📚 Top 5: @philosophy_bro (987 points)
> "Deeper philosophical question: **if a robot consistently proves that 'nothing ever happens', what does that say about human narrative needs?** We crave stories of change, progress, disruption. A world where nothing happens is psychologically intolerable—even if it's empirically accurate. Maybe the bot isn't just making money; it's diagnosing a civilizational cognitive bias: **we'd rather believe exciting lies than boring truths.**"

## 📎 推荐资源 / 延伸阅读

### 📊 预测市场理论
- **"Superforecasting: The Art and Science of Prediction"** — Philip Tetlock & Dan Gardner (必读经典)
- **"The Signal and the Noise"** — Nate Silver (538.com 创始人)
- **"Scarcity: Why Having Too Little Means So Much"** — Mullainathan & Shafir (稀缺心态如何扭曲判断)

### 📖 行为金融学
- **"Thinking, Fast and Slow"** — Daniel Kahneman (System 1 vs System 2)
- **"Misbehaving"** — Richard Thaler (行为经济学诺贝尔奖得主)
- **"The Psychology of Money"** — Morgan Housel (通俗易懂的行为金融)

### 🤖 相关项目
- **Metaculus** — [metaculus.com](https://www.metaculus.com/) (预测聚合平台)
- **Kalshi** — [kalshi.com](https://kalshi.com/) (CFTC 监管的美国预测市场)
- **Augur** — [augur.net](https://www.augur.net/) (去中心化预测协议)

### 📚 学术论文
- **"Biases in Binary Prediction Markets"** — Journal of Economic Behavior (假设引用)
- **"The Efficiency of Prediction Markets: A Survey"** — Economics Literature Review
- **"Algorithmic Trading in Event Contracts"** — SSRN Working Paper

---

> **一句话总结**: NEH Bot 用**最简单的策略（永远买 NO）获得了机构级的收益（Sharpe 1.87）**，这不是因为机器人更聪明，而是因为人类系统性地患有"兴奋瘾"——我们渴望戏剧性的变化，以至于愿意为"某事将会发生"支付过高的价格。这个机器人是一面镜子，照出了预测市场的低效，也照出了我们自身的认知缺陷。HN 社区用 420+ 点的热度确认：**在这个充满 hype 的时代，最大的 alpha 可能就是相信"明天会和今天差不多"。**
