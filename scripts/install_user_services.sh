#!/usr/bin/env bash
set -euo pipefail

UNIT_SOURCE_DIR="/home/nhatbang/nhatbang_web/Lilkremxxx.github.io/systemd"
UNIT_TARGET_DIR="${HOME}/.config/systemd/user"
BLOG_CONFIG_DIR="${HOME}/.config/blog"

mkdir -p "${UNIT_TARGET_DIR}" "${BLOG_CONFIG_DIR}"
cp "${UNIT_SOURCE_DIR}/blog.target" "${UNIT_TARGET_DIR}/blog.target"
cp "${UNIT_SOURCE_DIR}/blog-backend.service" "${UNIT_TARGET_DIR}/blog-backend.service"
cp "${UNIT_SOURCE_DIR}/blog-cloudflared.service" "${UNIT_TARGET_DIR}/blog-cloudflared.service"

if [ ! -f "${HOME}/.config/blog/cloudflared.yml" ]; then
  cat > "${HOME}/.config/blog/cloudflared.yml" <<'YAML'
tunnel: c77a9a42-577c-47d2-8ff9-2d4645cb250f
credentials-file: /home/nhatbang/.cloudflared/c77a9a42-577c-47d2-8ff9-2d4645cb250f.json

ingress:
  - hostname: blog-api.verbaa.pp.ua
    service: http://127.0.0.1:8787
  - service: http_status:404
YAML
fi

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
systemctl --user daemon-reload
systemctl --user enable --now blog.target
systemctl --user enable blog-backend.service blog-cloudflared.service
systemctl --user restart blog-backend.service
systemctl --user restart blog-cloudflared.service
