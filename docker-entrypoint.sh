#!/bin/bash
set -e

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
