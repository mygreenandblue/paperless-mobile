#!/usr/bin/env bash
set -Eeuo pipefail

__script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

readonly __script_dir

pushd "$__script_dir/../"

pushd packages/paperless_api
../../flutter/bin/flutter packages pub get
../../flutter/bin/dart run build_runner build --delete-conflicting-outputs
popd

pushd packages/mock_server
../../flutter/bin/flutter packages pub get
popd

flutter/bin/flutter packages pub get
flutter/bin/flutter gen-l10n
flutter/bin/dart run build_runner build --delete-conflicting-outputs

popd

