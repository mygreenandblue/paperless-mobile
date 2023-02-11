#!/bin/bash
pushd packages/paperless_api
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
popd
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run intl_utils:generate