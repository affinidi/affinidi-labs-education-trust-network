/// Trust Record entity
/// Represents a trust record in the Trust Registry
class TrustRecord {
  final String entityId;
  final String authorityId;
  final String action;
  final String resource;
  final bool recognized;
  final bool authorized;
  final Map<String, dynamic>? context;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TrustRecord({
    required this.entityId,
    required this.authorityId,
    required this.action,
    required this.resource,
    required this.recognized,
    required this.authorized,
    this.context,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated fields
  TrustRecord copyWith({
    String? entityId,
    String? authorityId,
    String? action,
    String? resource,
    bool? recognized,
    bool? authorized,
    Map<String, dynamic>? context,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrustRecord(
      entityId: entityId ?? this.entityId,
      authorityId: authorityId ?? this.authorityId,
      action: action ?? this.action,
      resource: resource ?? this.resource,
      recognized: recognized ?? this.recognized,
      authorized: authorized ?? this.authorized,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get composite key for the record
  String get compositeKey => '$entityId:$authorityId:$action:$resource';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrustRecord &&
        other.entityId == entityId &&
        other.authorityId == authorityId &&
        other.action == action &&
        other.resource == resource;
  }

  @override
  int get hashCode {
    return entityId.hashCode ^
        authorityId.hashCode ^
        action.hashCode ^
        resource.hashCode;
  }

  @override
  String toString() {
    return 'TrustRecord(entityId: $entityId, authorityId: $authorityId, action: $action, resource: $resource, recognized: $recognized, authorized: $authorized)';
  }
}
