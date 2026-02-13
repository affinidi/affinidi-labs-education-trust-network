/// Exception classes for error handling
/// Use try-catch blocks instead of Result<T, E> pattern

/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error occurred']);
}

class DIDCommException extends AppException {
  const DIDCommException([super.message = 'DIDComm operation failed']);
}

class CredentialVerificationException extends AppException {
  const CredentialVerificationException([
    super.message = 'Credential verification failed',
  ]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

class UnexpectedException extends AppException {
  const UnexpectedException([super.message = 'An unexpected error occurred']);
}
