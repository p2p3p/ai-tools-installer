# Cloai Installer

Cloai 一键安装脚本（Termux/Android ARM64）

## 使用方法

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/p2p3p/cloai-installer/main/install.sh)"
```

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `CLOAI_INSTALL_DIR` | 安装目录 | `~/.local/share/cloai` |
| `CLOAI_BIN_DIR` | 可执行文件目录 | `$PREFIX/bin` 或 `~/.local/bin` |
| `CLOAI_LOCAL_ARCHIVE` | 本地归档文件路径 | 无 |

## 许可

MIT