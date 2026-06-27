# 小红书面经 Skill

这是一个给 Codex 使用的小红书面经整理 Skill。Codex 直接复用上游 [xhs-cli](https://github.com/jackwener/xiaohongshu-cli) 的完整能力，通过本机 `xhs` 命令搜索、读取和整理小红书笔记。

适合用来整理：

- 岗位面经、实习面经、秋招/校招经验
- 高频面试题、参考回答、轮次线索和准备建议
- 默认全选检索，以及可选的面试类型/阶段筛选
- 小红书笔记搜索结果、评论和用户公开发布内容

## 项目结构

```text
xiaohongshu-mianjing-skill/
├── README.md
├── scripts/
│   └── install.sh
└── xhs-mianjing/
    ├── SKILL.md
    └── references/
```

完整安装包就是这个目录。把整个 `xiaohongshu-mianjing-skill` 文件夹给其他 Codex 用户后，对方运行安装脚本或手动复制 `xhs-mianjing/` 目录即可使用。

## 安装 Skill

在项目根目录运行：

```bash
./scripts/install.sh
```

脚本会把 `xhs-mianjing/` 复制到：

```text
~/.codex/skills/xhs-mianjing/
```

脚本默认只安装到 Codex 技能目录，避免同时出现在 `~/.codex/skills` 和 `~/.agents/skills` 导致 `$` 技能选择器显示两个同名技能。

手动安装也可以：

```bash
mkdir -p ~/.codex/skills/xhs-mianjing
cp -R xhs-mianjing/. ~/.codex/skills/xhs-mianjing/
```

如果通过仓库链接让 Agent 安装，最稳妥的是给到技能目录链接，而不是只给仓库根目录：

```text
https://github.com/yxl-hub/xhs-mianjing/tree/main/xhs-mianjing
```

只给仓库根链接时，Agent 需要先识别 `xhs-mianjing/` 才能安装；本仓库根目录不是 Skill 目录，根目录下没有 `SKILL.md`。

## 安装 xhs-cli

本 Skill 依赖上游 `xiaohongshu-cli` 提供的 `xhs` 命令：

```bash
pipx install xiaohongshu-cli
```

检查是否安装成功：

```bash
xhs --help
```

## 登录流程

先检查登录状态：

```bash
xhs status --json
```

如果未登录，先在本机浏览器打开小红书网页版并登录：

```text
https://www.xiaohongshu.com/
```

然后告诉 Codex 哪个浏览器已经登录小红书。Codex 会按实际浏览器读取 Cookie，不会默认只读取 Chrome：

```bash
xhs login --cookie-source chrome
xhs login --cookie-source firefox
xhs login --cookie-source edge
xhs login --cookie-source safari
xhs login --cookie-source brave
xhs login --cookie-source arc
```

如果不确定当前 `xhs-cli` 支持哪些浏览器，可以查看：

```bash
xhs login --help
```

如果浏览器 Cookie 提取失败，使用二维码兜底：

```bash
xhs login --qrcode
```

不要把小红书密码、短信验证码、Cookie 或 Token 发到聊天里。若 `xhs-cli` 调起本机浏览器窗口，在窗口内完成登录授权即可；这是本机流程，不需要把明文凭据交给 Codex。

每次登录后再次检查：

```bash
xhs status --json
```

只有确认已登录后，Skill 才会继续搜索。

## 搜索筛选

默认情况下，Skill 不会停下来让你手动选择筛选项，而是直接按以下范围搜索：

- 面试类型：全选
- 面试阶段：全选

如果你在请求里主动指定，Skill 会自动收窄筛选：

- 面试类型：全选 / 日常实习 / 暑期实习 / 秋招校招 / 社招正式
- 面试阶段：全选 / 笔试 / 群面 / 一面 / 二面 / 三面终面 / HR面

例如“AI 产品经理一面面经”会优先检索一面内容；“AI 产品运营暑期实习面经”会优先检索暑期实习内容。你说“默认”“全选”“不限”时，Skill 会按两个维度都全选处理。

## 报告结构

最终报告会稳定包含四个主体部分：

- 高频题库：按分类整理本次提取到的所有高频问题，只包含问题。
- 带参考回答的面经：按来源整理有问题和回答的内容。
- 面试题清单：按来源整理只有问题、没有回答的内容。
- 备战建议：基于上述内容归纳可执行准备建议。

引用不放在正文里，统一放到报告末尾的“附录 > 来源列表”。

## xhs-cli 常用能力

查询类命令：

```bash
xhs search "AI产品经理 面经" --json
xhs read NOTE_ID_OR_URL --json
xhs comments NOTE_ID_OR_URL --json
xhs sub-comments NOTE_ID COMMENT_ID --json
xhs search-user "小红书 招聘" --json
xhs user USER_ID --json
xhs user-posts USER_ID --json
xhs topics "AI产品经理" --json
xhs feed --json
xhs hot --json
xhs my-notes --json
xhs notifications --json
xhs unread --json
```

操作类命令也由上游支持，例如 `like`、`favorite`、`follow`、`comment`、`post`、`delete` 等。面经整理任务默认不要执行这些写操作，除非用户明确要求且风险可控。

当前注意事项：

- `xhs favorites` 是上游提供的收藏列表命令，但小红书接口可能返回失败。
- 上游没有稳定暴露“收藏夹标签/分组”查询能力。
- 读取详情时优先使用 `xhs search` 返回的 URL 或标识；小红书可能要求上下文里的 `xsec_token`，手动拼裸 note ID 可能失败。

## 提示词示例

安装并登录完成后，可以在 Codex 中这样使用：

- 帮我搜 AI 产品经理小红书面经并整理成报告
- 搜索 AI 产品运营面经，日常实习和暑期实习都要
- 找一下 AI 产品经理一面、二面的面经，整理高频题库和备战建议
- 小红书上有没有券商行研实习面经，帮我总结高频问题
- 搜索 AI 产品运营面经，有参考回答的和只有问题的内容分开整理
