import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/validation/validation_failure.dart';

/// Abstract base class for input validators
abstract class InputValidator<T> {
  Either<ValidationFailure, T> validate(T input);
}

/// Validates category names
class CategoryNameValidator implements InputValidator<String> {
  static const int minLength = 2;
  static const int maxLength = 50;

  // Regex to allow letters, numbers, spaces, and common punctuation
  static final RegExp _validPattern = RegExp(r'^[a-zA-Z0-9\s\-_&.,()]+$');

  @override
  Either<ValidationFailure, String> validate(String input) {
    // Check if empty or only whitespace
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Left(EmptyFieldFailure('Category name'));
    }

    // Check length
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      return const Left(
        InvalidLengthFailure('Category name', minLength, maxLength),
      );
    }

    // Check format
    if (!_validPattern.hasMatch(trimmed)) {
      return const Left(
        InvalidFormatFailure(
          'Category name',
          'Only letters, numbers, spaces, and common punctuation allowed',
        ),
      );
    }

    return Right(trimmed);
  }
}

/// Validates image paths
class ImagePathValidator implements InputValidator<String> {
  static const List<String> validExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.gif',
  ];

  @override
  Either<ValidationFailure, String> validate(String input) {
    // Check if empty
    if (input.trim().isEmpty) {
      return const Left(EmptyFieldFailure('Image'));
    }

    // Check if file exists
    final file = File(input);
    if (!file.existsSync()) {
      return const Left(InvalidFileFailure('File does not exist'));
    }

    // Check file extension
    final extension = input.toLowerCase().substring(input.lastIndexOf('.'));
    if (!validExtensions.contains(extension)) {
      return Left(
        InvalidFileFailure(
          'Invalid file type. Allowed: ${validExtensions.join(", ")}',
        ),
      );
    }

    // Check file size (max 10MB)
    final fileSize = file.lengthSync();
    const maxSize = 10 * 1024 * 1024; // 10MB in bytes
    if (fileSize > maxSize) {
      return const Left(InvalidFileFailure('File size must be less than 10MB'));
    }

    return Right(input);
  }
}
