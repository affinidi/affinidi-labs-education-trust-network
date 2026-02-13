/// Query input parameters
class QueryInput {
  final String entityId;
  final String authorityId;
  final String action;
  final String resource;

  const QueryInput({
    this.entityId = '',
    this.authorityId = '',
    this.action = '',
    this.resource = '',
  });

  QueryInput copyWith({
    String? entityId,
    String? authorityId,
    String? action,
    String? resource,
  }) {
    return QueryInput(
      entityId: entityId ?? this.entityId,
      authorityId: authorityId ?? this.authorityId,
      action: action ?? this.action,
      resource: resource ?? this.resource,
    );
  }

  bool get isValid =>
      entityId.isNotEmpty &&
      authorityId.isNotEmpty &&
      action.isNotEmpty &&
      resource.isNotEmpty;

  Map<String, String> toMap() {
    return {
      'entityId': entityId,
      'authorityId': authorityId,
      'action': action,
      'resource': resource,
    };
  }
}
