#!/usr/bin/env bash
set -Euo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

pushd "$__script_dir/../"

for dir in packages/*/     # list directories in the form "/tmp/dirname/"
do
    pushd $dir
    echo "Installing dependencies for $dir"
    flutter packages pub get
    dart run build_runner build --delete-conflicting-outputs 
    popd
done

flutter packages pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs