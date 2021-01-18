#!/bin/bash

# This is the directory where this binary sits in
BINARY_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Get Ecosystem Directory path from the config file
ECOSYSTEM_DIR_PATH=$(
  cd "$BINARY_DIRECTORY" || exit
  cd ..
  cat "config.properties" | grep ecosystemDir | awk -F'=' '{ print $2 }'
)

cd "$ECOSYSTEM_DIR_PATH" || exit

DIRECTORIES_IN_ECOSYSTEM_DIR=($(ls -d */ | awk -F:'/' '{ print }'))

for directoryName in "${DIRECTORIES_IN_ECOSYSTEM_DIR[@]}"; do
  cd "$directoryName" || continue
  echo "I should run the project $directoryName"
  (mvn spring-boot:run &> logs.txt &)
  cd ..
done

echo "Ecosystem up and running"
