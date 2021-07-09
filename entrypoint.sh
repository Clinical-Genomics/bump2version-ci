#!/bin/bash

set -o pipefail

REPOSITORY=$1
REPOSITORY="https://github.com/Clinical-Genomics/bump2version-ci.git"
VERSION="patch"
REPOSITORY_NAME=$(echo "${REPOSITORY}"|rev|cut -f 1 -d '/'|rev|cut -d '.' -f 1)


git clone "${REPOSITORY}"
cd "${REPOSITORY_NAME}" || exit
bump2version "${VERSION}"
git push
git push --tags





