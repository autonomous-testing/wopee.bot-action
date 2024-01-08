#!/bin/bash

if [ -z ${IMAGE+x} ]; then
    echo "Warning: IMAGE not set, using default"
    export IMAGE=ghcr.io/autonomous-testing/wopee.bot:dev
fi
echo "IMAGE: $IMAGE"

if [ -z ${CONTAINER_NAME+x} ]; then
    echo "Warning: CONTAINER_NAME not set, using default"
    export CONTAINER_NAME=wopee-runner
fi
echo "CONTAINER_NAME: $CONTAINER_NAME"

if [ -z ${WORKING_DIRECTORY+x} ]; then
    echo "Warning: WORKING_DIRECTORY not set, using default"
    export WORKING_DIRECTORY=wopee-runner
fi
echo "WORKING_DIRECTORY: $WORKING_DIRECTORY"

if ! [ -f $ENV_FILE ] || [ "$ENV_FILE" == "" ]; then
    echo "Warning: File '$ENV_FILE' does not exist."
    echo "ENV_FILE_NOT_SET=true" > .env_file_not_set.env
    export ENV_FILE=.env_file_not_set.env
else
    echo "File '$ENV_FILE' exists localy and will be used."
fi
echo "ENV_FILE: $ENV_FILE"

if [ -z ${SECCOMP_PROFILE+x} ]; then
    echo "Warning: SECCOMP_PROFILE not set, using default"
    export SECCOMP_PROFILE=seccomp_profile.json
fi
echo "SECCOMP_PROFILE: $SECCOMP_PROFILE"

docker ps -q --filter "name=$CONTAINER_NAME" | grep -q . && docker stop $CONTAINER_NAME

docker pull ${IMAGE}

docker run --rm \
    --name $CONTAINER_NAME \
    --env-file <(env | sed '/^PATH=/d;/^HOME=/d;/^USER=/d;/^_=/d') \
    --env-file $ENV_FILE \
    --workdir /home/$WORKING_DIRECTORY \
    --ipc=host \
    --network=host \
    --security-opt seccomp=$SECCOMP_PROFILE \
    ${IMAGE}

# when user is not root add working dir volume to store outputs
#    --volume $(pwd)/$WORKING_DIRECTORY:/home/$WORKING_DIRECTORY \