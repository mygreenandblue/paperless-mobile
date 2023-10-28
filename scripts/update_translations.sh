#!/usr/bin/env bash
set -Eeuo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly __script_dir

cd "$__script_dir/../"
echo "Updating source language..."
crowdin download sources --identity=crowdin_credentials.yml --preserve-hierarchy
echo "Updating translations..."
crowdin download --identity=crowdin_credentials.yml
flutter gen-l10n