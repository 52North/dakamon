#!/bin/bash -e
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
scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or via sudo $0"
  exit
fi

documents_dir=/srv/dakamon-uploads

install_dir="/var/dakamon_install"
shiny_server_version=1.5.8.921

echo "DaKaMon - Installation"
echo "----------------------"
echo "$(date): Stop all services"
systemctl stop shiny-server tomcat8 postgresql nginx
echo "$(date): stopped shiny-server tomcat8 postgresql nginx"

read -r -p "FQDN of host: " host_name
read -r -p "Database name: " database
read -r -p "Database user: " database_user
read -r -s -p "Database password: " database_password

# create installation directory
mkdir -vp $install_dir > /dev/null 2>&1
echo "$(date): DaKaMon working directory: ${install_dir}"
cd "$install_dir"


##
## Install tools and libraries
##
echo "$(date): Install base system packages:"
apt-get update && apt-get upgrade -y
apt-get install --assume-yes --no-install-recommends \
  dirmngr \
  gdebi-core \
  git \
  libcurl4-openssl-dev \
  libpq-dev \
  libssl-dev \
  maven \
  nginx \
  openjdk-8-jdk \
  postgresql-9.6-postgis-2.3 \
  postgresql-9.6-postgis-scripts \
  procps \
  software-properties-common \
  tomcat8

# remove tomcat examples and root app

echo "$(date): Remove not needed Tomcat webapps"

rm -rfv /var/lib/tomcat8/webapps/docs
rm -rfv /var/lib/tomcat8/webapps/examples
rm -rfv /var/lib/tomcat8/webapps/host-manager
rm -rfv /var/lib/tomcat8/webapps/manager
rm -fv /var/lib/tomcat8/webapps/ROOT/tomcat*
find /var/lib/tomcat8/webapps/ROOT/* -maxdepth 0  -type f -exec rm -v {} \;

# set PermSize settings in JAVA_OPTS if not already set
grep -vq "^JAVA_OPTS=.*XX:PermSize=" /etc/default/tomcat8 && echo "JAVA_OPTS=\"\$JAVA_OPTS -XX:PermSize=3076m\"" >> /etc/default/tomcat8
grep -vq "^JAVA_OPTS=.*XX:MaxPermSize=" /etc/default/tomcat8 && echo "JAVA_OPTS=\"\$JAVA_OPTS -XX:MaxPermSize=4096m\"" >> /etc/default/tomcat8


##
## Install R environment
##

echo "$(date): Prepare R environment ..."

# TODO upgrade option of shiny server
#        - compare version (of installed shiny server)
#        - uninstall if versions do not match
#        - download and install required version

# install current R version
apt-add-repository "deb http://cran.uni-muenster.de/bin/linux/debian/ $(lsb_release -cs)-cran35/"
# TODO change to list of keys with loop
cran_fingerprint=E19F5F87128899B192B1A2C2AD5F960A256A04AF
gpg --list-keys $cran_fingerprint > /dev/null 2>&1 || gpg --keyserver keyserver.ubuntu.com --recv-keys $cran_fingerprint
gpg -a --export $cran_fingerprint | apt-key add -
cran_fingerprint=6212B7B7931C4BB16280BA1306F90DE5381BA480
gpg --list-keys $cran_fingerprint > /dev/null 2>&1 || gpg --keyserver keyserver.ubuntu.com --recv-keys $cran_fingerprint
gpg -a --export $cran_fingerprint | apt-key add -

apt-get update && apt-get install -y r-base

# install R packages
R --no-save <<EOF
list.of.packages <- c('DT', 'Rcpp', 'rlang', 'shiny', 'shinyjs', 'httr', 'rjson', 'dplyr', 'RPostgreSQL', 'readr', 'devtools', 'later', 'pool', 'shinyWidgets')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if (length(new.packages)) install.packages(new.packages, repos='https://cran.rstudio.com/')
EOF

if [ ! -f /usr/bin/shiny-server ]; then
  # install shiny server
  echo "$(date): Installing Shiny Server ..."
  shiny_server_deb="shiny-server-${shiny_server_version}-amd64.deb"
  wget "https://download3.rstudio.org/ubuntu-14.04/$(uname -m)/${shiny_server_deb}"
  gdebi -n ${shiny_server_deb}

  # register shiny at systemd
  cp $scriptpath/systemd/shiny-server.service /etc/systemd/system
  systemctl enable shiny-server
else
  echo "$(date): Shiny Server already installed"
fi

# Updating and configuring Shiny Apps are performed
# via update-apps.sh script!

# create upload dir if not exist yet
mkdir -vp "$documents_dir" > /dev/null 2>&1 || :
chown -Rv shiny:shiny "$documents_dir"

systemctl start shiny-server


##
## Build Java artifacts
##

echo "$(date): Prepare Java artifacts ..."

##
## Install SERIES REST API
##

cd $install_dir
series_api_dir=$install_dir/series-rest-api
if [ ! -d series-rest-api ]; then
  echo "$(date): Checkout series-rest-api to ${series_api_dir} ..."
      git clone https://github.com/EHJ-52n/series-rest-api.git $series_api_dir
  cd $series_api_dir
  git checkout -b distribution/dakamon origin/distribution/dakamon
else
  cd $series_api_dir
  echo "$(date): Update series-rest-api (branch: $(git branch)) ..."
  git pull
fi
mvn install -DskipTests=true -DdownloadSources=false -DdownloadJavadocs=false


##
## Install SERIES DAO
##

cd $install_dir
series_dao_dir=$install_dir/dao-series-api
if [ ! -d dao-series-api ]; then
  echo "$(date): Checkout dao-series-api to ${series_dao_dir} ..."
  git clone https://github.com/EHJ-52n/dao-series-api.git $series_dao_dir
  cd $series_dao_dir
  git checkout -b distribution/dakamon origin/distribution/dakamon
else
  cd $series_dao_dir
  echo "$(date): Update dao-series-api (branch: $(git branch)) ..."
  git pull
fi
mvn install -DskipTests=true -DdownloadSources=false -DdownloadJavadocs=false


##
## Install SOS
##

cd $install_dir
sos_dir=$install_dir/sos
if [ ! -d sos ]; then
  echo "$(date): Checkout SOS to $sos_dir ..."
  git clone https://github.com/EHJ-52n/SOS.git $sos_dir
  cd $sos_dir
  git checkout -b distribution/dakamon origin/distribution/dakamon
else
  cd $sos_dir
  echo "$(date): Update SOS (branch: $(git branch)) ..."
  git pull
fi
mvn package -DskipTests=true -P-check -DdownloadSources=false -DdownloadJavadocs=false


# configuration
tomcat_webapps_dir=/var/lib/tomcat8/webapps
sos_install_dir=$tomcat_webapps_dir/52n-sos-webapp

if [ -d "$sos_install_dir" ]; then
  echo "$(date): SOS installation found in $sos_install_dir. Start removal..."
  rm -r "$sos_install_dir"
  echo "$(date): Finished removal of SOS installation"
fi
echo "$(date): Start copy and configuration of SOS..."
cp -r "$install_dir/sos/webapp/target/52n-sos-webapp" "$tomcat_webapps_dir/"
cp "$scriptpath/sos/configuration.db" "$sos_install_dir/"
cp "$scriptpath/sos/tomcat-index.html" "$tomcat_webapps_dir/ROOT/index.html"
cp "$scriptpath/sos/application.properties" "$sos_install_dir/WEB-INF/classes/"
cp "$scriptpath/sos/settings.json" "$sos_install_dir/static/client/helgoland/"
cp "$scriptpath/sos/logback.xml" "$sos_install_dir/WEB-INF/classes/"

sed -i "s/hibernate.connection.username=.*/hibernate.connection.username=${database_user}/g" "$scriptpath/sos/datasource.properties"
sed -i "s/hibernate.connection.password=.*/hibernate.connection.password=${database_password}/g" "$scriptpath/sos/datasource.properties"
sed -i "s_db\\:5432/sos.*_localhost\\:5432/${database}_g" "$scriptpath/sos/datasource.properties"

cp "$scriptpath/sos/datasource.properties" "$sos_install_dir/WEB-INF/"
chown -R tomcat8:tomcat8 "$sos_install_dir"
echo "$(date): Finished copy and configuration of SOS."


##
## Install SOS Feeder
##

#ln -sv /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java

echo "$(date): Start copy and configuration of sos-importer..."
cd $install_dir
importer_dir=$install_dir/sos-importer
mkdir -pv /usr/local/52n > /dev/null 2>&1 || :
prebuild_feeder_jar="$scriptpath/../52n-sos-importer-feeder-bin.jar"
if [ -f "$prebuild_feeder_jar" ]; then
  chown shiny:shiny "$prebuild_feeder_jar"
  cp "$prebuild_feeder_jar" /usr/local/52n/
else
  if [ ! -d sos-importer ]; then
    echo "$(date): Checkout SOS-Importer to ${importer_dir} ..."
    git clone https://github.com/EHJ-52n/sos-importer.git $importer_dir
    cd $importer_dir
  else
    cd $importer_dir
    echo "$(date): Update SOS-Feeder (branch: $(git branch)) ..."
    git pull
  fi
  cp "$scriptpath/feeder/logback.xml" $importer_dir/feeder/src/main/resources/logback.xml
  mvn package -e -DskipTests=true -DdownloadSources=false -DdownloadJavadocs=false
  chown shiny:shiny $importer_dir/feeder/target/52n-sos-importer-feeder-bin.jar
  mkdir -pv /usr/local/52n
  cp $importer_dir/feeder/target/52n-sos-importer-feeder-bin.jar /usr/local/52n/
fi
echo "$(date): Finished copy and configuration of sos-importer."



##
## Configure nginx proxy
##
nginx_proxy_webroot=/srv/landingpage
nginx_proxy_site=/etc/nginx/sites-available/default
echo "$(date): Start configuration of nginx proxy..."
cp "$scriptpath/proxy/proxy.conf" "$nginx_proxy_site"
mkdir -pv "$nginx_proxy_webroot"
cp "$scriptpath/proxy/index.html" "$nginx_proxy_webroot/"
cp -r "$scriptpath/proxy/fonts" "$nginx_proxy_webroot/"
cp -r "$scriptpath/proxy/css" "$nginx_proxy_webroot/"
cp -r "$scriptpath/proxy/img" "$nginx_proxy_webroot/"
cp -r "$scriptpath/proxy/js" "$nginx_proxy_webroot/"

sed -i "s/sos:8080/localhost:8080/g" "$nginx_proxy_site"
sed -i "s/shiny:3838/localhost:3838/g" "$nginx_proxy_site"
sed -i "s/server_name localhost;/$host_name;/g" "$nginx_proxy_site"
echo "$(date): Finished configuration of nginx proxy."

##
## Configure and enable dakamon tmp cleaning service
##
echo "$(date): Start configuration of dakamon tmp cleaning service..."
mkdir -pv /usr/local/52n
cp "$scriptpath/systemd/clean-dakamon-tmp.sh" /usr/local/52n/
cp "$scriptpath/systemd/clean-dakamon-tmp.service" /etc/systemd/system/
cp "$scriptpath/systemd/clean-dakamon-tmp.timer" /etc/systemd/system/
systemctl daemon-reload
systemctl enable clean-dakamon-tmp.service clean-dakamon-tmp.timer
systemctl start clean-dakamon-tmp.timer
echo "$(date): Finished configuration of dakamon tmp cleaning service."

##
## FINISH: start all required services
##

echo "$(date): Start all services"
echo "$(date): Start postgresl"
systemctl start postgresql
echo "$(date): Start tomcat"
systemctl start tomcat8
echo "$(date): Start nginx"
systemctl start nginx
echo "$(date): DaKaMon installation finished."
