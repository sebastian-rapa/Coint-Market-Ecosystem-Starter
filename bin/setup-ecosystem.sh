#!/bin/bash

# This is the directory where this binary sits in
BINARY_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Get Ecosystem Directory path from the config file
ECOSYSTEM_DIR_PATH=$(
  cd "$BINARY_DIRECTORY" || exit
  cd ..
  grep ecosystemDir "config.properties" | awk -F'=' '{ print $2 }'
)

# Get Producer Repository Link
PRODUCER_REPO=$(
  cd "$BINARY_DIRECTORY" || exit
  cd ..
  grep producerRepo "config.properties" | awk -F'=' '{ print $2 }'
)

# Get Consumer Repository Link
CONSUMER_REPO=$(
  cd "$BINARY_DIRECTORY" || exit
  cd ..
  grep consumerRepo "config.properties" | awk -F'=' '{ print $2 }'
)

checkRequiredResources() {
  SOME_RESOURCES_ARE_NOT_INSTALLED=0
  # Check if the system has git
  GIT_VERSION=$(git --version)
  if [[ -z $GIT_VERSION ]]; then
    echo "Git is not installed on your machine"
    SOME_RESOURCES_ARE_NOT_INSTALLED=1
  fi
  # Check if the system has java 11
  JAVA_VERSION=$(java --version | grep openjdk | awk '{ print $2 }')
  if [[ -z $JAVA_VERSION || ${JAVA_VERSION:0:2} -ne 11 ]]; then
    echo "Java 11 is not installed on your machine"
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

checkIfAnswerIsYes() {
  answer=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  if [[ $answer == "y" || $answer == "yes" ]]; then
    # 0 = true
    return 0
  fi
  # 1 = false
  return 1
}

createEcosystemDirIfNeeded() {
  # Check if dir Ecosystem exists
  if [[ ! -d $ECOSYSTEM_DIR_PATH ]]; then
    # Prompt message to ask for permission to create Ecosystem directory
    echo "Directory 'Ecosystem' does not exists, in order to download repositories we need to create it!"
    # Read user answer
    read -rp "Create it? [y/n] " ANSWER
    # Check if the user say yes
    checkIfAnswerIsYes "$ANSWER"
    if [[ $? -eq 0 ]]; then
      # Create Ecosystem directory
      echo "Creating Ecosystem directory.."
      mkdir "$ECOSYSTEM_DIR_PATH"
      echo "Done.."
    else
      # Stopping the script
      echo "Alright, stopping setup.."
      return 1
    fi
  fi
}

downloadRepository() {

  GIT_REPOSITORY=$1

  directoryHasGitRepository() {
    if [[ -z $1 ]]; then
      # No directory passed as argument returning false.
      # 1 = false
      return 1
    fi
    cd "$ECOSYSTEM_DIR_PATH" || return 1
    # Move to the directory given as First Argument
    cd "$1" || return 1
    # Check if git repository is already downloaded
    LOCAL_GIT_REFS=$(git remote -v | grep "$GIT_REPOSITORY")
    if [[ -n $LOCAL_GIT_REFS ]]; then
      # 0 = true
      return 0
    fi
    # 1 = false
    return 1
  }

  # Move to Ecosystem directory
  cd "$ECOSYSTEM_DIR_PATH" || exit 1

  # For Each directory inside the Ecosystem directory check remote git repository
  DIRECTORIES_IN_ECOSYSTEM_DIR=($(ls -d */ | awk -F:'/' '{ print }'))
  NO_DIR_HAS_REQUIRED_REPO=1
  for directoryName in "${DIRECTORIES_IN_ECOSYSTEM_DIR[@]}"; do
    directoryHasGitRepository "$directoryName"
    if [[ $? -eq 0 ]]; then
      # Current directory contains the given Repository, exit
      NO_DIR_HAS_REQUIRED_REPO=0
      break
    fi
  done

  if [[ $NO_DIR_HAS_REQUIRED_REPO -eq 1 ]]; then
    cd "$ECOSYSTEM_DIR_PATH" || exit 1
    # Git repository not found
    echo "Cloning repository $GIT_REPOSITORY"
    git clone "$GIT_REPOSITORY"
  fi

}

# Check required resources
checkRequiredResources

if [[ $? -eq 1 ]]; then
  echo "Please install the required software then try set up again the ecosystem"
  exit 1
fi

# Check if ecosystem directory exists
createEcosystemDirIfNeeded
if [[ $? -eq 1 ]]; then
  exit 1
fi

# Download repositories
downloadRepository "$PRODUCER_REPO"
if [ $? -eq 1 ]; then
  echo "Something went wrong while downloading $PRODUCER_REPO"
  exit 1
fi

downloadRepository "$CONSUMER_REPO"
if [ $? -eq 1 ]; then
  echo "Something went wrong while downloading $CONSUMER_REPO"
  exit 1
fi

echo "Done set up!"
