import 'exchange_point.dart';

class City {
  final int id;
  final String name;
  final List<ExchangePoint> exchangePoints;

  City({
    required this.id,
    required this.name,
    required this.exchangePoints,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    var list = json['exchange_points'] as List;
    List<ExchangePoint> exchangePointsList = list.map((i) => ExchangePoint.fromJson(i)).toList();

    return City(
      id: json['id'],
      name: json['name'],
      exchangePoints: exchangePointsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exchange_points': exchangePoints.map((e) => e.toJson()).toList(),
    };
  }
}
