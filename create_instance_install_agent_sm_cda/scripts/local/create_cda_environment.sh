#!/bin/sh

CDA_HOST=$1
CDA_USER=$2
CDA_PASS=$3
DEPLTARGET=$4
FOLDER=$5
ENVIRONMENT=$6

AUTH=$(echo -n "$CDA_USER:$CDA_PASS" | base64)

BODY=$(cat << EOF
{
	"status": "Free",
	"deployment_targets": [{
		"name": "$DEPLTARGET"
	}],
	"name": "$ENVIRONMENT",
	"custom_type": {
		"name": "Production"
	},
	"folder": {
		"name": "$FOLDER"
	},
	"archived": false,
	"owner": {
		"name": "$CDA_USER"
	}
}
EOF
)


curl -X POST $CDA_HOST/api/data/v1/environments -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY"
