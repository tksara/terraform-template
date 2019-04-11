set SYS_ID=%1
set USER_TOKEN=%2
set INSTANCE_IP=%3

curl -X POST https://ven01183.service-now.com/api/now/table/sc_req_item/%SYS_ID% -H "Accept: application/json" -H "Content-Type: application/json" -H "X-UserToken: %USER_TOKEN%" -d "{\"comments\": %INSTANCE_IP%}" --trace-ascii CON
