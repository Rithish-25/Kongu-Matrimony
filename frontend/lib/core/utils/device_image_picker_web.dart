// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/material.dart';

Future<void> pickImageFromDeviceImpl({
  required BuildContext context,
  required Function(String imageUrl) onImagePicked,
  bool isCamera = false,
}) async {
  try {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    if (isCamera) {
      uploadInput.setAttribute('capture', 'camera');
    }
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          final result = reader.result as String?;
          if (result != null && result.isNotEmpty) {
            onImagePicked(result);
          }
        });
      }
    });
  } catch (e) {
    debugPrint('Error picking device image: $e');
  }
}

Future<void> pickFileFromDeviceImpl({
  required BuildContext context,
  required Function(String fileName, String? fileDataUrl) onFilePicked,
  String accept = '.pdf,image/*,.jpg,.jpeg,.png',
}) async {
  try {
    final uploadInput = html.FileUploadInputElement()..accept = accept;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        onFilePicked(file.name, null);
      }
    });
  } catch (e) {
    debugPrint('Error picking device file: $e');
  }
}

