#!/bin/bash

declare -a argv
for arg in "$@"; do
	argv[${#args[*]}]="$arg"
done

if [ -f .pkg/ENV ]; then
    source .pkg/ENV
elif [ -f .pkg/actions.json ]; then
    env=$(action env)
    if [ $? -gt 0 ]; then
        echo "Has Reflex Engine been installed? https://reflex.cold.org/"
        exit 1
    fi
    eval $env
else
    echo "Missing .pkg/ENV or .pkg/actions.json... https://github.com/srevenant/docker-tools"
	DOCKER_IMAGE=$(basename $(pwd)|sed -e 's/[^a-z]*//g')
	echo "Using DOCKER_IMAGE=$DOCKER_IMAGE"
fi

if [ -z "$DOCKER_IMAGE" ]; then
    echo "No DOCKER_IMAGE defined"
    exit 1
fi

cmd() {
    printf "Execute:\n\n\t"
    space_rx="\s"
    for arg in "$@"; do
        if [[ $arg =~ $space_rx ]]; then
            echo -n ' "'$arg'"'
        else
            echo -n " $arg"
        fi
    done
    printf "\n\n"
    "$@"
}

