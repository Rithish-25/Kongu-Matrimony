import 'dart:convert';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImageFromDeviceImpl({
  required BuildContext context,
  required Function(String imageUrl) onImagePicked,
  bool isCamera = false,
}) async {
  try {
    final picker = ImagePicker();
    final source = isCamera ? ImageSource.camera : ImageSource.gallery;
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      final String extension = file.name.split('.').last.toLowerCase();
      final String mimeType = (extension == 'png')
          ? 'image/png'
          : (extension == 'webp')
              ? 'image/webp'
              : 'image/jpeg';
      final String base64Data = base64Encode(bytes);
      final String dataUrl = 'data:$mimeType;base64,$base64Data';
      onImagePicked(dataUrl);
    }
  } catch (e) {
    debugPrint('Error picking image on mobile: $e');
  }
}

Future<void> pickFileFromDeviceImpl({
  required BuildContext context,
  required Function(String fileName, String? fileDataUrl) onFilePicked,
  String accept = '.pdf,image/*,.jpg,.jpeg,.png',
}) async {
  try {
    final files = await FilePickerPlatform.instance.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (files.isNotEmpty) {
      final file = files.first;
      onFilePicked(file.name, file.path);
    }
  } catch (e) {
    debugPrint('Error picking file on mobile: $e');
  }
}



