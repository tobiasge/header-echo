#!/bin/bash
exec granian \
  --host :: \
  --port 8080 \
  --interface asginl \
  --workers 4 \
  --backpressure 4 \
  --loop uvloop \
  --log \
  --log-level info \
  --access-log \
  --working-dir /opt/header-echo/app/ \
  --pid-file /tmp/granian.pid \
  asgi:app