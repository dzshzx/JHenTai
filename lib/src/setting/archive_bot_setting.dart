import 'dart:convert';

import 'package:get/get.dart';
import 'package:jhentai/src/enum/config_enum.dart';
import 'package:jhentai/src/service/log.dart';

import '../consts/archive_bot_consts.dart';
import '../model/archive_bot_response/archive_resolve_vo.dart';
import '../model/archive_bot_response/balance_vo.dart';
import '../model/archive_bot_response/check_in_vo.dart';
import '../service/jh_service.dart';

ArchiveBotSetting archiveBotSetting = ArchiveBotSetting();

enum ArchiveBotType {
  ehArBot(0),
  archiveAtHome(1);

  final int code;

  const ArchiveBotType(this.code);

  String get defaultServerAddress {
    switch (this) {
      case ArchiveBotType.ehArBot:
        return ArchiveBotConsts.defaultEhArBotServerAddress;
      case ArchiveBotType.archiveAtHome:
        return ArchiveBotConsts.defaultArchiveAtHomeServerAddress;
    }
  }

  BalanceVO parseBalance(Map<String, dynamic> data) {
    switch (this) {
      case ArchiveBotType.ehArBot:
        return BalanceVO.fromEhArBotResponse(data);
      case ArchiveBotType.archiveAtHome:
        return BalanceVO.fromArchiveAtHomeResponse(data);
    }
  }

  CheckInVO parseCheckIn(Map<String, dynamic> data) {
    switch (this) {
      case ArchiveBotType.ehArBot:
        return CheckInVO.fromEhArBotResponse(data);
      case ArchiveBotType.archiveAtHome:
        return CheckInVO.fromArchiveAtHomeResponse(data);
    }
  }

  ArchiveResolveVO parseResolve(Map<String, dynamic> data) {
    switch (this) {
      case ArchiveBotType.ehArBot:
        return ArchiveResolveVO.fromEhArBotResponse(data);
      case ArchiveBotType.archiveAtHome:
        return ArchiveResolveVO.fromArchiveAtHomeResponse(data);
    }
  }

  static ArchiveBotType fromCode(int code) {
    return ArchiveBotType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ArchiveBotType.ehArBot,
    );
  }
}

class ArchiveBotSetting
    with JHLifeCircleBeanWithConfigStorage
    implements JHLifeCircleBean {
  final Rx<ArchiveBotType> botType = ArchiveBotType.ehArBot.obs;

  /// Only used when botType == ehArBot
  final RxnString apiAddress = RxnString(
    ArchiveBotConsts.defaultEhArBotServerAddress,
  );

  final RxnString apiKey = RxnString(null);

  final RxBool useProxyServer = false.obs;

  bool get isReady =>
      apiKey.value != null &&
      (apiAddress.value != null ||
          (botType.value == ArchiveBotType.ehArBot && useProxyServer.isTrue));

  String get resolvedApiAddress {
    if (botType.value == ArchiveBotType.ehArBot && useProxyServer.isTrue) {
      return ArchiveBotConsts.proxyServerAddress;
    }
    return apiAddress.value ?? botType.value.defaultServerAddress;
  }

  @override
  ConfigEnum get configEnum => ConfigEnum.archiveBotSetting;

  @override
  void applyBeanConfig(String configString) {
    Map map = jsonDecode(configString);
    apiKey.value = map['apiKey'];

    if (map['botType'] != null) {
      botType.value = ArchiveBotType.fromCode(map['botType'] as int);
    }

    apiAddress.value = map['apiAddress'] ?? apiAddress.value;
    useProxyServer.value = map['useProxyServer'] ?? true;
  }

  @override
  String toConfigString() {
    return jsonEncode({
      'botType': botType.value.code,
      'apiAddress': apiAddress.value,
      'apiKey': apiKey.value,
      'useProxyServer': useProxyServer.value,
    });
  }

  @override
  Future<void> doInitBean() async {}

  @override
  void doAfterBeanReady() {}

  Future<void> saveConfig({
    required ArchiveBotType type,
    String? address,
    String? key,
    bool useProxy = false,
  }) async {
    log.debug(
      'saveConfig: type=$type, address=$address, key=$key, useProxy=$useProxy',
    );
    botType.value = type;
    apiAddress.value = address;
    apiKey.value = key;
    useProxyServer.value = type == ArchiveBotType.ehArBot && useProxy;
    await saveBeanConfig();
  }

  Future<void> saveApiAddress(String? value) async {
    log.debug('saveApiAddress: $value');
    apiAddress.value = value;
    await saveBeanConfig();
  }

  Future<void> saveApiKey(String? value) async {
    log.debug('saveApiKey: $value');
    apiKey.value = value;
    await saveBeanConfig();
  }

  Future<void> saveUseProxyServer(bool value) async {
    log.debug('saveUseProxyServer: $value');
    useProxyServer.value = value;
    await saveBeanConfig();
  }
}
