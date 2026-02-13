# Development Guide

## Architecture Patterns

### Flutter Apps: Clean Architecture

```
presentation/  # UI, Riverpod providers
domain/        # Entities, use cases, repository interfaces
data/          # Repository implementations, data sources, models
core/          # Shared utilities, config
```

**Rules:**
- Domain layer has zero external dependencies
- Dependencies point inward only
- Use repository pattern for data access
- State management: Riverpod

### Backend Services: MVC Pattern

```
controllers/   # HTTP request handlers
services/      # Business logic
models/        # Data structures
middleware/    # Cross-cutting concerns
```

## Code Standards

### Dart/Flutter

**File Organization:**
- One class per file
- File name matches class name in snake_case
- Group imports: dart → flutter → packages → relative

**Naming:**
- Classes: PascalCase
- Functions/variables: camelCase
- Constants: lowerCamelCase
- Private: prefix with underscore

**Error Handling:**
- Use exceptions (not Result<T,E> pattern)
- Create custom exception classes
- Handle with try-catch blocks

### Rust

**Follow standard Rust conventions:**
- Use rustfmt
- clippy warnings as errors
- Comprehensive error types with thiserror

## Testing

### Unit Tests
- Test domain layer logic
- Mock repository interfaces
- Aim for >80% coverage

### Integration Tests
- Test DIDComm message flows
- Test API endpoints
- Use test fixtures for DIDs/keys

### Widget Tests
- Test Flutter UI components
- Mock providers with Riverpod's ProviderScope
- Test user interactions

## DIDComm Implementation

### Message Structure
```dart
PlainTextMessage(
  id: uuid,
  type: Uri.parse(messageType),
  from: senderDid,
  to: [recipientDid],
  body: {...},
  createdTime: DateTime.now(),
  expiresTime: DateTime.now().add(Duration(minutes: 5)),
)
```

### Key Management
- Load keys from `user_config.json`
- Support Ed25519, secp256k1, P-256/384/521
- Never hardcode private keys

### Message Correlation
- Use UUID v4 for message IDs
- Match responses via threadId
- Implement timeouts (30s default)

## Git Workflow

### Branch Naming
- `feature/description`
- `fix/description`
- `refactor/description`

### Commit Messages
```
type(scope): short description

Longer description if needed
```

Types: feat, fix, refactor, docs, test, chore

### Pull Requests
- Link to issue/task
- Describe changes clearly
- Include test evidence
- Request review from team

## Security

### Private Keys
- Store in `user_config.json` or environment variables
- Never commit to git (.gitignore all config files)
- Use different keys per environment

### DID Security
- Validate DID format before use
- Verify message signatures
- Implement message expiry

### API Security
- Validate all inputs
- Use proper error messages (no stack traces to users)
- Implement rate limiting

## Performance

### Flutter
- Use const constructors where possible
- Lazy load heavy widgets
- Optimize list rendering with builders

### Backend
- Cache trust registry lookups
- Use connection pooling
- Implement timeouts on external calls

## Documentation

### Code Comments
- Explain why, not what
- Document complex business logic
- Add examples for public APIs

### README Files
- Keep concise and current
- Include setup instructions
- Link to detailed docs

### Architecture Decisions
- Document significant decisions
- Explain trade-offs
- Keep rationale for future reference

## Common Patterns

### Repository Pattern
```dart
abstract class RecordRepository {
  Future<TrustRecord> create(TrustRecord record);
  Future<TrustRecord> read(String id);
  Future<void> update(TrustRecord record);
  Future<void> delete(String id);
  Future<List<TrustRecord>> list();
}
```

### Use Case Pattern
```dart
class CreateRecordUseCase {
  final RecordRepository repository;
  
  CreateRecordUseCase(this.repository);
  
  Future<TrustRecord> call(TrustRecord record) async {
    // Validation logic
    return await repository.create(record);
  }
}
```

### Provider Pattern (Riverpod)
```dart
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  return RecordRepositoryImpl(ref.watch(dataSourceProvider));
});

final createRecordUseCaseProvider = Provider<CreateRecordUseCase>((ref) {
  return CreateRecordUseCase(ref.watch(recordRepositoryProvider));
});
```
