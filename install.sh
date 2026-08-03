#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

INSTALL_DIR="${CLOAI_INSTALL_DIR:-$HOME/.local/share/cloai}"
BIN_DIR="${CLOAI_BIN_DIR:-${PREFIX:-$HOME/.local}/bin}"
TEMP_DIR="$(mktemp -d)"

cleanup() {
  [[ -n "${TEMP_DIR:-}" ]] && rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

die() {
  echo "错误: $*" >&2
  exit 1
}

for cmd in curl tar mktemp ln; do
  command -v "$cmd" >/dev/null || die "缺少命令: $cmd"
done

if ! command -v glibc-runner >/dev/null 2>&1; then
  command -v pkg >/dev/null 2>&1 || fail "缺少 glibc-runner，且找不到 pkg"
  pkg install -y glibc-repo
  pkg install -y glibc-runner
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