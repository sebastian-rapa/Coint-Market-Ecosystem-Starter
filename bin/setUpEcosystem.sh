#!/bin/bash

checkRequiredResources() {
  SOME_RESOURCES_ARE_NOT_INSTALLED=0
  # Check if the system has git
  GIT_VERSION=$(git --version)
  if [[ -z $GIT_VERSION ]]; then
    echo "Git is not installed on your machine"
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi
  # Check if the system has java 15
  JAVA_VERSION=$(java --version | grep openjdk | awk '{ print $2 }')
  if [[ -z $JAVA_VERSION || ${JAVA_VERSION:0:2} -ne 15 ]]; then
    echo "Java 15 is not installed on your machine"
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi

  # Check if the system has maven
  MAVEN_VERSION=$(mvn --version)
  if [[ -z $MAVEN_VERSION ]]; then
    echo "Maven is not installed on your machine"
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi

  # Check if the system has MongoShell
  MONGO_SHELL_VERSION=$(mongo --version)
  if [[ -z $MONGO_SHELL_VERSION ]]; then
    echo "Mongo shell is not installed on your machine"
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi

  # Check if the system has MongoDB Server
  MONGO_SERVER_VERSION=$(whereis mongod | awk -F':' '{ print $2 }')
  if [[ -z $MONGO_SERVER_VERSION ]]; then
    echo "Mongo server is not installed on your machine or you need root privileges to access it."
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi
  return $SOME_RESOURCES_ARE_NOT_INSTALLED
}

# Check required resources
checkRequiredResources

if [[ $? -eq 1 ]]; then
    echo "Please install the required software then try set up again the ecosystem"
    exit 1
fi

# Download repositories
