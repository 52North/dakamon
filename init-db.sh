#! /bin/bash
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

if [ "$(whoami)" != "postgres" ]; then
    echo "Please switch to postgres user via "su postgres" as root!"
    exit 1
fi
echo "+-----------------------------------------------+"
echo "|      DaKaMon - Database - Configuration       |"
echo "+-----------------------------------------------+"

scriptpath="$( cd "$(dirname "$0")" && pwd -P || echo "$(dirname "$0") does not exist" && exit )"

echo "Use the same information as in the system configuration!"
read -r -p "Database name: " database
read -r -p "Database user: " database_user
read -r -s -p "Database password: " database_password
echo ""
psql -c "create user $database_user encrypted password '$database_password';"
psql -c "drop database if exists $database;"
psql -c "create database $database owner $database_user encoding 'utf-8';"
psql -d "$database" -c "create extension postgis;"
psql -d "$database" < "$scriptpath/db/init-dakamon-db-schema.sql"

# Update tables
echo "$(date): Change table owners in $database to $database_user"
tables=$(psql -d "${database}" -tc "select tablename from pg_tables where schemaname = 'public';")
for table in $tables ; do
  psql -d "${database}" -c "alter table public.${table} owner to ${database_user}" ;
done

# Update sequences
echo "$(date): Change sequence owners in $database to $database_user"
seq_tables=$(psql -qAt -c "SELECT sequence_name FROM information_schema.sequences \
  WHERE sequence_schema = 'public';" "$database")
for tbl in $seq_tables ; do
  psql -c "alter table \"$tbl\" owner to $database_user" "$database" ;
done
echo "+-----------------------------------------------+"
echo "| DaKaMon - Database - Configuration - FINISHED |"
echo "------------------------------------------------+"
