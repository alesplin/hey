#!/bin/bash

echo "Building..."

xcodebuild -project yo.xcodeproj \
    -target yo \
    -configuration Release \
    DSTROOT=build > build.log 2>&1

if [ $? -ne 0 ]; then
    echo "Build failed."
    cat build.log
    exit 1
fi

echo "Copying app bundle to ${HOME}/bin/"
mkdir -p ${HOME}/bin
cp -r build/Release/yo.app ${HOME}/bin/

