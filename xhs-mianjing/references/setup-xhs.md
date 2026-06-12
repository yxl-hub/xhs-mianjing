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

优先使用浏览器 Cookie 授权登录。先让用户在本机浏览器打开并登录小红书网页版：

```text
https://www.xiaohongshu.com/
```

然后运行自动探测：

```bash
xhs login
```

如果自动探测失败，再按用户实际使用的浏览器指定来源：

```bash
xhs login --cookie-source chrome
xhs login --cookie-source firefox
xhs login --cookie-source edge
xhs login --cookie-source safari
```

其他可用浏览器来源以 `xhs login --help` 为准。

如果 `xhs-cli` 调起本机浏览器窗口，用户可以在该窗口内输入账号密码或完成网页登录授权。不要让用户把密码、短信验证码或 Cookie 粘贴到聊天中。

如果浏览器 Cookie 提取后提示无登录信息，通常是：

- 浏览器里没有登录小红书网页版；
- 登录态已过期；
- 指定了错误的浏览器；
- 小红书网页端登录态不完整。

兜底使用二维码登录：

```bash
xhs login --qrcode
```

二维码登录可能启动辅助浏览器并首次下载浏览器组件。终端出现二维码后，用户用小红书 App 扫码确认即可。

检查状态：

```bash
xhs status
```

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
