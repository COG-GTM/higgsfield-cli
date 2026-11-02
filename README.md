# Genjutsu restyle live-proof evidence

Evidence for https://github.com/COG-GTM/higgsfield-cli/pull/2.

- `run-curl.sh`: the exact submit + poll script. The key comes from the env var `HFK` and is never logged.
- `run.log`: the timestamped status timeline (`queued` -> `in_progress` -> `completed`).
- `final.json`: the final status payload.
- `output.mp4`: the raw Genjutsu output (854x480).
- `before-after.mp4` / `.gif` / `-frames.png`: the labelled source vs. output side by side.

The API endpoint was called directly with curl. The `higgsfield generate create genjutsu_restyle` CLI command was not run: it needs browser OAuth.
