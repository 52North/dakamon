#! /bin/bash -e

echo ""
echo "Going to update Shiny Apps"
echo "--------------------------"

scriptpath="$( cd "$(dirname "$0")" && pwd -P || echo "$(dirname "$0") does not exist" && exit )"

documents_dir=/srv/dakamon-uploads

tools_zip="$scriptpath/tools.zip"
r_tools_dir="$scriptpath/tools"
shiny_srv_dir="/srv/shiny-server"

curl --fail -sS -n -o "$tools_zip" https://github.com/52north/dakamon-r-tools/zipball/master

echo "Downloaded to $tools_zip"


echo "Unzip apps ..."

# delete old tools if present
  echo "Remove old tools at $r_tools_dir"
rm -rv "$r_tools_dir" > /dev/null 2>&1 || :
unzip -q -o "$tools_zip" -d "$r_tools_dir"
echo "Shiny apps extracted to $(ls "$r_tools_dir")"

# ask for credentials before stopping shiny server

echo ""
echo "Eingabe der SOS Credentials"
read -r -p "SOS Admin Username: " sos_admin_username
read -r -s -p "SOS Admin password: " sos_admin_password

echo ""
echo "--------------------"
echo "Database credentials"
read -r -p "Database: " database
read -r -p "Username: " database_user
read -r -s -p "Password: " database_password

echo "Stop shiny server before updating apps"
systemctl stop shiny-server

echo "Copy apps to $shiny_srv_dir"
cp -r "$r_tools_dir/"*"dakamon-r-tools"*"/DaKaMon_viewer" "$shiny_srv_dir"
cp -r "$r_tools_dir/"*"dakamon-r-tools"*"/DaKaMon_importer" "$shiny_srv_dir"
cp -r "$r_tools_dir/"*"dakamon-r-tools"*"/docker/shiny-server.conf" "/etc/shiny-server/shiny-server.conf"

echo "------------------------------"
echo "Configure Importer/Viewer Apps"
echo "------------------------------"

# importer/viewer config
sed -i "s=SOSWebApp.*=SOSWebApp <- 'http://localhost:8080/52n-sos-webapp/'=g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s=feederPath.*=feederPath <- '/usr/local/52n/52n-sos-importer-feeder-bin.jar'=g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s/adminConf.*/adminConf <- authenticate(\"$sos_admin_username\", \"$sos_admin_password\")/g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s/dbHost.*/dbHost <- 'localhost'/g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s/dbPassword.*/dbPassword <- '$database_password'/g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s/dbUser.*/dbUser <- '$database_user'/g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s/dbName.*/dbName <- '$database'/g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s=fileUploadDir.*=fileUploadDir <- '$documents_dir'=g" "$shiny_srv_dir/DaKaMon_importer/conf.R"
sed -i "s=fileDownloadBaseUrl.*=fileDownloadBaseUrl <- '$host_name/documents'=g" "$shiny_srv_dir/DaKaMon_importer/conf.R"

rm -v "$shiny_srv_dir/DaKaMon_viewer/conf.R"
ln -sv "$shiny_srv_dir/DaKaMon_importer/conf.R" "$shiny_srv_dir/DaKaMon_viewer/conf.R"

# create upload dir if not exist yet
mkdir -vp "$documents_dir" /dev/null 2>&1 || :
chown -Rv shiny:shiny "$documents_dir"

chown -Rv shiny:shiny /srv/shiny-server/DaKaMon_viewer
chown -Rv shiny:shiny /srv/shiny-server/DaKaMon_importer

echo "Start shiny server after update ..."

systemctl start shiny-server

echo "Done."
echo "App update successful"
