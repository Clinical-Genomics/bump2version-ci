#!/bin/bash

set -o pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"
echo "${REPOSITORY}"
VERSION="patch"
REPOSITORY_NAME=$(echo "${INPUT_REPOSITORY}"|rev|cut -f 1 -d '/'|rev|cut -d '.' -f 1)
echo "${REPOSITORY_NAME}"

git clone "${REPOSITORY}"
cd "${REPOSITORY_NAME}" || exit
bump2version "${VERSION}"
git push
git push --tags





