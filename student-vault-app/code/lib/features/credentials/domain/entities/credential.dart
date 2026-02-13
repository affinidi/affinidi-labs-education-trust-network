class Credential {
  const Credential({
    required this.id,
    required this.type,
    required this.issuer,
    required this.issuanceDate,
    required this.credentialSubject,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      id: json['id'] as String,
      type: json['type'] as String,
      issuer: json['issuer'] as String,
      issuanceDate: DateTime.parse(json['issuanceDate'] as String),
      credentialSubject: json['credentialSubject'] as Map<String, dynamic>,
    );
  }
  final String id;
  final String type;
  final String issuer;
  final DateTime issuanceDate;
  final Map<String, dynamic> credentialSubject;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'issuer': issuer,
      'issuanceDate': issuanceDate.toIso8601String(),
      'credentialSubject': credentialSubject,
    };
  }
}
