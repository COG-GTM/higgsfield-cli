#!/bin/bash
# Live API check for the CLI MODELS.md / skills docs: the documented Genjutsu Restyle request, via curl.
set -e
T0=$(date +%s)
RESP=$(curl -sS -X POST https://api.higgsfield.ai/higgsfield/genjutsu/restyle/v1.0 \
  -H "Authorization: Key <KEY_ID>:<KEY_SECRET>" -H "Content-Type: application/json" \
  -d '{"video_url":"https://d3snorpfx4xhv8.cloudfront.net/a4086dbb-d386-4bab-8efd-636d1f91e38e/048d2e32-a6e8-4ec6-8013-042e8b25397e.mp4","preset_id":"368c6a65-4a48-4e3a-80c7-c460455b5e17","resolution":"480p","prompt":"Preserve the original movement and camera composition."}')
echo "submit: $RESP"
STATUS_URL=$(echo "$RESP" | python3 -c 'import sys,json;print(json.load(sys.stdin)["status_url"])')
while true; do
  S=$(curl -sS "$STATUS_URL" -H "Authorization: Key <KEY_ID>:<KEY_SECRET>")
  ST=$(echo "$S" | python3 -c 'import sys,json;print(json.load(sys.stdin)["status"])')
  echo "[$(( $(date +%s)-T0 ))s] $ST"
  case "$ST" in completed|failed|nsfw) echo "$S"; break;; esac
  sleep 10
done
