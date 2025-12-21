class StorageException implements Exception {
  final String message;
  final String? code;

  StorageException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'StorageException: $message ${code != null ? '(Code: $code)' : ''}';
}

class CacheException implements Exception {
  final String message;
  final String? code;

  CacheException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'CacheException: $message ${code != null ? '(Code: $code)' : ''}';
}

class MigrationException implements Exception {
  final String message;
  final String? code;

  MigrationException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'MigrationException: $message ${code != null ? '(Code: $code)' : ''}';
}

class DataNotFoundException implements Exception {
  final String message;

  DataNotFoundException({required this.message});

  @override
  String toString() => 'DataNotFoundException: $message';
}