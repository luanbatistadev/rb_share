import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/src/core/entities/device.dart';
import 'package:rb_share/src/core/entities/dto/info_dto.dart';
import 'package:rb_share/src/core/utils/api_route_builder.dart';
import 'package:rb_share/src/core/utils/task_runner.dart';

class NearbyIps extends ChangeNotifier {
  final Iterable<Device> nearbyDevices = [];


  void addNearbyIp(Device device) {
    nearbyDevices.(device);
    notifyListeners();
  }



  Future<void> getNearbyIps() async {
    final result = await _getIp();
    nearbyDevices.clear();
    nearbyDevices.addAll(result);
    notifyListeners();
  }

  Future<List<String>> _getIp(List<String> subnets) async {
    await Future.wait<void>([
      for (final subnet in subnets) 
    ]);
  }

  Future<void> reduce(String ip) async {
    // if (state.runningIps.contains(localIp)) {
    //   // already running for the same localIp
    //   return state;
    // }

    // dispatch(_SetRunningIpsAction({...state.runningIps, localIp}));

    await for (final device in _getStream(ip, 7077, false)) {
      addNearbyIp(device);
    }

    return state.copyWith(
      runningIps: state.runningIps.where((ip) => ip != localIp).toSet(),
    );
  }

  Stream<Device> _getStream(String networkInterface, int port, bool https) {
    final ipList = List.generate(256, (i) => '${networkInterface.split('.').take(3).join('.')}.$i')
        .where((ip) => ip != networkInterface)
        .toList();
    _runners[networkInterface]?.stop();
    _runners[networkInterface] = TaskRunner<Device?>(
      initialTasks: List.generate(
        ipList.length,
        (index) => () async => _doRequest(ipList[index], port, https),
      ),
      concurrency: 50,
    );

    return _runners[networkInterface]!.stream.where((device) => device != null).cast<Device>();
  }

  Future<Device?> _doRequest(String currentIp, int port, bool https) async {
    final device = await discover(
      ip: currentIp,
      port: port,
      https: https,
    );
    // if (device != null) {
    //   _discoveryLogs.addLog('[DISCOVER/TCP] ${device.alias} (${device.ip}, model: ${device.deviceModel})');
    // }

    return device;
  }

  Future<Device?> discover({
    required String ip,
    required int port,
    required bool https,
  }) async {
    // We use the legacy route to make it less breaking for older versions
    final url = ApiRoute.info.targetRaw(ip, port, https, '1.0');
    try {
      final response = await Dio().get(
        url,
        queryParameters: {
          // 'fingerprint': _fingerprint,
        },
      );
      final dto = InfoDto.fromMap(response.data);
      return dto.toDevice(ip, port, https);
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}

Map<String, TaskRunner> _runners = {};
