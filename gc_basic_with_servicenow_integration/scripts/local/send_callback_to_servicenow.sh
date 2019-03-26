#!/bin/bash

IP=$1

BODY=$(cat << EOF
{
	"instanceIp": "$IP"
}
EOF
)

curl -X POST https://ven01183.service-now.com/servicenowCallbackUrl.do -H 'Content-Type: application/json' -d "$BODY"
