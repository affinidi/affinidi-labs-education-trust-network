import '../../domain/entities/trust_record.dart';

/// Data model for Trust Record
/// Used for serialization/deserialization with DIDComm responses
class TrustRecordModel extends TrustRecord {
  const TrustRecordModel({
    required super.entityId,
    required super.authorityId,
    required super.action,
    required super.resource,
    required super.recognized,
    required super.authorized,
    super.context,
    super.createdAt,
    super.updatedAt,
  });

  /// Create from JSON
  factory TrustRecordModel.fromJson(Map<String, dynamic> json) {
    return TrustRecordModel(
      entityId:
          json['entity_id'] as String? ?? json['entityId'] as String? ?? '',
      authorityId: json['authority_id'] as String? ??
          json['authorityId'] as String? ??
          '',
      action: json['action'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      recognized: json['recognized'] as bool? ?? false,
      authorized: json['authorized'] as bool? ?? false,
      context: json['context'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'entity_id': entityId,
      'authority_id': authorityId,
      'action': action,
      'resource': resource,
      'recognized': recognized,
      'authorized': authorized,
      if (context != null) 'context': context,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Convert to domain entity
  TrustRecord toEntity() {
    return TrustRecord(
      entityId: entityId,
      authorityId: authorityId,
      action: action,
      resource: resource,
      recognized: recognized,
      authorized: authorized,
      context: context,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  factory TrustRecordModel.fromEntity(TrustRecord entity) {
    return TrustRecordModel(
      entityId: entity.entityId,
      authorityId: entity.authorityId,
      action: entity.action,
      resource: entity.resource,
      recognized: entity.recognized,
      authorized: entity.authorized,
      context: entity.context,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  TrustRecordModel copyWith({
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
    return TrustRecordModel(
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
}
