#!/bin/bash

GIT_REPOSITORY=$1
ECOSYSTEM="Ecosystem"
PATH_TO_ECOSYSTEM_DIR="$(pwd)/Ecosystem"

checkIfAnswerIsYes() {
  answer=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  if [[ $answer == "y" || $answer == "yes" ]]; then
    # 0 = true
    return 0
  fi
  # 1 = false
  return 1
}

directoryHasGitRepository() {
  if [[ -z $1 ]]; then
    # No directory passed as argument returning false.
    # 1 = false
    return 1
  fi
  cd "$PATH_TO_ECOSYSTEM_DIR" || return 1
  echo "Current directory"
  pwd
  # Move to the directory given as First Argument
  cd "$1" || exit 1
  # Check if git repository is already downloaded
  LOCAL_GIT_REFS=$(git remote -v | grep "$GIT_REPOSITORY")
  echo "LOCAL_GIT_REFS = $LOCAL_GIT_REFS"
  if [[ -n $LOCAL_GIT_REFS ]]; then
    echo "Returning true"
    # 0 = true
    return 0
  fi
  echo "Returning false"
  # 1 = false
  return 1
}

# Move one directory up
cd ..

# Check if dir Ecosystem exists
if [[ ! -d $ECOSYSTEM ]]; then
  # Prompt message to ask for permission to create Ecosystem directory
  echo "Directory 'Ecosystem' does not exists, in order to download repositories we need to create it!"
  # Read user answer
  read -rp "Create it? [y/n] " ANSWER
  # Check if the user say yes
  checkIfAnswerIsYes "$ANSWER"
  if [[ $? ]]; then
    # Create Ecosystem directory
    echo "Creating Ecosystem directory.."
    mkdir "Ecosystem"
    echo "Done.."
  else
    # Stopping the script
    echo "Alright, stopping git repository download.."
    exit 1
  fi
fi

# Move to Ecosystem directory
cd "$ECOSYSTEM" || exit 1

# For Each directory inside the Ecosystem directory check remote git repository
DIRECTORY_LIST_IN_ECOSYSTEM_DIR=($(ls -d */ | awk -F:'/' '{ print }'))
NO_DIR_HAS_REQUIRED_REPO=1
for directoryName in "${DIRECTORY_LIST_IN_ECOSYSTEM_DIR[@]}"; do
  echo "Calling directoryHasGitRepository with the argument: $directoryName"
  directoryHasGitRepository "$directoryName"
  if [[ $? -eq 0 ]]; then
    # Current directory contains the given Repository, exit
    echo "Repository $GIT_REPOSITORY exists.."
    NO_DIR_HAS_REQUIRED_REPO=0
  fi
done

if [ $NO_DIR_HAS_REQUIRED_REPO -eq 1 ]; then
  cd "$PATH_TO_ECOSYSTEM_DIR" || exit 1
  echo "Current directory"
  pwd
  # Git repository not found
  echo "Cloning repository $GIT_REPOSITORY"
  git clone "$GIT_REPOSITORY"
fi
