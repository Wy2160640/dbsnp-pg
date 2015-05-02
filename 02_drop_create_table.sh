#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

psql $PG_DB $PG_USER -f ./postgresql/scheme/create_tables.sql

echo "[INFO] Done"