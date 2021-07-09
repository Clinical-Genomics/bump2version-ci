#!/bin/bash

set -o pipefail

REPOSITORY="https://github.com/${GITHUB_REPOSITORY}.git"
echo "Cloning ${REPOSITORY}"
VERSION="patch"

git clone "${REPOSITORY}"
cd "$(ls)" || exit

bump2version --config-file .bumpversion.cfg "${VERSION}"
git push https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git push https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git --tags





