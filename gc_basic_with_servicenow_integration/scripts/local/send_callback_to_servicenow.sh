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

curl -X POST https://ven01183.service-now.com/servicenowCallbackUrl.do -H 'Content-Type: application/json' -d "$BODY" --trace-ascii -
