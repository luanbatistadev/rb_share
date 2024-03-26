import 'package:common/common.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'nearby_devices_state.mapper.dart';

@MappableClass()
class NearbyDevicesState with NearbyDevicesStateMappable {
  final bool runningFavoriteScan;
  final Set<String> runningIps; // list of local ips
  final Map<String, Device> devices; // ip -> device

  const NearbyDevicesState({
    required this.runningFavoriteScan,
    required this.runningIps,
    required this.devices,
  });
}
