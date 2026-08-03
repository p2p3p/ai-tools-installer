# AI Tools Installer

Termux/Android ARM64 一键安装脚本，支持以下 AI 工具：

- **Claude Code** — 安装 `claude` 命令，基于 `bun` 运行
- **Cloai** — 安装 `cloai` 命令，基于 `glibc-runner` 运行

## 安装脚本

### install-claude-code.sh

通过 bun 安装 Claude Code，依赖 `nodejs`、`bun`、`curl`、`tar`，会自动安装缺失的依赖。安装后通过 `claude` 命令启动。

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/ai-tools-installer/main/install-claude-code.sh)"
```

### install-cloai-code.sh

安装 Cloai，依赖 `glibc-runner`，会自动安装缺失的依赖。安装后通过 `cloai` 命令启动。

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