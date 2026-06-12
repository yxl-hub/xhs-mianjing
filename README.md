# 小红书面经 Skill

这是一个给 Codex 使用的小红书面经整理 Skill。Codex 直接复用上游[xhs-cli](https://github.com/jackwener/xiaohongshu-cli)的完整能力，通过本机 `xhs` 命令搜索、读取和整理小红书笔记。

适合用来整理：

- 岗位面经、实习面经、秋招/校招经验
- 公司或行业定向面试题
- 高频问题、问答对、轮次线索和准备建议
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

推荐先在本机浏览器打开小红书网页版并登录：

```text
https://www.xiaohongshu.com/
```

然后让 `xhs-cli` 自动探测本机已登录的小红书浏览器 Cookie：

```bash
xhs login
```

如果自动探测失败，再按用户实际使用的浏览器显式指定来源，例如：

```bash
xhs login --cookie-source chrome
xhs login --cookie-source firefox
xhs login --cookie-source edge
xhs login --cookie-source safari
```

如果浏览器 Cookie 提取失败，使用二维码兜底：

```bash
xhs login --qrcode
```

不要把小红书密码、短信验证码、Cookie 或 Token 发到聊天里。若 `xhs-cli` 调起本机浏览器窗口，在窗口内完成登录授权即可；这是本机流程，不需要把明文凭据交给 Codex。

检查登录状态：

```bash
xhs status
```

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
- 找一下上海互联网产品实习的小红书面经
- 小红书上有没有券商行研实习面经，帮我总结高频问题
- 帮我整理小红书里小红书公司产品经理岗位的面试经验
- 搜索 AI 产品运营面经，问答对和只有问题的内容分开整理
