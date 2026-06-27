# 小红书配置

安装上游命令行工具：

```bash
pipx install xiaohongshu-cli
```

检查命令是否可用：

```bash
xhs --help
```

## 登录流程

面经搜索前必须先检查登录状态：

```bash
xhs status --json
```

如果已经登录，可以直接进入默认筛选与搜索。如果未登录或状态不明确，先让用户在本机浏览器打开并登录小红书网页版：

```text
https://www.xiaohongshu.com/
```

然后询问用户哪个浏览器已经登录小红书，不要默认指定 Chrome。按用户选择读取 Cookie：

```bash
xhs login --cookie-source chrome
xhs login --cookie-source firefox
xhs login --cookie-source edge
xhs login --cookie-source safari
xhs login --cookie-source brave
xhs login --cookie-source arc
```

其他可用浏览器来源以命令帮助为准：

```bash
xhs login --help
```

如果 `xhs-cli` 调起本机浏览器窗口，用户可以在该窗口内输入账号密码或完成网页登录授权。不要让用户把密码、短信验证码或 Cookie 粘贴到聊天中。

每次登录尝试后都要重新检查：

```bash
xhs status --json
```

只有确认已登录后，才可以搜索。

## 二维码兜底

如果浏览器 Cookie 提取失败，使用二维码登录：

```bash
xhs login --qrcode
```

二维码登录可能启动辅助浏览器并首次下载浏览器组件。终端出现二维码后，用户用小红书 App 扫码确认即可。扫码后仍需运行：

```bash
xhs status --json
```

## 常见失败原因

- 浏览器里没有登录小红书网页版。
- 登录态已过期。
- 指定了错误的浏览器。
- 当前浏览器不在 `xhs-cli` 支持列表中。
- 小红书网页端登录态不完整，或触发验证码/风控。

遇到验证码、风控或连续失败时，停止高频请求，优先让用户完成网页登录或改用二维码登录。

## 稳定只读命令

```bash
xhs search "关键词" --json
xhs read NOTE_ID_OR_URL --json
xhs comments NOTE_ID_OR_URL --json
xhs search-user "关键词" --json
xhs user USER_ID --json
xhs user-posts USER_ID --json
xhs topics "关键词" --json
```

注意：读取详情时优先使用 `xhs search` 返回的 URL 或标识。小红书可能要求上下文里的 `xsec_token`，手动拼接裸 note ID 可能失败。
