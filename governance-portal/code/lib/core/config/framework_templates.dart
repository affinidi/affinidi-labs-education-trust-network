/// Trust Framework Templates
///
/// Defines predefined framework templates with suggested authorities,
/// entities, and resource types for onboarding.

import 'package:flutter/material.dart';

class TrustFrameworkTemplate {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> suggestedAuthorities;
  final List<String> suggestedEntities;
  final List<String> suggestedResources;
  final List<String> suggestedActions;

  const TrustFrameworkTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.suggestedAuthorities,
    required this.suggestedEntities,
    required this.suggestedResources,
    required this.suggestedActions,
  });
}

class FrameworkTemplates {
  static const List<TrustFrameworkTemplate> templates = [
    TrustFrameworkTemplate(
      id: 'education',
      name: 'Education',
      description:
          'Manage educational credentials, degrees, and certifications',
      icon: Icons.school,
      suggestedAuthorities: [
        'Ministry of Education',
        'Education Bureau',
        'National Education Authority',
      ],
      suggestedEntities: [
        'University of Hong Kong',
        'Hong Kong Polytechnic University',
        'City University of Hong Kong',
      ],
      suggestedResources: [
        'Degree Certificate',
        'Academic Transcript',
        'Professional Certificate',
        'Diploma',
        'Course Completion Certificate',
      ],
      suggestedActions: ['Issue', 'Verify', 'Revoke'],
    ),
    TrustFrameworkTemplate(
      id: 'finance',
      name: 'Finance KYC',
      description: 'Know Your Customer and financial identity verification',
      icon: Icons.account_balance,
      suggestedAuthorities: [
        'Financial Services Authority',
        'Banking Regulatory Commission',
        'Securities Commission',
      ],
      suggestedEntities: [
        'HSBC Bank',
        'Standard Chartered',
        'Bank of China',
      ],
      suggestedResources: [
        'KYC Certificate',
        'Credit Report',
        'Identity Verification',
        'AML Clearance',
        'Accredited Investor Status',
      ],
      suggestedActions: ['Issue', 'Verify', 'Revoke'],
    ),
    TrustFrameworkTemplate(
      id: 'ai_agent',
      name: 'AI Agent Access',
      description: 'Authorization and access control for AI agents',
      icon: Icons.smart_toy,
      suggestedAuthorities: [
        'AI Governance Board',
        'Technology Authority',
        'Data Protection Authority',
      ],
      suggestedEntities: [
        'OpenAI',
        'Anthropic',
        'Google AI',
      ],
      suggestedResources: [
        'API Access Token',
        'Data Access Permission',
        'Model Usage License',
        'Agent Authorization',
        'Capability Certificate',
      ],
      suggestedActions: ['Issue', 'Verify', 'Revoke'],
    ),
    TrustFrameworkTemplate(
      id: 'custom',
      name: 'Custom',
      description: 'Build your own custom trust framework from scratch',
      icon: Icons.settings,
      suggestedAuthorities: [],
      suggestedEntities: [],
      suggestedResources: [],
      suggestedActions: ['Issue', 'Verify', 'Revoke'],
    ),
  ];

  static TrustFrameworkTemplate? getById(String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static TrustFrameworkTemplate get education => templates[0];
  static TrustFrameworkTemplate get finance => templates[1];
  static TrustFrameworkTemplate get aiAgent => templates[2];
  static TrustFrameworkTemplate get custom => templates[3];
}
