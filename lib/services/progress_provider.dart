import 'package:flutter/foundation.dart';

import '../models/device_model.dart';

class ProgressProvider extends ChangeNotifier {
  final Set<DeviceType> _foundDevices = {};

  Set<DeviceType> get foundDevices => Set.unmodifiable(_foundDevices);

  int get foundCount => _foundDevices.length;

  bool get allFound => _foundDevices.length >= DeviceModel.allDevices.length;

  bool isFound(DeviceType type) => _foundDevices.contains(type);

  bool markFound(DeviceType type) {
    if (_foundDevices.contains(type)) {
      return false;
    }
    _foundDevices.add(type);
    notifyListeners();
    return true;
  }

  void reset() {
    _foundDevices.clear();
    notifyListeners();
  }
}
