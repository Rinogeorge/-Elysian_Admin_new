import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

class CloudinaryService {
  static const String cloudName = 'de1t3n0hi';
  static const String uploadPreset = 'Elysian';
  static const String baseUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads an image to Cloudinary
  ///
  /// [imagePath] - Local file path of the image
  /// [folder] - Optional folder name in Cloudinary (based on category name)
  /// Returns the secure URL of the uploaded image
  Future<String> uploadImage({
    required String imagePath,
    String? folder,
  }) async {
    if (kDebugMode) {
      print('[CloudinaryService] Starting image upload: $imagePath');
    }

    if (imagePath.isEmpty) {
      final error = 'Image path cannot be empty';
      print('[CloudinaryService] ERROR: $error');
      throw Exception(error);
    }

    final file = File(imagePath);
    if (!await file.exists()) {
      final error = 'Image file does not exist at path: $imagePath';
      print('[CloudinaryService] ERROR: $error');
      throw Exception(error);
    }

    // Check if file is readable
    try {
      final fileSize = await file.length();
      print('[CloudinaryService] File size: $fileSize bytes');
    } catch (e) {
      final error = 'Cannot read image file: ${e.toString()}';
      print('[CloudinaryService] ERROR: $error');
      throw Exception(error);
    }

    // Try different preset name variations
    final presetVariations = [
      uploadPreset, // Original: 'Elysian'
      uploadPreset.toLowerCase(), // 'elysian'
      uploadPreset.toUpperCase(), // 'ELYSIAN'
    ];

    print(
      '[CloudinaryService] Will try preset variations: ${presetVariations.join(", ")}',
    );
    Exception? lastException;

    for (final preset in presetVariations) {
      try {
        print('[CloudinaryService] Trying preset: $preset');
        final imageUrl = await _uploadWithPreset(
          file: file,
          preset: preset,
          folder: folder,
        );
        print('[CloudinaryService] Upload successful: $imageUrl');
        return imageUrl;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        print(
          '[CloudinaryService] Upload failed with preset "$preset": ${e.toString()}',
        );
        // If it's not a preset error, don't try other variations
        if (!e.toString().toLowerCase().contains('preset') &&
            !e.toString().toLowerCase().contains('upload')) {
          print(
            '[CloudinaryService] ERROR: Non-preset error encountered, stopping retry',
          );
          rethrow;
        }
        // Continue to next variation
      }
    }

    // If all variations failed, throw the last exception with helpful message
    final errorMessage =
        'Failed to upload image to Cloudinary. Tried preset variations: ${presetVariations.join(", ")}. '
        'Error: ${lastException?.toString() ?? "Unknown error"}. '
        'Please verify that an upload preset exists in your Cloudinary dashboard and is set to "Unsigned" mode.';
    print('[CloudinaryService] ERROR: All preset variations failed');
    print('[CloudinaryService] ERROR Details: $errorMessage');
    throw Exception(errorMessage);
  }

  /// Internal method to upload with a specific preset
  Future<String> _uploadWithPreset({
    required File file,
    required String preset,
    String? folder,
  }) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      // Add upload preset
      request.fields['upload_preset'] = preset;

      // Add folder if provided
      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      // Add file - use cross-platform path handling
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      String filename = path.basename(file.path);

      // Sanitize filename: remove double extensions like .jpg.jpg
      if (filename.toLowerCase().endsWith('.jpg.jpg')) {
        filename = filename.substring(0, filename.length - 4);
      }

      // Determine content type
      // Note: explicit content type helps Cloudinary in some cases
      // We'll simplisticly check extension as we don't have mime package linked for sure
      // but http package uses http_parser internally usually.

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: filename,
      );
      request.files.add(multipartFile);

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Upload timeout: Request took too long');
        },
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final imageUrl = responseData['secure_url'] as String?;
        if (imageUrl != null) {
          return imageUrl;
        } else {
          throw Exception('Failed to get image URL from Cloudinary response');
        }
      } else {
        // Parse Cloudinary error response for better error messages
        String errorMessage = 'Cloudinary upload failed';
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map<String, dynamic>) {
            final message = errorData['error']?['message'] as String?;
            if (message != null) {
              errorMessage = message;
            } else {
              errorMessage = errorData['error']?.toString() ?? errorMessage;
            }
          }
        } catch (_) {
          // If parsing fails, use the raw response
          errorMessage =
              response.body.isNotEmpty
                  ? response.body
                  : 'Status ${response.statusCode}';
        }

        throw Exception(
          'Cloudinary upload failed with preset "$preset": $errorMessage',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to upload image to Cloudinary: ${e.toString()}');
    }
  }

  /// Deletes an image from Cloudinary
  /// Note: This requires the public_id of the image
  /// For unsigned uploads with preset, deletion might not be straightforward
  /// This is a placeholder for future implementation if needed
  Future<void> deleteImage(String publicId) async {
    // Cloudinary deletion requires authentication and public_id
    // This would need additional implementation with API key and secret
    // For now, we'll skip deletion as unsigned uploads don't easily support deletion
    throw UnimplementedError(
      'Image deletion from Cloudinary requires API key and secret',
    );
  }
}
