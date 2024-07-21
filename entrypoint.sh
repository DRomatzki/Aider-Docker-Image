#!/bin/sh
# Ensure the config directory has the correct ownership
chown -R appuser:appgroup /home/appuser/config
exec "$@"

