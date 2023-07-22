#!/bin/bash
set -e

ADDONS_DIR=$PWD/addons
ADDONS_REPO_DIR=$PWD/addon_repos
ADDONS_CSV_FILE=$PWD/addon_repos.csv

mkdir -p $ADDONS_DIR
mkdir -p $ADDONS_REPO_DIR
cd $ADDONS_REPO_DIR

skip_headers=1
while IFS=, read -r GIT_REPO GIT_BRANCH GIT_DIR COPY_BLOBS; do
    if ((skip_headers)); then ((skip_headers--)); continue; fi

    cd $ADDONS_REPO_DIR
    echo "Pulling addons from $GIT_DIR"
    [ -d $GIT_DIR ] || git clone $GIT_REPO $GIT_DIR
    cd $GIT_DIR
    git checkout $GIT_BRANCH
    git pull origin $GIT_BRANCH

    echo "Copying addons from $GIT_DIR"
    for glob in $COPY_BLOBS; do
        cp -r $glob $ADDONS_DIR
    done
    echo "Copy completed\n"
done < $ADDONS_CSV_FILE
