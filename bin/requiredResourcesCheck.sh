#!/bin/bash

# Check if the system has git
GIT_VERSION=$(git --version)
if [[ -z $GIT_VERSION ]]; then
  echo "Git is not installed on your machine"
fi
# Check if the system has java 15
JAVA_VERSION=$(java --version | grep openjdk | awk '{ print $2 }')
if [[ -z $JAVA_VERSION || ${JAVA_VERSION:0:2} -ne 15 ]]; then
  echo "Java 15 is not installed on your machine"
fi

# Check if the system has maven

# Check if the system has MongoDB
