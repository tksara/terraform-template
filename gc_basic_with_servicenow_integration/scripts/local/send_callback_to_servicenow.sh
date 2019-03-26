#!/bin/bash

CDA_HOST=$1
CDA_USER=$2
CDA_PASS=$3

AGENT_NAME=$4
DEPLTARGET=$5

TOMCAT_HOST=$6
TOMCAT_HOME_DIR=$7
TOMCAT_USER=$8
TOMCAT_PASS=$9

FOLDER=${10}

AUTH=$(echo -n "$CDA_USER:$CDA_PASS" | base64)

BODY=$(cat << EOF
{
	"status": "Active",
	"agent": "$AGENT_NAME",
	"name": "$DEPLTARGET",
	"custom_type": {
		"name": "Tomcat"
	},
	"custom": {
		"appbase_directory": "webapps",
		"home_directory": "$TOMCAT_HOME_DIR",
		"protocol": "http",
		"host": "$TOMCAT_HOST",
		"username": "$TOMCAT_USER",
		"password": "$TOMCAT_PASS",
		"port": 8080
	},
	"folder": {
		"name": "$FOLDER"
	},
	"owner": {
		"name": "$CDA_USER"
	}
}
EOF
)

curl -X POST $CDA_HOST/api/data/v1/deployment_targets -H "Authorization: Basic $AUTH" -H 'Content-Type: application/json' -d "$BODY"
