#!/bin/sh
# Generates Xray config from runtime env, then runs xray.
# Env: PORT (default 8080, set by Cloady), VLESS_UUID (required at deploy;
# set it in Cloady as an env var — do not commit a real UUID to a public repo),
# WS_PATH (default /vless).
set -eu
PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/vless}"
: "${VLESS_UUID:?VLESS_UUID env var is required}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${VLESS_UUID}", "flow": "" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json
