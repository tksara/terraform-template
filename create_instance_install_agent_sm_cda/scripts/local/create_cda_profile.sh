#!/bin/bash

CDA_HOST=$1
CDA_USER=$2
CDA_PASS=$3
PROFILE=$4
FOLDER=$5
LOGIN_OBJECT=$6
APPLICATION=$7
ENVIRONMENT=$8

AUTH=$(echo -n "$CDA_USER:$CDA_PASS" | base64)

BODY=$(cat << EOF
{
	"environment": {
		"name": "$ENVIRONMENT"
	},
	"application": {
		"name": "$APPLICATION"
	},
	"login": {
		"name": "$LOGIN_OBJECT"
	},
	"folder": {
		"name": "$FOLDER"
	},
	"archived": false,
	"owner": {
		"name": "$CDA_USER"
	},
	"name": "$PROFILE"
}
EOF
)

curl -X POST $CDA_HOST/api/data/v1/profiles -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY"
