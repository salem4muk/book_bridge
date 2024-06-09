import 'package:intl/intl.dart';

class FailedReservations{
  int id;
  int bookDonationsId;
  String point;
  String status;
  String level;
  String semester;
  String donorName;
  String residentialQuarter;
  String createdAt;

  FailedReservations({
    required this.id,
    required this.bookDonationsId,
    required this.point,
    required this.status,
    required this.level,
    required this.semester,
    required this.donorName,
    required this.residentialQuarter,
    required this.createdAt,
  });

  factory FailedReservations.fromJson(Map<String, dynamic> json) {
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


    return FailedReservations(
      id: json['id'] ?? 0, // Assuming 0 is a safe default for id
      bookDonationsId: json['bookDonations_id'] ?? 0, // Assuming 0 is a safe default for beneficiary_id
      point: json['point'] ?? '', // Providing default empty string
      status: json['status'] ?? '', // Providing default empty string
      level: json['level'] ?? '',
      semester: json['semester'] ?? '',
      donorName: json['donorName'] ?? '',
      residentialQuarter: json['residentialQuarter'] ?? '',
      createdAt: formattedCreatedAt,
    );
  }
}
