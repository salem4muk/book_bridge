import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String? description;
  final String createdAt;
  final int isRead;


  NotificationModel({
    required this.title,
    this.description,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String createdAt = json['created_at'] ?? '';
    // Format the date to display only the date portion
    String formattedCreatedAt = '';
    if (createdAt.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(createdAt);
        formattedCreatedAt = DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (e) {
        // Handle parsing error, if any
        print('Error parsing created_at date: $e');
      }
    }

    return NotificationModel(
      title: json['title'] ?? '', // Providing default empty string
      description: json['description'],
      createdAt: formattedCreatedAt,
      isRead: json['isRead'],
    );
  }
}