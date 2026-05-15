# shellcheck shell=sh

version=$(head -n 5 pubspec.yaml | tail -n 1 | cut -d ' ' -f 2)
dest="build/windows/JHenTai_${version}"

flutter build windows --release -t lib/src/main.dart \
&& rm -rf "$dest" \
&& mkdir -p "$dest" \
&& cp -r build/windows/x64/runner/Release/* "$dest"/ \
&& cd build/windows \
&& zip -ro "JHenTai_${version}_Windows.zip" "JHenTai_${version}" \
&& cd ../.. \
&& rm -rf "$dest"
