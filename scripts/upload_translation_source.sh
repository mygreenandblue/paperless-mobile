#!/usr/bin/env bash
set -Eeuo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

cd "$__script_dir/../"
echo "Uploading source translation file..."
crowdin upload sources --identity=crowdin_credentials.yml --preserve-hierarchy
flutter packages pub get