#!/usr/bin/env bash
set -e

source ~/.bash_profile

IMAGE="unidata/ramadda-docker:latest"

cd ~/science-gateway/vms/ramadda

# make sure the container is running already
docker-compose up -d

docker pull $IMAGE

CID=$(docker ps | grep $IMAGE | awk '{print $1}')

for im in $CID
do
    LATEST=`docker inspect --format "{{.Id}}" $IMAGE`
    RUNNING=`docker inspect --format "{{.Image}}" $im`
    NAME=`docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    # echo "Latest:" $LATEST
    # echo "Running:" $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
        # echo "upgrading $NAME"
        docker stop $(docker ps -qa) && docker system prune -a -f
        docker-compose up -d
    fi
    # else
    #     echo "$NAME up to date"
    # fi
done
