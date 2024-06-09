import 'package:intl/intl.dart';

class UndeliveredDonations {
  int id;
  String point;
  String level;
  String semester;
  String donorName;
  String residentialQuarter;
  String createdAt;

  UndeliveredDonations({
    required this.id,
    required this.point,
    required this.level,
    required this.semester,
    required this.donorName,
    required this.residentialQuarter,
    required this.createdAt,
  });

  factory UndeliveredDonations.fromJson(Map<String, dynamic> json) {
    String createdAt = json['created_at'] ?? '';
    // Format the date to display only the date portion
    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(createdAt);
        formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (e) {
        // Handle parsing error, if any
        print('Error parsing date: $e');
      }
    }

    return UndeliveredDonations(
      id: json['id'] ?? 0, // Assuming 0 is a safe default for id
      point: json['point'] ?? '', // Providing default empty string
      level: json['level'] ?? '',
      semester: json['semester'] ?? '',
      donorName: json['donorName'] ?? '',
      residentialQuarter: json['residentialQuarter'] ?? '',
      createdAt: formattedDate,
    );
  }
}
