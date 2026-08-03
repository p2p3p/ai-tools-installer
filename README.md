# AI Tools Installer

Termux/Android ARM64 一键安装脚本。

## 工具

| 工具 | 依赖 | 启动 |
|------|------|------|
| **Claude Code** | `nodejs` `bun` | `claude` |
| **Cloai** | `glibc-runner` | `cloai` |

## 安装

```bash
# Claude Code
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/ai-tools-installer/main/install-claude-code.sh)"

# Cloai
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/ai-tools-installer/main/install-cloai-code.sh)"

```

## 环境变量

- `INSTALL_DIR` — 安装目录，默认 `~/.local/share/<工具名>`
- `BIN_DIR` — 可执行文件目录，默认 `$PREFIX/bin`

## 许可

MIT