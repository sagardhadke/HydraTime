import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure({required super.message, super.code});
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure({required super.message, super.code});
}

class MigrationFailure extends Failure {
  const MigrationFailure({required super.message, super.code});
}

class NotificationFailure extends Failure {
  const NotificationFailure({required super.message, super.code});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.code});
}
