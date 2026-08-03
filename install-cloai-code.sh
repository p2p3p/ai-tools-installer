#!/bin/bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/cloai}"
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

if ! command -v glibc-runner >/dev/null; then
  echo "安装 glibc-runner..."
  pkg install -y glibc-repo 2>/dev/null || die "安装 glibc-repo 失败"
  pkg install -y glibc-runner 2>/dev/null || die "安装 glibc-runner 失败"
fi

echo "获取最新版本..."
RELEASE=$(curl -sS "https://api.github.com/repos/p2p3p/cloai-code/releases/latest") || die "获取版本信息失败"

TAG_NAME=$(echo "$RELEASE" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
[[ -n "$TAG_NAME" ]] || die "解析版本号失败"

ARCH_URL=$(echo "$RELEASE" | grep -o '"browser_download_url": "[^"]*cloai-linux-arm64[^"]*"' | cut -d'"' -f4)
[[ -n "$ARCH_URL" ]] || die "找不到下载链接"

echo "安装版本: $TAG_NAME"

ARCHIVE="$TEMP_DIR/cloai.tar.gz"
curl -sSL "$ARCH_URL" -o "$ARCHIVE" || die "下载失败"

VERSION_DIR="$INSTALL_DIR/versions/$TAG_NAME"
mkdir -p "$(dirname "$VERSION_DIR")" "$BIN_DIR"

rm -rf "$VERSION_DIR"
mkdir -p "$VERSION_DIR"
tar -xzf "$ARCHIVE" -C "$VERSION_DIR"
chmod 755 "$VERSION_DIR/cloai"

ln -sfn "versions/$TAG_NAME" "$INSTALL_DIR/current"

cat > "$BIN_DIR/cloai" << SCRIPTEOF
#!/bin/bash
BIN="${INSTALL_DIR}/current/cloai"
if command -v glibc-runner >/dev/null 2>&1; then
  exec glibc-runner "\$BIN" "\$@"
else
  exec "\$BIN" "\$@"
fi
SCRIPTEOF
chmod 755 "$BIN_DIR/cloai"

"$BIN_DIR/cloai" --version >/dev/null 2>&1 || {
  rm -f "$INSTALL_DIR/current"
  die "安装验证失败"
}

echo "✓ Cloai $TAG_NAME 安装完成"
echo "运行: cloai"