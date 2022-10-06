#!/bin/bash
# owo: Use the WolframAlpha API in the terminal
# Nathan Paton <code@tchbnl.net>
# v0.1 "a"
# TODO: Add support for other APIs besides Short Answers

# Version and release date
VERSION="owo 0.1 \"a\" (Updated on 10/4/2022)"

# Help message
MSG_HELP="owo is a shell client for WolframAlpha. Here's an example:

  $ owo length of the titanic
  \"about 883 feet\"
           - Stephen Wolfram on Marriage

This client equires an API ID to work. You can create one for free at
https://products.wolframalpha.com/api/.

Right now support is limited to the Short Answers API.

USAGE: owo QUERY
  -i --id             Set API ID and exit (for now).
  -s --show           Show current API ID and exit.
  -h --help           Show this message and exit.
  -v --version        Show version information and exit."

# Please don't steal this :(
# Update: Now stored on disk below!
#API="DEMO"

# Check for our API ID. We use a file to store it.
# If .waid doesn't exist, we create it. We have checks for an empty .waid
# further down.
if [[ ! -f "${HOME}"/.waid ]]; then
  touch -a "${HOME}"/.waid
else
  API="$(cat "${HOME}"/.waid)"
fi

# For the --id command below
# Update our API ID
updateApiId() {
  echo "Current API ID: ${API}"
  read -p "Replace it? [Y/N] " -r ANSWER

  # For some case-insensitive regex
  shopt -s nocasematch
  if [[ ${ANSWER} =~ ^(Y|Yes|Please Do)$ ]]; then
    echo "${*}" > "${HOME}"/.waid
    echo "API ID has been set: ${*}"
  # TODO: Add handling for invalid responses
  else
    exit
  fi
}

# Command options
case "${1}" in
  -i|--id)
    # Make sure an ID is given
    if [[ -z ${2} ]]; then
      echo "You can't set a blank API ID."
    # Update our API ID if it already exists
    # Moved to a function because I don't feel good about cramming a bunch of
    # stuff into a case statement
    elif [[ -z "$(cat "${HOME}"/.waid)" ]]; then
      updateApiId "${2}"
    # Or set one if it doesn't
    else
      echo "${*}" > "${HOME}"/.waid
      echo "API ID has been set: ${*}"
    fi
    exit
    ;;

  -s|--show)
    # Check if there's an ID so we don't output an empty line
    if [[ -z "$(cat "${HOME}"/.waid)" ]]; then
      echo "Your API ID is in another castle. Bring it home with '-i ID'."
    else
      echo "${API}"
    fi
    exit
    ;;

  -h|--help)
    echo "${MSG_HELP}"
    exit
    ;;

  -v|--version)
    echo "${VERSION}"
    exit
    ;;

  -*)
    echo -e "Not sure what '${1}' is supposed to be.\n"
    echo "${MSG_HELP}"
    exit
    ;;
esac

# I do not apologize for this
if [[ "${*}" == "whats this" ]]; then
  echo "${MSG_HELP}"
  exit
fi

# Bail out if no API is set
# TODO: Ask user for API ID instead with link to WA
if [[ -z "$(cat "${HOME}"/.waid)" ]]; then
  echo "API ID not set. You can set one with '-i ID'."
  exit
fi

# Prompt the user for their question if one wasn't passed with the command
if [[ -z "${*}" ]]; then
  echo "WHAT WISDOM DOES THOU SEEK FROM STEPHEN WOLFRAM?"
  read -p "> " -r QUERY
else
  QUERY="${*}"
fi

# For "Stephen Wolfram on"
TOPICS=("Marriage"
        "Friendship"
        "Love"
        "Uses for WD-40"
        "Roman Cuisine"
        "CSI: Miami"
        "The Hundred Years' War")

# And get our answer (variabilized for error handling)
# We also need to fix whitespace for the URL to work
# TODO: Better regex for handling
RESPONSE="$(curl -s "https://api.wolframalpha.com/v1/result?i=$(echo "${QUERY}" | sed 's/\s/%20/g')&appid=${API}")"
# We change the error from WA here because
if echo "${RESPONSE}" | grep -iq "wolfram|alpha did not understand your input"; then
  echo "Stephen Wolfram didn't understand that request."
else
  # Display our prophet's wisdom
  echo "\"${RESPONSE}\""
  # We fetch a random topic from TOPICS
  echo -e "\t - Stephen Wolfram on ${TOPICS[$((RANDOM % ${#TOPICS[@]}))]}"
fi
