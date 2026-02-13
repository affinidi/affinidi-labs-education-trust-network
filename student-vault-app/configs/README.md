# Organizations Configuration

## Overview

Organizations (universities) configuration is now managed via a JSON file located at `configs/organizations.json`. This allows dynamic configuration updates without requiring code changes.

## File Location

```
student-vault-app/
├── configs/
│   ├── organizations.json      # Runtime organizations config
│   ├── google-services.json    # Firebase config (Android)
│   └── GoogleService-Info.plist # Firebase config (iOS)
```

## Configuration Format

```json
{
  "universities": [
    {
      "did": "did:web:example.com:hongkong-university",
      "website": "https://example.com",
      "name": "Hong Kong University"
    },
    {
      "did": "did:web:example.com:macau-university",
      "website": "https://example.com",
      "name": "Macau University"
    }
  ]
}
```

## Automatic Updates

The `organizations.json` file is automatically updated during setup:

```bash\n# From project root, run the main setup\nmake dev-up\n# Updates configs/organizations.json with ngrok domains\n```

## Usage in Code

Organizations are loaded asynchronously via a Riverpod provider:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_vault_app/core/infrastructure/providers/organizations_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationsAsync = ref.watch(organizationsProvider);
    
    return organizationsAsync.when(
      data: (orgsConfig) {
        // Access universities list
        final universities = orgsConfig.universities;
        
        // Find specific university
        final hkUniversity = universities.firstWhere(
          (org) => org.name.contains('Hong Kong'),
          orElse: () => null,
        );
        
        return Text(hkUniversity?.name ?? 'Unknown');
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## Migration Notes

### Previous Approach (Deprecated)

Previously, organizations were defined in Dart code:

```dart
// OLD - lib/core/infrastructure/repositories/organizations_repository/organizations.dart
class Organizations {
  static const universities = [
    (did: '...', website: '...', name: '...'),
  ];
}
```

This required different Dart files for different environments and code changes to update configuration.

### New Approach (Current)

Now uses a single JSON file that's automatically updated by setup scripts:

- Single source of truth: `configs/organizations.json`
- No code changes needed for configuration updates
- Environment-specific configs generated automatically
- Loaded asynchronously via Riverpod provider

## See Also

- [OrganizationsConfig class](../code/lib/core/infrastructure/config/organizations_config.dart)
- [Organizations provider](../code/lib/core/infrastructure/providers/organizations_provider.dart)
- [Setup scripts](../../deployment/scripts/)
