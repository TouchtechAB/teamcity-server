#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.3-1103.jdbc41.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc http://jdbc.postgresql.org/download/postgresql-9.3-1103.jdbc41.jar
fi

if [ ! -f "$TEAMCITY_DATA_PATH/plugins/webhooks.zip" ];
then
    echo "Downloading Webhook plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://dl.bintray.com/cloudnative/teamcity/teamcity-webhooks/0.0.5/webhooks.zip
fi

if [ ! -f "$TEAMCITY_DATA_PATH/plugins/tcSlackNotificationsPlugin" ];
then
    echo "Downloading Slack plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://github.com/PeteGoo/tcSlackBuildNotifier/releases/download/1.4.4/tcSlackNotificationsPlugin.zip
fi

if [ ! -f "$TEAMCITY_DATA_PATH/plugins/cloud-google" ];
then
    echo "Downloading Google Agents plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://github.com/JetBrains/teamcity-google-agent/archive/0.6.7.zip
fi

if [ ! -f "$TEAMCITY_DATA_PATH/plugins/google-artifact-storage" ];
then
    echo "Downloading Google Artifacts plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://github.com/JetBrains/teamcity-google-storage/archive/0.6.1.zip
fi

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
