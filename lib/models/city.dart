class City {
  final String name;
  final double latitude, longitude;

  City({required this.name, required this.latitude, required this.longitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['city'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lng']),
    );
  }
}
