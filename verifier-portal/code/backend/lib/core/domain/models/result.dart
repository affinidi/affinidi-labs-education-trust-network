/// A result type for handling success and failure cases
class Result<T> {
  final T? _data;
  final Exception? _error;

  const Result._(this._data, this._error);

  /// Create a successful result
  factory Result.success(T data) => Result._(data, null);

  /// Create a failure result
  factory Result.failure(Exception error) => Result._(null, error);

  /// Check if the result is successful
  bool get isSuccess => _error == null;

  /// Check if the result is a failure
  bool get isFailure => _error != null;

  /// Get the data (throws if failure)
  T get data {
    if (_error != null) throw _error;
    return _data as T;
  }

  /// Get the error (throws if success)
  Exception get error {
    if (_error == null) {
      throw Exception('Result is successful, no error available');
    }
    return _error;
  }

  /// Pattern matching for result
  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  }) {
    if (isSuccess) {
      return success(_data as T);
    } else {
      return failure(_error!);
    }
  }

  /// Map the success value
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform(_data as T));
      } catch (e) {
        return Result.failure(Exception('Transform error: $e'));
      }
    }
    return Result.failure(_error!);
  }
}
