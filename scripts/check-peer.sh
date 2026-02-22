#!/bin/bash
# Check and repair peer OpenClaw instance
PEER_IP="192.168.50.126"
PEER_NAME="wenjiejin_bot"
LOG="/root/.openclaw/scripts/peer-check.log"

check_peer() {
  # Check if peer gateway is running
  ssh -o ConnectTimeout=5 -o BatchMode=yes root@$PEER_IP "pgrep -f 'openclaw.*gateway' >/dev/null 2>&1" 2>/dev/null
  return $?
}

repair_peer() {
  echo "$(date): $PEER_NAME gateway down, restarting..." >> "$LOG"
  ssh -o ConnectTimeout=10 -o BatchMode=yes root@$PEER_IP "openclaw gateway restart" >> "$LOG" 2>&1
  sleep 10
  if check_peer; then
    echo "$(date): $PEER_NAME recovered ✅" >> "$LOG"
  else
    echo "$(date): $PEER_NAME restart FAILED ❌" >> "$LOG"
  fi
}

if ! check_peer; then
  repair_peer
fi
