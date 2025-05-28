import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/model/persistence/color_mode.dart';
import 'package:rb_share/model/persistence/favorite_device.dart';
import 'package:rb_share/model/persistence/receive_history_entry.dart';
import 'package:rb_share/model/send_mode.dart';
import 'package:rb_share/provider/persistence_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersistenceService', () {
    late SharedPreferences prefs;
    late PersistenceService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'ls_show_token': 'test-token-123',
      });
      prefs = await SharedPreferences.getInstance();
      service = PersistenceService(prefs);
    });

    test('get/set alias', () async {
      expect(service.getAlias().isNotEmpty, true);
      await service.setAlias('myAlias');
      expect(service.getAlias(), 'myAlias');
    });

    test('get/set theme', () async {
      expect(service.getTheme(), ThemeMode.system);
      await service.setTheme(ThemeMode.dark);
      expect(service.getTheme(), ThemeMode.dark);
    });

    test('get/set colorMode', () async {
      expect(service.getColorMode(), ColorMode.system);
      await service.setColorMode(ColorMode.rbshare);
      expect(service.getColorMode(), ColorMode.rbshare);
    });

    test('get/set port', () async {
      expect(service.getPort(), isA<int>());
      await service.setPort(12345);
      expect(service.getPort(), 12345);
    });

    test('get/set locale', () async {
      expect(service.getLocale(), null);
      await service.setLocale(AppLocale.ptBr);
      expect(service.getLocale(), AppLocale.ptBr);
      await service.setLocale(null);
      expect(service.getLocale(), null);
    });

    test('get/set favorites', () async {
      expect(service.getFavorites(), []);
      const fav = FavoriteDevice(id: '1', fingerprint: 'abc', ip: '1.2.3.4', port: 123, alias: 'A');
      await service.setFavorites([fav]);
      final loaded = service.getFavorites();
      expect(loaded.length, 1);
      expect(loaded.first.id, '1');
      expect(loaded.first.fingerprint, 'abc');
    });

    test('get/set receive history', () async {
      expect(service.getReceiveHistory(), []);
      final entry = ReceiveHistoryEntry(
        id: '1',
        fileName: 'file',
        fileType: FileType.image,
        path: '/tmp/file',
        savedToGallery: true,
        fileSize: 123,
        senderAlias: 'sender',
        timestamp: DateTime(2022, 1, 1),
      );
      await service.setReceiveHistory([entry]);
      final loaded = service.getReceiveHistory();
      expect(loaded.length, 1);
      expect(loaded.first.id, '1');
      expect(loaded.first.fileName, 'file');
    });

    test('get showToken', () async {
      final token = service.getShowToken();
      expect(token, 'test-token-123');
    });

    test('get/set multicastGroup', () async {
      expect(service.getMulticastGroup(), isA<String>());
      await service.setMulticastGroup('224.0.0.251');
      expect(service.getMulticastGroup(), '224.0.0.251');
    });

    test('get/set destination', () async {
      expect(service.getDestination(), null);
      await service.setDestination('myfolder');
      expect(service.getDestination(), 'myfolder');
      await service.setDestination(null);
      expect(service.getDestination(), null);
    });

    test('get/set saveToHistory', () async {
      expect(service.isSaveToHistory(), true);
      await service.setSaveToHistory(false);
      expect(service.isSaveToHistory(), false);
    });

    test('get/set quickSave', () async {
      expect(service.isQuickSave(), false);
      await service.setQuickSave(true);
      expect(service.isQuickSave(), true);
    });

    test('get/set sendMode', () async {
      expect(service.getSendMode(), SendMode.single);
      await service.setSendMode(SendMode.multiple);
      expect(service.getSendMode(), SendMode.multiple);
    });
  });
}
