import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final String title;
  final String description;
  final String imagePath;

  const Onboarding({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, description, imagePath];
}