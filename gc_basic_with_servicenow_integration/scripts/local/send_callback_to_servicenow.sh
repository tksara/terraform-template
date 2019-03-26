#!/bin/bash

INSTANCE_NAME=$1
PROJECT=$2

BODY=$(cat << EOF
{
	"instance_name": "$INSTANCE_NAME",
	"gc_project": "$PROJECT"
}
EOF
)

curl -X POST https://ven01183.service-now.com/servicenowCallbackUrl.do -H 'Content-Type: application/json' -H 'Postman-Token: eef0f3ee-707c-407c-8118-d6a1d8b6ea15' -H 'cache-control: no-cache'  -d "$BODY"
