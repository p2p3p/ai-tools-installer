# AI Tools Installer

Termux/Android ARM64 一键安装脚本。

## 环境变量

- `INSTALL_DIR` — 安装目录，默认 `~/.local/share/<工具名>`
- `BIN_DIR` — 可执行文件目录，默认 `$PREFIX/bin`

## install-claude-code.sh

依赖 `nodejs`、`bun`，启动命令 `claude`。

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/ai-tools-installer/main/install-claude-code.sh)"
```

## install-cloai-code.sh

依赖 `glibc-runner`，启动命令 `cloai`。

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/ai-tools-installer/main/install-cloai-code.sh)"
```

## 许可

MIT