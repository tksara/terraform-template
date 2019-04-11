set INSTANCE_NAME=%1
set PROJECT=%2
set RITM=%3

curl -X PUT https://ven01183.service-now.com/servicenowCallbackUrl.do -H "Authorization: Basic YWRtaW46UzNydjNyQEF1dA==" -H "Content-Type: application/json" -d "{\"instance_name\": %INSTANCE_NAME%, \"gc_project\": %PROJECT%, \"request_item_id\": %RITM%}" --trace-ascii CON
