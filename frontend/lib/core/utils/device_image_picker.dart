import 'package:flutter/material.dart';

import 'device_image_picker_stub.dart'
    if (dart.library.html) 'device_image_picker_web.dart';

abstract class DeviceImagePicker {
  static Future<void> pickImageFromDevice({
    required BuildContext context,
    required Function(String imageUrl) onImagePicked,
    bool isCamera = false,
  }) {
    return pickImageFromDeviceImpl(
      context: context,
      onImagePicked: onImagePicked,
      isCamera: isCamera,
    );
  }

  static Future<void> pickFileFromDevice({
    required BuildContext context,
    required Function(String fileName, String? fileDataUrl) onFilePicked,
    String accept = '.pdf,image/*,.jpg,.jpeg,.png',
  }) {
    return pickFileFromDeviceImpl(
      context: context,
      onFilePicked: onFilePicked,
      accept: accept,
    );
  }
}

