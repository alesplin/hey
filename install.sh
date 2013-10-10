#!/bin/zsh

echo "Building..."

while [[ $# -gt 0 ]]; do
    if [[ $1 = "-d" || $1 = "--debug" ]]; then
        DEBUG=1
    elif [[ $1 = "-t" || $1 = "--test" ]]; then
        TEST=1
    else
        print "Unrecognized option: '$1'"
    fi
    shift
done

if [ -n "$DEBUG" ]; then
    config=Debug
else
    config=Release
fi

xcodebuild -project yo.xcodeproj \
    -target yo \
    -configuration $config \
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

echo "Creating tarball for toolsweb..."
cd build/Release && tar -cvzf ../../yo_app.tgz yo.app

if [ -n "$TEST" ]; then
    eval "${HOME}/bin/yo.app/Contents/MacOS/yo +2m 'foo'"
    eval "${HOME}/bin/yo.app/Contents/MacOS/yo 'test message only'"
fi

