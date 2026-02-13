/// Exception classes for Trust Registry operations
/// Use try-catch blocks instead of Result<T, E> pattern

/// Base class for all Trust Registry exceptions
abstract class TrustRegistryException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const TrustRegistryException(this.message, {this.code, this.details});

  @override
  String toString() =>
      'TrustRegistryException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends TrustRegistryException {
  const NetworkException([
    super.message = 'Network error occurred',
  ]);
}

/// DIDComm-related exceptions
class DIDCommException extends TrustRegistryException {
  const DIDCommException([
    super.message = 'DIDComm operation failed',
  ]);
}

/// Record operation exceptions
class RecordException extends TrustRegistryException {
  const RecordException([
    super.message = 'Record operation failed',
  ]);
}

/// Query operation exceptions
class QueryException extends TrustRegistryException {
  const QueryException([
    super.message = 'Query operation failed',
  ]);
}

/// Configuration exceptions
class ConfigException extends TrustRegistryException {
  const ConfigException([
    super.message = 'Configuration error',
  ]);
}

/// Timeout exceptions
class TimeoutException extends TrustRegistryException {
  const TimeoutException([
    super.message = 'Operation timed out',
  ]);
}

/// Not found exceptions
class NotFoundException extends TrustRegistryException {
  const NotFoundException([
    super.message = 'Resource not found',
  ]);
}

/// Validation exceptions
class ValidationException extends TrustRegistryException {
  const ValidationException([
    super.message = 'Validation failed',
  ]);
}
