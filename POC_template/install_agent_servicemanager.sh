#!/bin/bash

echo -e "ubuntu\nubuntu" | sudo passwd ubuntu

AGENT_NAME=$1
AE_HOST=$2
AE_PORT=$3
SM_PORT=$4


#FOLDER=/home/ubuntu/AE
FOLDER=/root/Downloads/AE

# install agent
mkdir -p $FOLDER/Agent

cd $FOLDER
tar -zxvf ./artifacts/ucxjlx6.tar.gz -C ./Agent

cp ./Agent/bin/ucxjxxx.ori.ini ./Agent/bin/ucxjlx6.ini
sed -i "s/name=UNIX01/name=$AGENT_NAME/g" ./Agent/bin/ucxjlx6.ini
sed -i "s/cp=cphost:2217/cp=$AE_HOST:$AE_PORT/g" ./Agent/bin/ucxjlx6.ini
sed -i "s/;root=START/root=START/g" ./Agent/bin/ucxjlx6.ini





# install service manager
mkdir -p $FOLDER/SM

cd $FOLDER
tar -zxvf ./artifacts/ucsmgrlx6.tar.gz -C ./SM

cp ./SM/bin/ucybsmgr.ori.ini ./SM/bin/ucybsmgr.ini
sed -i "s/port=8871/port=$SM_PORT/g" ./SM/bin/ucybsmgr.ini

SMC_CONTENT="CREATE UC4 $AGENT_NAME"
echo $SMC_CONTENT>>./SM/bin/uc4.smc

SMD_CONTENT="DEFINE UC4 $AGENT_NAME;$FOLDER/Agent/bin/ucxjlx6;$FOLDER/Agent/bin/"
echo $SMD_CONTENT>>./SM/bin/uc4.smd




# start service manager and agent
cd $FOLDER/SM/bin
nohup ./ucybsmgr -i./ucybsmgr.ini Automic &
sleep 5



