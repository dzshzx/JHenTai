# shellcheck shell=sh

version=$(head -n 5 pubspec.yaml | tail -n 1 | cut -d ' ' -f 2)
arch=$(uname -m)

case "$arch" in
  x86_64|amd64)
    runner_arch="x64"
    deb_arch="amd64"
    ;;
  aarch64|arm64)
    runner_arch="arm64"
    deb_arch="arm64"
    ;;
  *)
    echo "Unsupported Linux architecture: $arch"
    exit 1
    ;;
esac

pkg_dir="build/linux/JHenTai-${version}-Linux-${runner_arch}"

flutter build linux --release -t lib/src/main.dart \
&& rm -rf "$pkg_dir" \
&& mkdir -p "$pkg_dir/opt/jhentai" \
&& mkdir -p "$pkg_dir/usr/share/applications" \
&& mkdir -p "$pkg_dir/usr/share/icons/hicolor/512x512/apps" \
&& cp -r "build/linux/${runner_arch}/release/bundle/"* "$pkg_dir/opt/jhentai" \
&& cp -r linux/assets/DEBIAN "$pkg_dir" \
&& chmod 0755 "$pkg_dir/DEBIAN/postinst" \
&& chmod 0755 "$pkg_dir/DEBIAN/postrm" \
&& cp linux/assets/top.jtmonster.jhentai.desktop "$pkg_dir/usr/share/applications" \
&& cp assets/icon/JHenTai_512.png "$pkg_dir/usr/share/icons/hicolor/512x512/apps/top.jtmonster.jhentai.png" \
&& sed -i "/^Version: /s/Version: .*/Version: ${version}/" "$pkg_dir/DEBIAN/control" \
&& sed -i "/^Architecture: /s/Architecture: .*/Architecture: ${deb_arch}/" "$pkg_dir/DEBIAN/control" \
&& dpkg-deb --build --root-owner-group "$pkg_dir"
