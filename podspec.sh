#!/bin/bash

if [[ -z $1 || -z $2 || $1 = "-h" || $1 = "-help" ]]; then
    echo "usage:
    podspec.sh <project> <version>"
    exit 0
fi

echo
echo "### base"
repo="baijiahulian-app-specs"
spec="$1"
version="$2"
echo "repo: $repo"
echo "spec: $spec"
echo "version: $version"
read -p "press [enter] to continue, or [control+c] to abort"

# echo
# echo ### lint
# pod spec lint $spec.podspec
# pod spec lint $spec.podspec --sources=$repo,gitcafe-akuandev-specs --verbose
# if [[ $? != 0 ]]; then
#     echo
#     echo "!!! lint failed" 1>&2
#     exit 2
# fi

echo
echo "### json"
jsonfile="$spec.podspec.json"
pod ipc spec "$spec.podspec" > "$jsonfile"
if [[ $? != 0 ]]; then
    echo
    echo "!!! json failed" 1>&2
    exit 3
fi
# pod repo push $repo "$jsonfile" --verbose
echo "jsonfile: $jsonfile"
# cat "$jsonfile"

echo
echo "### file"
gitdir=~/.cocoapods/repos/$repo
versiondir="$gitdir/$spec/$version"
echo "gitdir: $gitdir/"
echo "versiondir: $versiondir/"
mkdir -p "$versiondir/" && cp "$jsonfile" "$versiondir/" && pushd "$gitdir/" > /dev/null
if [[ $? != 0 ]]; then
    echo
    echo "!!! file failed" 1>&2
    exit 4
fi

echo
echo "### git"
git pull && git add "$spec/" && git commit -m "$spec-$version" && git push
if [[ $? != 0 ]]; then
    echo
    echo "!!! git failed" 1>&2
    exit 5
fi

popd > /dev/null
