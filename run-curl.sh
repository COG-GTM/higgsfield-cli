#!/usr/bin/env bash
set -u
log() { echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*" | tee -a run.log; }
BODY='{"video_url":"https://d3snorpfx4xhv8.cloudfront.net/a4086dbb-d386-4bab-8efd-636d1f91e38e/59dac11e-bd99-4bc7-a627-2638e7ad9840.mp4","preset_id":"c2143317-f28d-4c3c-a0b8-39bd547e08a7","image_urls":[],"prompt":"Preserve the original movement and camera composition.","resolution":"480p"}'
log "POST https://api.higgsfield.ai/higgsfield/genjutsu/restyle/v1.0"
log "body: $BODY"
START=$(date +%s)
RESP=$(curl -sS -X POST https://api.higgsfield.ai/higgsfield/genjutsu/restyle/v1.0 -H "Authorization: Key $HFK" -H "Content-Type: application/json" -d "$BODY")
log "submit response: $RESP"
URL=$(echo "$RESP" | python3 -c 'import sys,json;print(json.load(sys.stdin)["status_url"])')
LAST=""
while true; do
  S=$(curl -sS "$URL" -H "Authorization: Key $HFK")
  ST=$(echo "$S" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("status"))' 2>/dev/null)
  if [ "$ST" != "$LAST" ]; then log "status: $ST ($(( $(date +%s)-START ))s) $S"; LAST=$ST; fi
  case "$ST" in completed|failed|nsfw|canceled) break;; esac
  sleep 10
done
log "elapsed: $(( $(date +%s)-START ))s"
echo "$S" > final.json
