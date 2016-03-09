FROM ubuntu:14.04

RUN apt-get update \
	&& apt-get install -y --no-install-recommends sudo iptables unzip curl wget git-core software-properties-common \
	&& update-ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# JAVA 8 - Oracle
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
	&& echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends oracle-java8-installer ca-certificates-java \
	&& rm -r /var/cache/oracle-jdk8-installer \
	&& rm -r /usr/lib/jvm/java-8-oracle/lib/missioncontrol \
	&& rm -r /usr/lib/jvm/java-8-oracle/lib/visualvm \
	&& rm /usr/lib/jvm/java-8-oracle/src.zip \
	&& rm /usr/lib/jvm/java-8-oracle/javafx-src.zip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Get and install teamcity
ENV TEAMCITY_VERSION 9.1.6
ENV TEAMCITY_DATA_PATH /var/lib/teamcity

RUN wget -qO- https://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz | tar xz -C /opt \
  && mkdir -p $TEAMCITY_DATA_PATH/config

# Postgres JDBC driver
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc \
  && wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar

# Webhook plugin
RUN wget -P $TEAMCITY_DATA_PATH/plugins https://dl.bintray.com/cloudnative/teamcity/teamcity-webhooks/0.0.5/webhooks.zip

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

EXPOSE 8111
VOLUME /var/lib/teamcity
ENTRYPOINT exec /opt/TeamCity/bin/teamcity-server.sh run
