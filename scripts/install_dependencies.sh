#!/bin/bash
pushd ../
pushd packages/paperless_api
flutter packages pub get
dart run build_runner build --delete-conflicting-outputs
popd
pushd packages/mock_server
flutter packages pub get
popd
flutter packages pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
