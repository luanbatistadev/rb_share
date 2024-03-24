import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart' as plugin;

class LocalIpsController extends ChangeNotifier {
  final List<String> _localIps = [];

  List<String> get localIps => _localIps;

  void addLocalIp(String ip) {
    _localIps.add(ip);
    notifyListeners();
  }

  void removeLocalIp(String ip) {
    _localIps.remove(ip);
    notifyListeners();
  }

  Future<void> getLocalIps() async{
    final result = await _getIp();
    _localIps.clear();
    _localIps.addAll(result);
    notifyListeners();
  }

  Future<List<String>> _getIp() async {
    final info = plugin.NetworkInfo();
    String? ip;
    try {
      ip = await info.getWifiIP();
    } catch (e) {
      log('Failed to get wifi IP', error: e);
    }

    List<String> nativeResult = [];
    if (!kIsWeb) {
      try {
        // fallback with dart:io NetworkInterface
        final result = (await NetworkInterface.list())
            .map((networkInterface) => networkInterface.addresses)
            .expand((ip) => ip);
        nativeResult = result
            .where((ip) => ip.type == InternetAddressType.IPv4)
            .map((address) => address.address)
            .toList();
      } catch (e, st) {
        log('Failed to get IP from dart:io', error: e, stackTrace: st);
      }
    }

    final addresses = rankIpAddresses(nativeResult, ip);
    log('Network state: $addresses');
    return addresses;
  }

  List<String> rankIpAddresses(List<String> nativeResult, String? thirdPartyResult) {
    if (thirdPartyResult == null) {
      // only take the list
      return nativeResult._rankIpAddresses(null);
    } else if (nativeResult.isEmpty) {
      // only take the first IP from third party library
      return [thirdPartyResult];
    } else if (thirdPartyResult.endsWith('.1')) {
      // merge
      return {thirdPartyResult, ...nativeResult}.toList()._rankIpAddresses(null);
    } else {
      // merge but prefer result from third party library
      return {thirdPartyResult, ...nativeResult}.toList()._rankIpAddresses(thirdPartyResult);
    }
  }
  
}
extension ListIpExt on List<String> {
  List<String> _rankIpAddresses(String? primary) {
    return sorted((a, b) {
      int scoreA = a == primary ? 10 : (a.endsWith('.1') ? 0 : 1);
      int scoreB = b == primary ? 10 : (b.endsWith('.1') ? 0 : 1);
      return scoreB.compareTo(scoreA);
    });
  }
}