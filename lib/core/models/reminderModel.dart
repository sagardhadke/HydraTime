class ReminderModel {
  final int id;
  final String title;
  final String description;
  final String interval;

  ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.interval,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json['id'] ?? 0, // Provide default value
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    interval: json['interval'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'interval': interval,
  };
}
