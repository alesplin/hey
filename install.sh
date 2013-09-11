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
if [ ! -d "${HOME}/bin" ]; then
    mkdir -p ${HOME}/bin
fi
cp -r build/Release/yo.app ${HOME}/bin/

if [ $# -gt 0 ]; then
    if [ "$1" = "--test" ]; then
        eval "${HOME}/bin/yo.app/Contents/MacOS/yo +2m 'foo'"
    fi
fi

