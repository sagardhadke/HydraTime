import 'package:flutter_test/flutter_test.dart';
import 'package:hydra_time/services/storage/migration_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late MigrationService migrationService;

  setUp(() async {
    await Hive.initFlutter();
    migrationService = MigrationService();
  });

  tearDown(() async {
    await Hive.close();
  });

  group('MigrationService', () {
    test('should check if migration is needed', () async {
      final needsMigration = await migrationService.needsMigration();
      expect(needsMigration, isA<bool>());
    });

    test('should get migration status', () async {
      final status = await migrationService.getMigrationStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status.containsKey('completed'), true);
      expect(status.containsKey('version'), true);
    });
  });
}