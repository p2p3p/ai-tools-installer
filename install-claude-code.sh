#!/bin/bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/claude-code}"
BIN_DIR="${BIN_DIR:-${PREFIX:-$HOME/.local}/bin}"
TEMP_DIR="$(mktemp -d)"

cleanup() {
  [[ -n "${TEMP_DIR:-}" ]] && rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

die() {
  echo "错误: $*" >&2
  exit 1
}

DEPS="curl tar"
for cmd in $DEPS; do
  if ! command -v "$cmd" >/dev/null; then
    echo "安装 $cmd..."
    pkg install -y "$cmd" 2>/dev/null || apt install -y "$cmd" 2>/dev/null || die "无法安装 $cmd"
  fi
done

if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
  echo "安装 nodejs..."
  pkg install -y nodejs 2>/dev/null || apt install -y nodejs 2>/dev/null || die "无法安装 nodejs"
fi

if ! command -v bun >/dev/null; then
  echo "安装 bun..."
  pkg install -y bun 2>/dev/null || npm install -g bun 2>/dev/null || die "安装 bun 失败"
fi

echo "获取最新版本..."
RELEASE=$(curl -sS "https://api.github.com/repos/p2p3p/claude-code/releases/latest") || die "获取版本信息失败"

TAG_NAME=$(echo "$RELEASE" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
[[ -n "$TAG_NAME" ]] || die "解析版本号失败"

ARCH_URL=$(echo "$RELEASE" | grep -o '"browser_download_url": "[^"]*claude-code-v[^"]*\.tar\.gz"' | cut -d'"' -f4)
[[ -n "$ARCH_URL" ]] || die "找不到下载链接"

echo "安装版本: $TAG_NAME"

ARCHIVE="$TEMP_DIR/claude-code.tar.gz"
curl -sSL "$ARCH_URL" -o "$ARCHIVE" || die "下载失败"

VERSION_DIR="$INSTALL_DIR/versions/$TAG_NAME"
mkdir -p "$(dirname "$VERSION_DIR")" "$BIN_DIR"

rm -rf "$VERSION_DIR"
mkdir -p "$VERSION_DIR"
tar -xzf "$ARCHIVE" -C "$VERSION_DIR" --strip-components=1
chmod 755 "$VERSION_DIR/claude"

ln -sfn "versions/$TAG_NAME" "$INSTALL_DIR/current"

cat > "$BIN_DIR/claude" << SCRIPTEOF
#!/bin/bash
BUNDLE="${INSTALL_DIR}/current/claude-bundle.js"
exec bun "\$BUNDLE" "\$@"
SCRIPTEOF
chmod 755 "$BIN_DIR/claude"

bun "$INSTALL_DIR/current/claude-bundle.js" --version >/dev/null 2>&1 || {
  rm -f "$INSTALL_DIR/current"
  die "安装验证失败"
}

echo "✓ claude-code $TAG_NAME 安装完成"
echo "运行: claude"