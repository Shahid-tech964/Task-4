import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

import '../models/device_model.dart';

/// A single label returned by ML Kit with its confidence score.
class ImageLabelResult {
  const ImageLabelResult({
    required this.label,
    required this.confidence,
  });

  final String label;
  final double confidence;
}

class MlKitService {
  MlKitService() : _labeler = ImageLabeler(options: ImageLabelerOptions());

  final ImageLabeler _labeler;

  /// Analyzes an image and logs every label with its confidence score.
  /// Check logcat / debug console for lines prefixed with [ML Kit].
  Future<List<ImageLabelResult>> analyzeImage(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final labels = await _labeler.processImage(inputImage);

    debugPrint('══════════════════════════════════════════════════');
    debugPrint('[ML Kit] Image labeling results (${labels.length} labels):');
    if (labels.isEmpty) {
      debugPrint('[ML Kit]   (no labels returned)');
    } else {
      for (final label in labels) {
        final pct = (label.confidence * 100).toStringAsFixed(1);
        debugPrint(
          '[ML Kit]   "${label.label}" → confidence: $pct% (${label.confidence.toStringAsFixed(4)})',
        );
      }
    }
    debugPrint('══════════════════════════════════════════════════');

    return labels
        .map(
          (label) => ImageLabelResult(
            label: label.label,
            confidence: label.confidence,
          ),
        )
        .toList();
  }

  /// Backward-compatible helper that returns label strings only.
  Future<List<String>> getLabelsFromFile(String filePath) async {
    final results = await analyzeImage(filePath);
    return results.map((result) => result.label).toList();
  }

  /// Matches ML Kit labels against target objects (case-insensitive).
  /// Returns the first matched [DeviceModel], or null if no match.
  DeviceModel? matchDevice(List<ImageLabelResult> results) {
    if (results.isEmpty) {
      debugPrint('[ML Kit Match] No labels to match.');
      return null;
    }

    for (final device in DeviceModel.allDevices) {
      for (final keyword in device.keywords) {
        for (final result in results) {
          final label = result.label.toLowerCase().trim();
          if (_labelMatchesKeyword(label, keyword.toLowerCase())) {
            debugPrint(
              '[ML Kit Match] "${result.label}" (${(result.confidence * 100).toStringAsFixed(1)}%) '
              '→ ${device.displayName} via keyword "$keyword"',
            );
            return device;
          }
        }
      }
    }

    debugPrint('[ML Kit Match] No target object matched.');
    return null;
  }

  /// Convenience overload for callers that only have label strings.
  DeviceModel? matchDeviceFromStrings(List<String> labels) {
    return matchDevice(
      labels.map((label) => ImageLabelResult(label: label, confidence: 0)).toList(),
    );
  }

  bool _labelMatchesKeyword(String label, String keyword) {
    if (label == keyword) return true;

    if (keyword == 'phone') {
      return _labelMatchesPhone(label);
    }

    if (keyword == 'tv') {
      return label == 'tv' ||
          label.contains('television') ||
          label == 'monitor' ||
          label.contains('flat screen');
    }

    if (keyword == 'display device') {
      return label.contains('display device') ||
          (label.contains('display') && label.contains('device'));
    }

    if (keyword == 'bicycle' || keyword == 'bike' || keyword == 'cycle') {
      return _labelMatchesBicycle(label);
    }

    if (keyword == 'cup' || keyword == 'mug' || keyword == 'coffee cup') {
      return _labelMatchesCup(label);
    }

    // Partial, case-insensitive match for remaining keywords (laptop, computer, etc.).
    return label.contains(keyword);
  }

  bool _labelMatchesPhone(String label) {
    if (label == 'phone') return true;
    if (label.contains('mobile phone')) return true;
    if (label.contains('smartphone')) return true;
    if (label.contains('cell phone')) return true;
    if (label.contains('cellphone')) return true;
    // Avoid false positives such as "Microphone" or "Headphone".
    if (label.contains('phone') &&
        !label.contains('microphone') &&
        !label.contains('headphone') &&
        !label.contains('earphone')) {
      return true;
    }
    return false;
  }

  bool _labelMatchesBicycle(String label) {
    if (label == 'bicycle') return true;
    if (label == 'bike') return true;
    if (label == 'cycle') return true;
    if (label.contains('bicycle')) return true;
    if (label.contains('bike')) return true;
    if (label.contains('cycle')) return true;
    return false;
  }

  bool _labelMatchesCup(String label) {
    if (label == 'cup') return true;
    if (label.contains('coffee cup')) return true;
    if (label.contains('mug')) return true;
    if (label.contains('cup') && !label.contains('cupboard')) return true;
    return false;
  }

  Future<void> dispose() async {
    await _labeler.close();
  }
}
