#!/bin/bash

## Required env vars:

# GITHUB_TOKEN: github-actions workflow native token
# GITHUB_ACTOR: github-actions workflow native user (github-actions[bot])
# GITHUB_REPOSITORY: repository this action runs on

# INPUT_RELEASE_PAT: Personal Access Token of the github user who will author the release

# Ensure that when any step of this script fails, the entire job will fail as well
set -eo pipefail

REPOSITORY_URI="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git clone "${REPOSITORY_URI}"

cd "$(ls)" || exit

# Fetching the commit message for the latest commit to branch this action is applied to
COMMIT_MSG=$(git log -1 --pretty=%B)

# Parsing version update increment from commit message
if [[ $COMMIT_MSG == *'major'* ]]; then
  VERSION='major'
elif [[ $COMMIT_MSG == *'minor'* ]]; then
  VERSION='minor'
else
  VERSION='patch'
fi

# Configure email of the github user to the one of the github-actions bot
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "Github CI"

# Run bump2version
bump2version --config-file .bumpversion.cfg "${VERSION}"
git push "${REPOSITORY_URI}"
git push "${REPOSITORY_URI}" --tags

# Pull from branch again to update latest tag
git pull

# Get the value of latest tag that was just pushed
NEW_TAG="$(git describe)"

# Construct post JSON for publishing release
POST_DATA=$(echo {\"tag_name\": \"$NEW_TAG\", \"name\": \"Release $NEW_TAG\", \"draft\": false, \"prerelease\": false, \"body\": \"$COMMIT_MSG\"})

echo "Submitting release for ${NEW_TAG}"

curl \
  -X POST \
  -H "Authorization: token ${INPUT_RELEASE_PAT}" \
  -d "${POST_DATA}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"
