# AI Tools Installer

Termux/Android ARM64 一键安装脚本。

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `INSTALL_DIR` | 安装目录 | `~/.local/share/<工具名>` |
| `BIN_DIR` | 可执行文件目录 | `$PREFIX/bin` |

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

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `INSTALL_DIR` | 安装目录 | `~/.local/share/<工具名>` |
| `BIN_DIR` | 可执行文件目录 | `$PREFIX/bin` |

## 许可

MIT