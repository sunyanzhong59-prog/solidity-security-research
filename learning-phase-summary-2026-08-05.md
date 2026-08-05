# Solidity 安全审计 — 学习阶段总结报告

**报告期间：2026-07-14 ~ 2026-08-05（23 天）**
**作者：MirSun + 助理（xing）**
**状态：学习巩固期结束，即将进入正式出击阶段**

---

## 一、阶段概述

本阶段从零基础开始搭建 Solidity 安全审计能力，经历了 **7 个项目审计**、**5 次平台拒稿**、**3 个平台账号危机**、**1 次积分耗尽危机**，最终沉淀出完整的方法论、5 条审计铁律和一条真实可行的赏金路线。

**阶段成果**：
- ✅ 独立完成 7 个项目审计（Ethena、Immutable、mETH、Metronome、The Graph、SSV Network、Pinto、Ember Vaults）
- ✅ 搭建 Foundry PoC 测试模板并实战验证
- ✅ 识别 5+ 种核心漏洞模式并固化文档
- ✅ Bugcrowd 1 份报告存活 18 天仍在审核（质量过关）
- ✅ Cantina KYC 通过（新身份证 + Persona 认证）
- ✅ 学会 2 套 CDP 浏览器自动化脚本
- ✅ 建立每日 commit 习惯（Day 23）

---

## 二、项目审计清单

| 项目 | 平台 | 结论 | 关键发现 | 状态 |
|---|---|---|---|---|
| **Ethena** (StakedUSDeV2) | Immunefi | ❌ 死路 | blacklist bypass 在 Known Issues 已列出 | 不可获赏 |
| **Immutable** (zkEVM Bridge) | Bugcrowd | 🟢 1 份存活 | Unbounded Withdrawal Queue DoS（High） | **等 8/6 结果** |
| **Immutable** (5 份报告) | Bugcrowd | ❌ 4 份 N/A | 缺 PoC + 管理员函数超范围 | 血的教训 |
| **mETH Protocol** | Immunefi | ❌ 死路 | 特权角色超出范围 | 不再重审 |
| **Metronome Synth** | Immunefi | ⏸️ 暂缓 | KYC 卡住 | 等条件成熟 |
| **The Graph** | Immunefi | ❌ 死路 | 20+ 合约审计完，无 Critical/High | 不再重审 |
| **SSV Network** | Immunefi | ❌ 死路 | 6 模块 + 5 库审计完，0 漏洞 | 不再重审 |
| **Pinto Protocol** | — | ❌ 死路 | EIP-2535 钻石架构，太复杂 | 不再重审 |
| **Ember Vaults** | HackenProof | ❌ 死路 | 需 50 声望点 + Medium 奖金 $0 | 不再重审 |
| **Cantina 平台** | Cantina | ✅ 就绪 | KYC 已通过，账号可用 | **主攻方向** |

**审计工作量**：约 30,000+ 行合约代码、17+ 份审计报告、10 个 Foundry PoC 测试文件

---

## 三、核心方法论（5 条审计铁律）

> 来源：7/21 Bugcrowd 5 份报告 4 份 Not Applicable 的血泪教训，已固化到 SOUL.md 和审计 Skill

1. **特权角色 = 超出范围** — 提交前第一步问"谁能触发？"。只有普通用户能触发的才值得写。例外：权限检查本身有 bug（缺 onlyAdmin 修饰符）。
2. **没有 PoC = 秒拒** — 每个报告必须附带可运行的 Foundry 测试文件（.t.sol），只有文字声明 = 浪费名额。
3. **没有攻击场景 = 没有影响** — 必须回答"作为攻击者我能够..."，写明攻击步骤 + 受害者损失。
4. **不要重复提交** — 提交前检查标题唯一性，浪费名额。
5. **不浪费新账户名额** — 只在 PoC 完成 + 确认有效后再提交。

### 审计标准流程
1. 找到可疑代码
2. **检查谁调用这个函数**（只看普通用户可调用的）
3. 确认有真实攻击场景（"作为攻击者我能够..."）
4. 写 Foundry PoC 测试文件（.t.sol）
5. 本地运行 `forge test` 确认 PoC 通过
6. 检查标题不重复
7. 提交，附带 PoC 文件

---

## 四、漏洞模式库（已固化）

| # | 漏洞模式 | 严重度 | CWE | 实战案例 |
|---|---|---|---|---|
| 1 | Access Control Bypass | High~Critical | CWE-862 | Ethena unstake 绕过 |
| 2 | Unbounded Array Growth (Griefing) | Medium~High | CWE-400 | Immutable pendingWithdrawals |
| 3 | Missing Upper Bound Validation | High | CWE-1284 | Immutable setWithdrawalDelay |
| 4 | Zero Address Validation | Low~Medium | CWE-476 | 跨链消息解码 |
| 5 | Incomplete State Cleanup | High~Critical | — | 罚没函数残留状态 |
| 6 | 重入攻击 (Reentrancy) | High | CWE-841 | CEI vs ReentrancyGuard |
| 7 | 预言机价格操纵 | High | CWE-472 | Uniswap V2 TWAP |
| 8 | 签名重放 (Signature Replay) | High | CWE-347 | EIP-712 domain separator |

> ⚠️ 概念纠正：闪电贷是攻击**向量**（Vector），不是漏洞**模式**（Pattern）。一个 Flashloan 漏洞一定是组合了其他漏洞模式。

---

## 五、平台认知（已纠正的错误信息）

| 平台 | 真相 | 备注 |
|---|---|---|
| **Immunefi** | ✅ **不需要押金** | 50 USDC 是 Sherlock 等平台的规则 |
| **Bugcrowd** | 新账户有 pending 上限 | 提交名额有限，不可浪费 |
| **HackenProof** | 需 50 声望点才能提交 | 新账号从 0 开始 |
| **Cantina** | 6610 万美元可赔付 | 18637 研究人员 |
| **Ethena** | Known Issues 要先查 | 漏洞已列出 = 白写 |
| **Telegram** | 通用机器人 ≠ 安全团队 | Ethena 教训 |

**Cantina 重点项目排序**：
1. **Kinetiq $5M** — Hyperliquid LSD，新项目竞争低（优先）
2. **Coinbase $5M** — Base/cbBTC/cbETH 生态
3. **Mezo Network $500K** — BTC 桥（Wormhole NTT）
4. **Polymarket $5M** — 预测市场
5. **Reserve Protocol $10M** — 需 $100 押金，暂缓

---

## 六、平台账号状态

| 平台 | 状态 | 备注 |
|---|---|---|
| **Bugcrowd** | ✅ 已恢复 | 密码重置成功（临时码 d58nSaBb）、邮件 MFA、Jumio IDV 通过、W-8BEN 已交 |
| **Cantina** | ✅ 已就绪 | KYC Persona 通过（新身份证）、收款地址已验证 |
| **HackenProof** | ✅ 可登录 | 2FA 已关闭，但 Ember 路线放弃 |
| **GitHub** | ✅ 正常 | Day 23 commit，push 需 GitHub Desktop |
| **X** | ✅ 正常 | @EmberProtocol 无回复，放弃该渠道 |

---

## 七、关键教训（血训汇总）

### 积分管理（7/28 血训）
- **永远不对积分消耗做任何承诺** — "不花积分"、"花得少"这些话一个字都不能说
- **涉及花钱/积分必须先问 MirSun** — 不替他做决策
- **每句对话都在消耗积分**，不存在"不花积分"的操作
- 7/28 积分见底（12.58 分）导致全部工作停摆

### 账号安全（7/24-7/28 血训）
- 平台账号被锁后邮件投递可能受影响，发起支持工单是唯一通路
- 浏览器保存的密码 ≠ 当前正确密码，验证失败优先试登录页找回
- Gmail 过滤器要提前设置：bugcrowd / okta / hackenproof / persona 邮件不进 Trash
- 平台账号卡死的备选渠道必须提前规划，不能拖到 deadline 才准备

### 安全披露（7/27 血训）
- 先验证对方是安全团队再发漏洞细节（Ethena 发给了 Telegram 通用机器人）
- 查 Known Issues 再写报告（Ethena 漏洞已列出，白写）
- 管理员函数 ≠ 漏洞（平台决定漏洞价值：Immunefi 收、Bugcrowd 不收）

---

## 八、技术能力积累

### 1. Foundry PoC 模板（foundry-poc-template/）
- Victim + Attacker + PoCTest + Deploy + README 完整结构
- 关键技巧：`vm.prank`、`vm.deal`、`vm.expectRevert`、`assertEq` 余额对比

### 2. CDP 浏览器自动化（2 套脚本）
- X DM 检查脚本（check-ember-dm.cjs）
- Bugcrowd 跟进脚本（bugcrowd-followup2.mjs）
- 核心：Chrome `--remote-debugging-port=9222` + WebSocket CDP 协议
- 关键技巧：React 表单需 `Input.dispatchKeyEvent` 逐字符输入，直接设 value 不触发事件

### 3. 系统与备份
- 每天自动备份到 D 盘（automation）
- 记忆系统：MEMORY.md + 每日日志 + SOUL.md/USER.md
- C 盘清理释放 ~6 GB（User Temp 5GB + npm 1GB + Chrome Cache）

---

## 九、阶段里程碑时间线

```
7/14  🏁 开始 GitHub daily commit（Day 1）
7/16  📝 完成 Ethena 审计，提交 Immunefi
7/19  📮 Bugcrowd 提交 Immutable 5 份报告
7/21  💥 4 份 N/A — 5 条审计铁律诞生
7/23  🏛️ Cantina 注册成功，浏览项目
7/24  🔒 Bugcrowd + HackenProof 账号卡死
7/27  📚 学习巩固期开始（5 项基本功）
7/28  ⚠️ 积分见底（12.58）— 血训写入永久记忆
7/29  🔑 Bugcrowd 密码重置成功
7/30  ✅ Cantina KYC 通过（新身份证）
7/31  ❌ HackenProof Ember 确认死路
8/1-4 🧳 出差 4 天（自动化未执行，回来补录）
8/4   📊 出差汇报 + Finding 1 状态确认（预计 8/6）
8/5   🎯 学习巩固期最后一天，总结报告
8/6   ⏰ Bugcrowd Finding 1 预计出结果
```

---

## 十、未来路线图

### 短期（8/5-8/10）
1. **8/6 05:00** 自动化查 Bugcrowd Finding 1 最终状态（已设置）
2. 充值到账后，启动 **Cantina Kinetiq $5M** 审计
3. 用新审计标准（普通用户可触发 + PoC + 攻击场景）找可提交漏洞

### 中期（8-9 月）
1. 审 Cantina 重点项目：Kinetiq → Coinbase → Mezo → Polymarket
2. 积累 1-2 个 High/Critical 提交经验
3. 经验足够后攻 Immunefi 高赏金项目（无 KYC/押金要求）

### 长期
1. 赚到第一笔 USDC 赏金
2. 建立稳定的多平台提交流程
3. Human Passport KYC 完成（22.6/25，差 2.4 分）

---

## 十一、当前任务清单

### 等待中
- ⏰ **8/6** Bugcrowd Finding 1 出结果（预计）
- ⏳ 积分充值（8/4-8/5）

### 待启动
- 🎯 Cantina Kinetiq $5M 审计（充值后）
- 📊 Cantina 平台新项目观察（每日）

### 已关闭
- ❌ Ethena / The Graph / SSV / Pinto / mETH / Ember Vaults / HackenProof
- ❌ X @EmberProtocol 渠道
- ❌ Human Passport Biometrics（需 $5 ETH，暂缓）

---

*本报告基于 23 天每日日志、7 份审计报告和永久记忆整理。学习巩固期结束，正式出击阶段开始。*
