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

if [ ! -f "$TEAMCITY_DATA_PATH/plugins/teamcity-slack-integration.zip" ];
then
    echo "Downloading Slack plugin..."
    wget -P $TEAMCITY_DATA_PATH/plugins https://github.com/enlivenhq/teamcity-slack/blob/master/target/teamcity-slack-integration.zip?raw=true
fi

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
