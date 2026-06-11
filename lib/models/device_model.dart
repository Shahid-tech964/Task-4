import 'package:flutter/material.dart';

enum DeviceType {
  mobilePhone,
  laptop,
  television,
  cup,
  bicycle,
}

class DeviceModel {
  const DeviceModel({
    required this.type,
    required this.displayName,
    required this.keywords,
    required this.emoji,
    required this.color,
  });

  final DeviceType type;
  final String displayName;
  final List<String> keywords;
  final String emoji;
  final Color color;

  static const List<DeviceModel> allDevices = [
    DeviceModel(
      type: DeviceType.mobilePhone,
      displayName: 'Mobile Phone',
      keywords: ['phone', 'mobile phone', 'smartphone', 'cell phone'],
      emoji: '📱',
      color: Color(0xFF7E57C2),
    ),
    DeviceModel(
      type: DeviceType.laptop,
      displayName: 'Laptop',
      keywords: ['laptop', 'notebook computer', 'computer'],
      emoji: '💻',
      color: Color(0xFF42A5F5),
    ),
    DeviceModel(
      type: DeviceType.television,
      displayName: 'Television',
      keywords: ['television', 'tv', 'monitor', 'display device'],
      emoji: '📺',
      color: Color(0xFF5C6BC0),
    ),
    DeviceModel(
      type: DeviceType.cup,
      displayName: 'Cup',
      keywords: ['cup', 'mug', 'coffee cup'],
      emoji: '☕',
      color: Color(0xFFFF7043),
    ),
    DeviceModel(
      type: DeviceType.bicycle,
      displayName: 'Bicycle',
      keywords: ['bicycle', 'bike', 'cycle'],
      emoji: '🚲',
      color: Color(0xFF26A69A),
    ),
  ];

  static DeviceModel? fromType(DeviceType type) {
    for (final device in allDevices) {
      if (device.type == type) return device;
    }
    return null;
  }
}
