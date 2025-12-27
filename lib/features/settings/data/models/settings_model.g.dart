// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 7;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      themeMode: fields[0] as String,
      notificationsEnabled: fields[1] as bool,
      soundEnabled: fields[2] as bool,
      vibrationEnabled: fields[3] as bool,
      language: fields[4] as String,
      dataBackupEnabled: fields[5] as bool,
      lastBackupDate: fields[6] as DateTime?,
      privacyPolicyAccepted: fields[7] as bool,
      privacyAcceptedDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.notificationsEnabled)
      ..writeByte(2)
      ..write(obj.soundEnabled)
      ..writeByte(3)
      ..write(obj.vibrationEnabled)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.dataBackupEnabled)
      ..writeByte(6)
      ..write(obj.lastBackupDate)
      ..writeByte(7)
      ..write(obj.privacyPolicyAccepted)
      ..writeByte(8)
      ..write(obj.privacyAcceptedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
