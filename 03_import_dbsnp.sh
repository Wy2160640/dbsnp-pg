#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2

minimal=(Allele Population AlleleFreqBySsPop dn_PopulationIndGrp SNPSubSNPLink)
optional=(SnpChrCode SNPAlleleFreq RsMergeArch b141_SNPChrPosOnRef b141_SNPChrPosOnRef_GRCh37p13)

target=${minimal[@]}

mkdir -p data
cd data

for table in ${target[@]}; do
    for filename in ${table}.bcp.gz*; do
        echo "[INFO] Importing ${filename} into ${table} ..."
        gzip -d -c ${filename} \
            | tr -d '\15' \
            | nkf -Lu \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q

        psql $PG_DB $PG_USER -c "SELECT * FROM ${table} LIMIT 1" -q
    done;
done;

echo "[INFO] Done"
