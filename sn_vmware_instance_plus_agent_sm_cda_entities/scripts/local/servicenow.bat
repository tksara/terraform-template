
set INSTANCE_NAME=%1
set PROJECT=%2
set RITM=%3

set SYS_ID=%1
set USER_TOKEN=%2
set INSTANCE_NAME=%3
set INSTANCE_IP=%4

curl -X POST https://ven01183.service-now.com/api/now/table/sc_req_item/%SYS_ID% -H "Accept: application/json" -H "Content-Type: application/json" -H "X-UserToken: %USER_TOKEN%" -d "{\"comments\": %INSTANCE_NAME%, \"instance_ip\": %INSTANCE_IP%, \"request_item_id\": %RITM%}" --trace-ascii CON
