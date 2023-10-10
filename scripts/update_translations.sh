#!/usr/bin/env bash
set -Eeuo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

echo "Updating source language..."
crowdin download sources --identity=../crowdin_credentials.yml --config ../crowdin.yml --preserve-hierarchy
echo "Updating translations..."
crowdin download --identity=../crowdin_credentials.yml --config ../crowdin.yml
pushd "$__script_dir/../"
flutter gen-l10n
popd