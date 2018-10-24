# Copyright (C) 2017-2018 52°North Initiative for
# Geospatial Open Source Software GmbH
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#
# If the program is linked with libraries which are licensed under one of
# the following licenses, the combination of the program with the linked
# library is not considered a "derivative work" of the program:
#
#     - Apache License, version 2.0
#     - Apache Software License, version 1.0
#     - GNU Lesser General Public License, version 3
#     - Mozilla Public License, versions 1.0, 1.1 and 2.0
#     - Common Development and Distribution License (CDDL), version 1.0
#
# Therefore the distribution of the program linked with libraries licensed
# under the aforementioned licenses, is permitted by the copyright holders
# if the distribution is compliant with both the GNU General Public
# License version 2 and the aforementioned licenses.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
#
#  build via
#
#    docker build -f sos/Dockerfile -t sos:dakamon-$(date +%Y-%m) --no-cache .
#
#  from repository root
FROM tomcat:9-jre8
MAINTAINER <a href="mailto:e.h.juerrens@52north.org">J&uuml;rrens, Eike Hinderk</a>

ENV MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /usr/share/maven

WORKDIR /tmp

RUN apt-get update &&\
    apt-get --assume-yes upgrade &&\
    apt-get dist-upgrade --assume-yes &&\
    apt-get install --assume-yes --no-install-recommends openjdk-8-jdk maven git
RUN git clone https://github.com/EHJ-52n/series-rest-api.git &&\
    cd series-rest-api &&\
    git checkout -b distribution/dakamon origin/distribution/dakamon &&\
    mvn install -DskipTests=true &&\
    cd ..
RUN git clone https://github.com/EHJ-52n/dao-series-api.git &&\
    cd dao-series-api &&\
    git checkout -b distribution/dakamon origin/distribution/dakamon &&\
    mvn install -DskipTests=true &&\
    cd ..
RUN git clone https://github.com/EHJ-52n/SOS.git &&\
    cd SOS &&\
    git checkout -b distribution/dakamon origin/distribution/dakamon &&\
    mvn package -DskipTests=true -P-check
RUN mv /tmp/SOS/webapp/target/52n-sos-webapp /usr/local/tomcat/webapps/ &&\
    rm -rfv /tmp/SOS &&\
    rm -rfv /usr/local/tomcat/webapps/docs &&\
    rm -rfv /usr/local/tomcat/webapps/examples &&\
    rm -rfv /usr/local/tomcat/webapps/host-manager &&\
    rm -rfv /usr/local/tomcat/webapps/manager &&\
    rm -fv /usr/local/tomcat/webapps/ROOT/tomcat* &&\
    find /usr/local/tomcat/webapps/ROOT/* -maxdepth 0  -type f -print0| xargs -0 rm -v &&\
    apt-get purge git maven openjdk-8-jdk --assume-yes &&\
    apt-get autoremove --purge --assume-yes && apt-get clean --assume-yes &&\
    rm -rf /var/cache/apt/archives &&\
    rm -rf /root/.m2 &&\
    rm -rf /var/lib/apt/lists/*

COPY sos/tomcat-index.html /usr/local/tomcat/webapps/ROOT/index.html
# config uses postgrest:postgres @db
COPY sos/datasource.properties /usr/local/tomcat/webapps/52n-sos-webapp/WEB-INF/
COPY sos/configuration.db /usr/local/tomcat/webapps/52n-sos-webapp/
COPY sos/application.properties /usr/local/tomcat/webapps/52n-sos-webapp/WEB-INF/classes/

WORKDIR /usr/local/tomcat

ENV JAVA_OPTS="-XX:PermSize=4096m -XX:MaxPermSize=3072m"
