# shellcheck shell=sh

version=$(head -n 5 pubspec.yaml | tail -n 1 | cut -d ' ' -f 2)
dest="${HOME}/Desktop/JHenTai_${version}"

flutter build linux --release -t lib/src/main.dart \
&& rm -rf "$dest" \
&& mkdir -p "$dest" \
&& cp -r build/linux/x64/release/bundle/* "$dest"/ \
&& cd "${HOME}/Desktop" \
&& zip -ro "JHenTai_${version}.zip" "JHenTai_${version}" \
&& rm -rf "$dest"
