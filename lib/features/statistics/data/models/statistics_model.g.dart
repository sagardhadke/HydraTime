// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticsModelAdapter extends TypeAdapter<StatisticsModel> {
  @override
  final int typeId = 5;

  @override
  StatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatisticsModel(
      date: fields[0] as DateTime,
      totalIntake: fields[1] as double,
      dailyGoal: fields[2] as double,
      percentage: fields[3] as double,
      goalAchieved: fields[4] as bool,
      intakesCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StatisticsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalIntake)
      ..writeByte(2)
      ..write(obj.dailyGoal)
      ..writeByte(3)
      ..write(obj.percentage)
      ..writeByte(4)
      ..write(obj.goalAchieved)
      ..writeByte(5)
      ..write(obj.intakesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
