# Cloady Xray — VLESS + WS + TLS (PaaS-terminated TLS)
# Prepared 2026-11-15, for the user's free-only combo (goal_cdcf440fbfd2).
# Deploy source: GitHub repo containing these files, or Cloady "Docker image / uploaded folder".
# DO NOT share the UUID in this folder outside the user's own use; it is the VLESS credential.

# Why WS, not Reality/TCP on 443:
# Cloady provides automatic HTTPS/TLS at its ingress, so Xray listens plain WS
# inside the container on $PORT (default 8080). The client uses security=tls
# against Cloady's 443; Cloady terminates TLS and forwards WS to the container.
# A raw TCP Reality listener on 443 would not survive PaaS TLS termination.

# Resource guard (user rule: free only, no card):
# - Region: USE1 (US East) or USW1 (US West) — both listed "Free tier" on
#   https://cloady.com/ checked 2026-11-15 06:43 UTC (2026-11-14 22:43 UTC crawl).
# - Size: 0.5 vCPU / 1 GB RAM / 5 GB SSD — the free-tier ceiling.
# - Confirm the dashboard shows $0.00 before deploying; if it shows any charge, stop.
# - Traffic limit is UNRESOLVED: earlier docs check said 10 GB/mo, a third-party
#   listing dated 2026-11-10 says 200 GB/mo. Do not promise either; check the
#   workspace/dashboard figure at deploy time and keep usage light.

FROM ghcr.io/xtls/xray-core:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Cloady sets $PORT at runtime; 8080 is the fallback in entrypoint.sh.
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
