class Donation {
  int id;
  String pointName;
  String? donorName;
  String level;
  String semester;
  String location;
  String residentialQuarter;
  String date;
  String? description;
  int? isInPoint;
  List<DonationImage> images;

  Donation({
    required this.id,
    required this.pointName,
    this.donorName,
    required this.level,
    required this.semester,
    required this.location,
    required this.residentialQuarter,
    required this.date,
    this.isInPoint,
    required this.images,
    this.description ,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    // Parse the 'images' field as a list of DonationImage objects
    var imagesList = json['images'] as List<dynamic>;
    List<DonationImage> parsedImages = imagesList.map((imageJson) =>
        DonationImage.fromJson(imageJson as Map<String, dynamic>)).toList();

    return Donation(
      id: json['id'],
      pointName: json['pointName'],
      donorName: json['donorName'],
      level: json['level'],
      semester: json['semester'],
      location: json['location'],
      residentialQuarter: json['residential_quarter'],
      date: json['date'],
      isInPoint: json['isInPoint'],
      description: json['description'],
      images: parsedImages,
    );
  }
}

class DonationImage {
  int id;
  int bookDonationId; // Assuming this should match 'bookDonation_id' from JSON
  String source;

  DonationImage({
    required this.id,
    required this.bookDonationId,
    required this.source,
  });

  factory DonationImage.fromJson(Map<String, dynamic> json) {
    return DonationImage(
      id: json['id'],
      bookDonationId: json['bookDonation_id'],
      source: json['source'],
    );
  }
}
