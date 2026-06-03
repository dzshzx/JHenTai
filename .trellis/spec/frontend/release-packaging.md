# Release Packaging

> Platform release artifact rules for this Flutter project.

---

## Authoritative Entry Points

Use `.github/workflows/build_publish.yml` as the source of truth for CI release packaging. Local helper scripts may exist for developer convenience, but they must stay compatible with the CI commands and output layout.

All Flutter release builds use:

```bash
flutter build <platform> --release -t lib/src/main.dart
```

`lib/src/main.dart` is the app entrypoint. Do not use Flutter's default `lib/main.dart` entrypoint for release or validation builds.

Debug APKs are only for dependency and build-chain validation. Do not publish `app-debug.apk`; it contains debug runtime assets, multiple ABI libraries, and validation layers that make it much larger than release artifacts.

## Triggers

- Pushes to `master` build all configured platform artifacts and upload them as workflow artifacts.
- Tags matching `v*` build all configured platform artifacts, publish them to the GitHub Release, and update `altsource/AltSource.json` for the iOS unsigned IPA.
- Changes under `fastlane/**` are validated by `.github/workflows/fastlane.yml`; that workflow does not build app binaries.

## Shared Release Inputs

- Flutter toolchain: `3.41.9` on the `stable` channel.
- App version: `pubspec.yaml` `version`.
- Entrypoint: `lib/src/main.dart`.
- GitHub release notes: `changelog/<tag>.md`, where `<tag>` is the pushed tag name.
- API secret: CI writes `lib/src/config/jh_api_secret_config.dart` from `JH_API_SECRET_CONFIG`.

## Android

CI target: `Android`.

Build command:

```bash
flutter build apk -t lib/src/main.dart --release --split-per-abi
```

Expected outputs in `build/app/outputs/apk/release/`:

- `JHenTai-<version>-arm64-v8a.apk`
- `JHenTai-<version>-armeabi-v7a.apk`
- `JHenTai-<version>-x64.apk`

Required files and inputs:

- `android/app/build.gradle` owns package id, SDK values, and release signing config.
- `android/key.properties.sample` documents the release signing properties.
- CI secrets `ENCODED_KEYSTORE` and `KEY_PROPERTIES` create `android/app/upload-keystore.jks` and `android/key.properties`.
- `android/settings.gradle` and `android/build.gradle` must stay compatible with the CI Android build.

Do not publish a universal debug APK. The release artifact policy is split-per-ABI APKs.

## iOS

CI target: `iOS`.

Build command:

```bash
flutter build ios -t lib/src/main.dart --release --no-codesign
```

Packaging steps:

1. Run `thin-payload.sh build/ios/iphoneos/*.app` to thin native binaries to `arm64`, strip bitcode, and strip symbols for unsigned sideload packaging.
2. Move the `.app` into `build/Payload`.
3. Zip `Payload` into `build/JHenTai_<version>.ipa`.

The IPA is intentionally unsigned and is distributed for AltStore, SideLoadly, or similar sideload signing tools. Minimum iOS version is `13.0`.

## macOS

CI target: `macOS`.

Packaging entrypoint:

```bash
sh dmg.sh
```

`dmg.sh` runs:

```bash
flutter build macos --release -t lib/src/main.dart
```

Then it uses `create-dmg` to produce `JHenTai-<version>.dmg` from `build/macos/Build/Products/Release/jhentai.app`. Minimum macOS version is `10.15`. README currently marks macOS as not maintained; keep that user-facing expectation unless product support changes.

## Windows

CI target: `Windows`.

Build command:

```bash
flutter build windows --release -t lib/src/main.dart
```

Package `build/windows/x64/runner/Release` into:

```text
build/windows/JHenTai_<version>_Windows.zip
```

The local `windows.sh` helper must use the same release mode and `build/windows/x64/runner/Release` source directory as CI.

## Linux

CI targets:

- `Linux-x64-deb`
- `Linux-arm64-deb`

Build command:

```bash
flutter build linux --release -t lib/src/main.dart
```

Package the Flutter bundle under `/opt/jhentai` and build a Debian package with `dpkg-deb --build --root-owner-group`.

Required files:

- `linux/assets/DEBIAN/control`
- `linux/assets/DEBIAN/postinst`
- `linux/assets/DEBIAN/postrm`
- `linux/assets/top.jtmonster.jhentai.desktop`
- `assets/icon/JHenTai_512.png`

CI rewrites `Version:` in `DEBIAN/control` from `pubspec.yaml`. For arm64 runners, CI rewrites `Architecture:` to `arm64`; otherwise it remains `amd64`.

`Linux-x64-AppImage` and `linux/assets/AppImageBuilder.yml` exist, but the AppImage matrix entry is currently disabled. Do not treat AppImage as a published artifact unless the workflow matrix is explicitly re-enabled and the release upload artifact list is updated.

## Release Upload

Tag builds publish these assets:

- `/tmp/artifacts/release-Android/*.apk`
- `/tmp/artifacts/release-iOS/*.ipa`
- `/tmp/artifacts/release-macOS/*.dmg`
- `/tmp/artifacts/release-Windows/*.zip`
- `/tmp/artifacts/release-Linux-x64-deb/*.deb`
- `/tmp/artifacts/release-Linux-arm64-deb/*.deb`

If a platform is added, removed, renamed, or disabled in the build matrix, update both the artifact upload step and the release upload list in the same change.
