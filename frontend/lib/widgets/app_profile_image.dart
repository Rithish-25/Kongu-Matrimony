import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AppProfileImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;

  const AppProfileImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.width,
    this.height,
  });

  static ImageProvider provider(String url) {
    if (url.startsWith('data:image')) {
      try {
        final base64Str = url.split(',').last;
        return MemoryImage(base64Decode(base64Str));
      } catch (_) {}
    }
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    if (!kIsWeb && (url.startsWith('/') || url.contains(':\\') || url.startsWith('file:'))) {
      try {
        final path = url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
        final file = io.File(path);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } catch (_) {}
    }
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64Str = imageUrl.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      } catch (_) {}
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (!kIsWeb && (imageUrl.startsWith('/') || imageUrl.contains(':\\') || imageUrl.startsWith('file:'))) {
      try {
        final path = imageUrl.startsWith('file://') ? imageUrl.replaceFirst('file://', '') : imageUrl;
        final file = io.File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            errorBuilder: (context, error, stackTrace) => _buildFallback(),
          );
        }
      } catch (_) {}
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }
}

