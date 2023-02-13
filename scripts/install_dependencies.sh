#!/bin/bash
# Uses flutter submodule dependency
git submodules update --init
pushd ../
pushd packages/paperless_api
../../flutter/bin/flutter pub get
../../flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs
popd
flutter/bin/flutter pub get
flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs
flutter/bin/flutter pub run intl_utils:generate
