import 'dart:convert';

import 'package:flagsmith/flagsmith.dart';

class RemoteConfigService {
  static const _apikey = '';

  static late final FlagsmithClient _flagsmithClient;

  static late final String link;
  static late final String privacyLink;
  static late final String termsLink;
  static late final bool usePrivacy;

  static Future<void> init() async {
    try {
      _flagsmithClient = await FlagsmithClient.init(
        apiKey: _apikey,
        config: const FlagsmithConfig(caches: true),
      );
      await _flagsmithClient.getFeatureFlags();

      final config = jsonDecode(
        await _flagsmithClient.getFeatureFlagValue(ConfigKey.config.name) ?? '',
      ) as Map<String, dynamic>;

      link = config[ConfigKey.link.name] as String;
      usePrivacy = config[ConfigKey.usePrivacy.name] as bool;
      privacyLink = config[ConfigKey.privacyLink.name] as String;
      termsLink = config[ConfigKey.termsLink.name] as String;
    } catch (e) {
      usePrivacy = true;
      link = '';
      privacyLink = '';
      termsLink = '';
    }
  }

  static void closeClient() => _flagsmithClient.close();
}

enum ConfigKey {
  config,
  link,
  usePrivacy,
  privacyLink,
  termsLink,
}
