version=$(head -n 5 pubspec.yaml | tail -n 1 | cut -d ' ' -f 2)

flutter build ios --release -t lib/src/main.dart --no-codesign \
&& sh thin-payload.sh build/ios/iphoneos/*.app \
&& rm -rf build/Payload \
&& mkdir -p build/Payload \
&& mv build/ios/iphoneos/*.app build/Payload \
&& cd build \
&& zip -ro JHenTai_${version}.ipa Payload \
&& rm -rf Payload
