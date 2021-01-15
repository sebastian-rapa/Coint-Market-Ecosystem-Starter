#!/bin/bash

GIT_REPOSITORY=$1

checkIfAnswerIsYes() {
  answer=$(tr '[:upper:]' '[:lower:]' $1)
  if [[ $answer == "y" ||  $answer == "yes" ]]; then
    # 0 = true
    return 0
  fi
  # 1 = false
  return 1
}

# Move one directory up
cd .. 

# Check if dir Ecosystem exists
ECOSYSTEM="Ecosystem"
if [[ -d $ECOSYSTEM ]]; then
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
cd "$ECOSYSTEM" || exit

# Check if git repository is already downloaded
git ls-remote --refs |
if [[ $? ]]; then
    # Found git repository
fi


git clone GIT_REPOSITORY