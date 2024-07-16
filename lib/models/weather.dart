class Weather {
  String? main, description;
  double? temperature;


  Weather({required this.main, required this.temperature, required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    double? temp =  json['main']['temp'] != null ? (((json['main']['temp'] - 273.15) * 100).floor() / 100) : null;
    return Weather(
      main: json['weather'][0]['main'],
      temperature: temp, // Celsuis = kelvin - 273.15
      description: json['weather'][0]['description'],
    );
  }
}
