#!/usr/bin/with-contenv bashio

python3 - <<'PY'
from jpt_test_lib import hello, __version__

print(f"shared library OK: {hello()}")
print(f"shared library version: {__version__}")
PY

# Keep the app alive so the Home Assistant app can be started and its logs checked.
while true; do
    sleep 3600
done
