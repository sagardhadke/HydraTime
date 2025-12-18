enum ReminderType { interval, specificTime }

class ReminderModel {
  final int id;
  final String title;
  final String description;
  final String interval;
  final ReminderType type;
  final DateTime? createdAt;

  ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interval,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    // Handle backward compatibility for old data without type
    ReminderType reminderType;
    if (json['type'] != null) {
      reminderType = json['type'] == 'interval'
          ? ReminderType.interval
          : ReminderType.specificTime;
    } else {
      // Default fallback: check if interval contains "Minutes"
      reminderType = (json['interval'] ?? '').contains('Minutes')
          ? ReminderType.interval
          : ReminderType.specificTime;
    }

    return ReminderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interval: json['interval'] ?? '',
      type: reminderType,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'interval': interval,
        'type': type == ReminderType.interval ? 'interval' : 'specificTime',
        'createdAt': createdAt?.toIso8601String(),
      };

  // Helper getters
  bool get isIntervalType => type == ReminderType.interval;
  bool get isSpecificTimeType => type == ReminderType.specificTime;

  String get typeLabel =>
      type == ReminderType.interval ? 'Interval' : 'Specific Time';

  // Copy with method for updates
  ReminderModel copyWith({
    int? id,
    String? title,
    String? description,
    String? interval,
    ReminderType? type,
    DateTime? createdAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}