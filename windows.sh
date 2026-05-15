# shellcheck shell=sh

version=$(head -n 5 pubspec.yaml | tail -n 1 | cut -d ' ' -f 2)
dest="${HOME}/Desktop/JHenTai_${version}_windows"

flutter build windows --release -t lib/src/main.dart \
&& rm -rf "$dest" \
&& mkdir -p "$dest" \
&& cp -r build/windows/x64/runner/Release/* "$dest"/ \
&& cd "${HOME}/Desktop" \
&& zip -ro "JHenTai_${version}_windows.zip" "JHenTai_${version}_windows" \
&& rm -rf "$dest"
