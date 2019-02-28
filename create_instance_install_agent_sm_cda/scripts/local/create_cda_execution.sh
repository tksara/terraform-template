#!/bin/bash

CDA_HOST=$1
CDA_USER=$2
CDA_PASS=$3
APPLICATION=$4
WORKFLOW=$5
PACKAGE=$6
PROFILE=$7

AUTH=$(echo -n "$CDA_USER:$CDA_PASS" | base64)

BODY=$(cat << EOF
{
	"application": {
		"name": "$APPLICATION"
	},
	"workflow": {
		"name": "$WORKFLOW"
	},
	"package": {
		"name": "$PACKAGE"
	},
	"deployment_profile": {
		"name": "$PROFILE"
	},
	"install_mode": "OverwriteExisting"
}
EOF
)

curl -X POST $CDA_HOST/api/data/v1/executions -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY"