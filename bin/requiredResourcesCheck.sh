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
MAVEN_VERSION=$(mvn --version)
if [[ -z $MAVEN_VERSION ]]; then
  echo "Maven is not installed on your machine"
fi

# Check if the system has MongoShell
MONGO_SHELL_VERSION=$(mongo --version)
if [[ -z $MONGO_SHELL_VERSION ]]; then
  echo "Mongo shell is not installed on your machine"
fi

# Check if the system has MongoDB Server
MONGO_SERVER_VERSION=$(mongod --version)
if [[ -z $MONGO_SERVER_VERSION ]]; then
  echo "Mongo server is not installed on your machine or you need root privilliges to access it."
fi
