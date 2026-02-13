import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Organization {
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      did: json['did'] as String,
      website: json['website'] as String,
      name: json['name'] as String,
    );
  }

  const Organization({
    required this.did,
    required this.website,
    required this.name,
  });
  final String did;
  final String website;
  final String name;

  Map<String, dynamic> toJson() {
    return {'did': did, 'website': website, 'name': name};
  }
}

class OrganizationsConfig {
  factory OrganizationsConfig.fromJson(Map<String, dynamic> json) {
    return OrganizationsConfig(
      universities: (json['universities'] as List<dynamic>)
          .map((e) => Organization.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  const OrganizationsConfig({required this.universities});
  final List<Organization> universities;

  static Future<OrganizationsConfig> load() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/organizations.json',
      );
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return OrganizationsConfig.fromJson(jsonData);
    } catch (e) {
      debugPrint('Error loading organizations.json: $e');
      // Return empty config as fallback
      return const OrganizationsConfig(universities: []);
    }
  }
}
