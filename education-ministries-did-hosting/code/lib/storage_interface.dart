/// Simple storage interface for persisting DID documents and metadata
abstract class IStorage {
  Future<dynamic> get(String key);
  Future<void> put(String key, dynamic value);
  Future<void> delete(String key);
  Future<bool> exists(String key);
}
