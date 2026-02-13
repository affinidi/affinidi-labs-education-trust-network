/// Query result
class QueryResult {
  final bool recognized;
  final bool authorized;
  final DateTime timestamp;
  final Map<String, dynamic>? rawResponse;

  const QueryResult({
    required this.recognized,
    required this.authorized,
    required this.timestamp,
    this.rawResponse,
  });

  factory QueryResult.fromResponse(Map<String, dynamic> response) {
    return QueryResult(
      recognized: response['recognized'] as bool? ?? false,
      authorized: response['authorized'] as bool? ?? false,
      timestamp: DateTime.now(),
      rawResponse: response,
    );
  }
}
