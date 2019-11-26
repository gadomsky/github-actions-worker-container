#!/bin/bash

TOKEN=$2

function cleanup {
  echo "Cleaniung up worker"
  ./config.sh remove --token $TOKEN
}

trap cleanup EXIT

echo -ne "\n\n" |  ./config.sh --url $1 --token $TOKEN
./run.sh