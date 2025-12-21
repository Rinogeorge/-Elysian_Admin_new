import 'package:elysian_admin/core/error/failures.dart';

/// Base class for validation failures
abstract class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Field is empty when it shouldn't be
class EmptyFieldFailure extends ValidationFailure {
  const EmptyFieldFailure(String fieldName)
    : super('$fieldName cannot be empty');
}

/// Field length constraints violated
class InvalidLengthFailure extends ValidationFailure {
  const InvalidLengthFailure(String fieldName, int min, int max)
    : super('$fieldName must be between $min and $max characters');
}

/// Field format/pattern mismatch
class InvalidFormatFailure extends ValidationFailure {
  const InvalidFormatFailure(String fieldName, String reason)
    : super('$fieldName has invalid format: $reason');
}

/// File doesn't exist or wrong type
class InvalidFileFailure extends ValidationFailure {
  const InvalidFileFailure(String reason) : super('Invalid file: $reason');
}
