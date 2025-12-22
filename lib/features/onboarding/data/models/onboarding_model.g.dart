// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OnboardingModelAdapter extends TypeAdapter<OnboardingModel> {
  @override
  final int typeId = 8;

  @override
  OnboardingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnboardingModel(
      isCompleted: fields[0] as bool,
      completedAt: fields[1] as DateTime?,
      currentPage: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OnboardingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isCompleted)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.currentPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
