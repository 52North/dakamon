#!/bin/sh
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
################################################################################
#                                                                              #
# Author : e.h.juerrens@52north.org                                            #
# Purpose: delete files/folders older than configured days in directory        #
#                                                                              #
################################################################################
#                                                                              #
#     VARIABLES                                                                #
#                                                                              #
################################################################################
KEEP_DAYS=35
INFO_FILE="1__Everything_older_${KEEP_DAYS}d_will_be_removed"
# MUST be kept in sync with the both conf.R files with the value of
# feederTmpDirectory
FOLDER_TO_CLEAN="/tmp/dakamon"
################################################################################
#                                                                              #
#     THE SCRIPT                                                               #
#                                                                              #
################################################################################
# touch the $INFO_FILE
cd "$FOLDER_TO_CLEAN" || exit
touch "$INFO_FILE"
# find all files older than $KEEP_DAYS
find ./* -ctime +"$KEEP_DAYS" -exec rm -r {} +
