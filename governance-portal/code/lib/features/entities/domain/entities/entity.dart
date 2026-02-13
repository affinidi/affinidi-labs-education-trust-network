/// Entity entity
/// Represents an entity in the governance system
class Entity {
  final String id;
  final String name;
  final String did;
  final String? description;
  final Map<String, dynamic>? context;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Entity({
    required this.id,
    required this.name,
    required this.did,
    this.description,
    this.context,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create Entity from JSON
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
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

  /// Convert Entity to JSON
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
  Entity copyWith({
    String? id,
    String? name,
    String? did,
    String? description,
    Map<String, dynamic>? context,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Entity(
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

    return other is Entity &&
        other.id == id &&
        other.name == name &&
        other.did == did;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ did.hashCode;

  @override
  String toString() {
    return 'Entity(id: $id, name: $name, did: $did)';
  }
}
