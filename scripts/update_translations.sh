#!/bin/bash
echo "Updating source language..."
crowdin download sources --identity=../crowdin_credentials.yml --config ../crowdin.yml --preserve-hierarchy
echo "Updating translations..."
crowdin download --identity=../crowdin_credentials.yml --config ../crowdin.yml
pushd ..
flutter gen-l10n
popd