#!/bin/bash
pushd ../
pushd packages/paperless_api
flutter pub get
dart run build_runner build --delete-conflicting-outputs
popd
flutter packages pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
