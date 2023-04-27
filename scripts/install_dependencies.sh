#!/bin/bash
pushd ../
pushd packages/paperless_api
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
popd
flutter packages pub get
flutter gen-l10n
flutter pub run build_runner build --delete-conflicting-outputs
