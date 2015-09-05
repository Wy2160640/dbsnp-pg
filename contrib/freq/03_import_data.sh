#!/usr/bin/env bash

PG_DB=$1
PG_USER=$2
BASE_DIR=$3
DATA_DIR=$4

source_ids=(1 2)

declare -A target2filename=( \
  ["1"]="1000genomes.phase1/ALL.chr*.*.vcf*"
  ["2"]="1000genomes.phase3/ALL.chr*.*.vcf*"
)

declare -A target2sample_ids=( \
  ["1"]="sample_ids.1000genomes.phase1.CHB+JPT+CHS.txt"
  ["2"]="sample_ids.1000genomes.phase3.CHB+JPT.txt"
)

# Skip non-unique rsids in original vcf.  # FIXME: Need to be revised.
declare -A target2exclude_rsids=( \
  ["1"]="--exclude-rsids 113940759 11457237 71904485"
  ["2"]=""
)

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing data..."

cd ${DATA_DIR}

# Use pypy if available
if type pypy >/dev/null; then
  py=$(which pypy)
else
  py=$(which python)
fi

table=AlleleFreq
for target in ${source_ids[@]}; do
    for filename in ${target2filename[${target}]}; do
        if [ ! -e ${filename} ]; then
            echo "[contrib/freq] [WARN] `date +"%Y-%m-%d %H:%M:%S"` ${filename} does not exists, so skip importing."
            continue
        fi

        echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Importing ${filename} into ${table} ..."
        ${py} ${BASE_DIR}/script/vcf2tsv.py \
              ${filename} \
              --source-id ${target} \
              --sample-ids ${BASE_DIR}/script/${target2sample_ids[${target}]} ${target2exclude_rsids[${target}]} \
            | psql $PG_DB $PG_USER -c "COPY ${table} FROM stdin DELIMITERS '	' WITH NULL AS ''" -q
    done;
done;

echo "[contrib/freq] [INFO] `date +"%Y-%m-%d %H:%M:%S"` Done"
