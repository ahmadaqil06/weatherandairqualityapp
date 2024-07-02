class WeatherData {
  final double temperature;
  final int humidity;

  WeatherData({required this.temperature, required this.humidity});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'] - 273.15, // Convert from Kelvin to Celsius
      humidity: json['main']['humidity'],
    );
  }
}
