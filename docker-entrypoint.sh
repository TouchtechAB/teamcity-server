#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc
if [ ! -f "$TEAMCITY_DATA_PATH/plugins/tcSlackNotificationsPlugin" ];
then
    echo "Downloading Slack plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://github.com/PeteGoo/tcSlackBuildNotifier/releases/download/1.4.4/tcSlackNotificationsPlugin.zip
fi

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
