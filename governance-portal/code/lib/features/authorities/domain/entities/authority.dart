/// Authority entity
/// Represents an authority in the governance system
class Authority {
  final String id;
  final String name;
  final String did;
  final String? description;
  final Map<String, dynamic>? context;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Authority({
    required this.id,
    required this.name,
    required this.did,
    this.description,
    this.context,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create Authority from JSON
  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      id: json['id'] as String,
      name: json['name'] as String,
      did: json['did'] as String,
      description: json['description'] as String?,
      context: json['context'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert Authority to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'did': did,
      if (description != null) 'description': description,
      if (context != null) 'context': context,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  Authority copyWith({
    String? id,
    String? name,
    String? did,
    String? description,
    Map<String, dynamic>? context,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Authority(
      id: id ?? this.id,
      name: name ?? this.name,
      did: did ?? this.did,
      description: description ?? this.description,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Authority &&
        other.id == id &&
        other.name == name &&
        other.did == did;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ did.hashCode;

  @override
  String toString() {
    return 'Authority(id: $id, name: $name, did: $did)';
  }
}
