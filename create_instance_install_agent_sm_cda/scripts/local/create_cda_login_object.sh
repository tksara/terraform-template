#!/bin/bash

CDA_HOST=$1
CDA_USER=$2
CDA_PASS=$3
FOLDER=$4

AGENT_USER=$5
AGENT_PASS=$6
AGENT_NAME=$7

LOGIN_OBJECT=$8

AUTH=$(echo -n "$CDA_USER:$CDA_PASS" | base64)

BODY=$(cat << EOF
{
	"name": "$LOGIN_OBJECT",
	"folder": {
		"name": "$FOLDER"
	},
	"owner": {
		"name": "$CDA_USER"
	}
}
EOF
)


LOGIN_RESPONSE=$(curl -X POST $CDA_HOST/api/data/v1/logins -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY")
LOGIN_ID=$(echo $LOGIN_RESPONSE | grep -Po '"id":\s*\K\d+' | head -1)

BODY=$(cat << EOF
{
	"type": "UNIX",
	"login_infor": "$AGENT_USER",
	"password": "$AGENT_PASS",
	"id": 0,
	"name": "$AGENT_NAME"
}
EOF
)

curl -X POST $CDA_HOST/api/data/v1/logins/$LOGIN_ID/credentials -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY"
