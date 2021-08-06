#!/bin/bash

## Required env vars:

# BUMPVERSION_TOKEN: personal access token
# BUMPVERSION_AUTHOR: personal access token author
# BUMPVERSION_EMAIL: personal access token author's registered email
# GITHUB_REPOSITORY: repository this action runs on


# Ensure that when any step of this script fails, the entire job will fail as well
set -eo pipefail

REPOSITORY_URI="https://${BUMPVERSION_AUTHOR}:${BUMPVERSION_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git clone "${REPOSITORY_URI}"

cd "$(ls)" || exit

git config --global user.email "${BUMPVERSION_EMAIL}"
git config --global user.name "Clinical Genomics Bot"

# Fetching the commit message for the latest commit to branch this action is applied to
COMMIT_MSG=$(git log -1 --pretty=%B|sed 's/\r$//g'|sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\\\n/g')

# Parsing version update increment from commit message
if [[ $COMMIT_MSG == *'(major)'* ]]; then
  VERSION='major'
elif [[ $COMMIT_MSG == *'(minor)'* ]]; then
  VERSION='minor'
else
  VERSION='patch'
fi

# Run bump2version
bump2version --config-file .bumpversion.cfg "${VERSION}"

git push "${REPOSITORY_URI}"
git push "${REPOSITORY_URI}" --tags

# Pull from branch again to update latest tag
git pull

# Get the value of latest tag that was just pushed
NEW_TAG="$(git describe)"

# Construct post JSON for publishing release
POST_DATA=$(echo -e {\"tag_name\": \"$NEW_TAG\", \"name\": \"Release $NEW_TAG\", \"draft\": false, \"prerelease\": false, \"body\": \""${COMMIT_MSG}"\"})

echo "Submitting release for ${NEW_TAG}"

curl \
  -X POST \
  -H "Authorization: token ${BUMPVERSION_TOKEN}" \
  -d "${POST_DATA}" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

