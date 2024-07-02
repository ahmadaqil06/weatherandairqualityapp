class AirQualityData {
  final int aqi;
  final double pm25;

  AirQualityData({required this.aqi, required this.pm25});

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    return AirQualityData(
      aqi: json['main']['aqi'],
      pm25: json['components']['pm2_5'],
    );
  }
}
