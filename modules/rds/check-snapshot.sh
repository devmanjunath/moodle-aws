#!/bin/bash

db_id=$1

if [ -z ${db_id} ]; then
  echo "usage : $0 <db_id>" >2
  exit 1
fi

eval "$(jq -r '@sh "region=\(.region)"')"

RESULT=($(aws rds describe-db-cluster-snapshots --db-cluster-identifier $db_id --region=$region --output text 2> /dev/null))
aws_result=$?

if [ ${aws_result} -eq 0 ] && [[ ${RESULT[0]} == "DBCLUSTERSNAPSHOTS" ]]; then
  result='true'
else
  result='false'
fi

jq -n --arg exists ${result} '{"db_exists": $exists }'