set INSTANCE_NAME=%1
set PROJECT=%2

curl -X POST https://ven01183.service-now.com/servicenowCallbackUrl.do -H "Content-Type: application/json" -d "{\"instance_name\": %INSTANCE_NAME%, \"gc_project\": %PROJECT%}" --trace-ascii CON
