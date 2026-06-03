import 'package:flutter_test/flutter_test.dart';
import 'package:jhentai/src/consts/archive_bot_consts.dart';
import 'package:jhentai/src/extension/string_extension.dart';
import 'package:jhentai/src/setting/archive_bot_setting.dart';
import 'package:jhentai/src/utils/byte_util.dart';

void main() {
  group('byte2String', () {
    test('formats byte counts without scaling below one kilobyte', () {
      expect(byte2String(512), '512.0B');
    });

    test('formats scaled units with two decimals', () {
      expect(byte2String(1024), '1.00KB');
      expect(byte2String(1024 * 1024), '1.00MB');
      expect(byte2String(1024 * 1024 * 1024), '1.00GB');
    });
  });

  group('StringExtension', () {
    test('adds zero-width break opportunities between characters', () {
      expect('ab'.breakWord, 'a\u{200B}b');
    });

    test('uses the default string when the source string is empty', () {
      expect(''.defaultIfEmpty('ab'), 'a\u{200B}b');
      expect('xy'.defaultIfEmpty('ab'), 'x\u{200B}y');
    });
  });

  group('ArchiveBotSetting', () {
    test('ehArBot uses the JHenTai proxy endpoint only when enabled', () {
      final setting = ArchiveBotSetting()
        ..botType.value = ArchiveBotType.ehArBot
        ..apiAddress.value = 'https://custom.example/eh'
        ..apiKey.value = 'key'
        ..useProxyServer.value = true;

      expect(setting.isReady, isTrue);
      expect(setting.resolvedApiAddress, ArchiveBotConsts.proxyServerAddress);

      setting.useProxyServer.value = false;

      expect(setting.isReady, isTrue);
      expect(setting.resolvedApiAddress, 'https://custom.example/eh');
    });

    test('archiveAtHome ignores the local proxy endpoint', () {
      final setting = ArchiveBotSetting()
        ..botType.value = ArchiveBotType.archiveAtHome
        ..apiAddress.value = 'https://custom.example/aah'
        ..apiKey.value = 'key'
        ..useProxyServer.value = true;

      expect(setting.isReady, isTrue);
      expect(setting.resolvedApiAddress, 'https://custom.example/aah');
    });

    test('archiveAtHome remains ready when using its default address', () {
      final setting = ArchiveBotSetting()
        ..botType.value = ArchiveBotType.archiveAtHome
        ..apiAddress.value = null
        ..apiKey.value = 'key'
        ..useProxyServer.value = true;

      expect(setting.isReady, isTrue);
      expect(
        setting.resolvedApiAddress,
        ArchiveBotConsts.defaultArchiveAtHomeServerAddress,
      );
    });

    test('requires an API key before archive bot requests are ready', () {
      final setting = ArchiveBotSetting()
        ..botType.value = ArchiveBotType.archiveAtHome
        ..apiAddress.value = null
        ..apiKey.value = null
        ..useProxyServer.value = true;

      expect(setting.isReady, isFalse);
      expect(
        setting.resolvedApiAddress,
        ArchiveBotConsts.defaultArchiveAtHomeServerAddress,
      );
    });
  });
}
