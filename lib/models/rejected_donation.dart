import 'package:intl/intl.dart';

class RejectedDonations {
  int id;
  String point;
  String level;
  String semester;
  String? donorName;
  String residentialQuarter;
  String createdAt;
  String receiptDate;


  RejectedDonations({
    required this.id,
    required this.point,
    required this.level,
    required this.semester,
    this.donorName,
    required this.residentialQuarter,
    required this.createdAt,
    required this.receiptDate,
  });

  factory RejectedDonations.fromJson(Map<String, dynamic> json) {
    String createdAt = json['created_at'] ?? '';
    // String startLeadTimeDateForDonor = json['startLeadTimeDateForDonor'] ?? '';

    // Format the date to display only the date portion
    String formattedCreatedAt = '';
    String formattedStartLeadTimeDateForDonor = '';

    if (createdAt.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(createdAt);
        formattedCreatedAt = DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (e) {
        // Handle parsing error, if any
        print('Error parsing created_at date: $e');
      }
    }

    // if (startLeadTimeDateForDonor.isNotEmpty) {
    //   try {
    //     DateTime dateTime = DateTime.parse(startLeadTimeDateForDonor);
    //     formattedStartLeadTimeDateForDonor = DateFormat('yyyy-MM-dd').format(dateTime);
    //   } catch (e) {
    //     // Handle parsing error, if any
    //     print('Error parsing startLeadTimeDateForDonor date: $e');
    //   }
    // }

    return RejectedDonations(
      id: json['id'] ?? 0, // Assuming 0 is a safe default for id
      point: json['point'] ?? '', // Providing default empty string
      level: json['level'] ?? '',
      semester: json['semester'] ?? '',
      donorName: json['donorName'] ?? '',
      residentialQuarter: json['residentialQuarter'] ?? '',
      createdAt: formattedCreatedAt,
      receiptDate: json['receiptDate'] ?? '',
    );
  }
}
