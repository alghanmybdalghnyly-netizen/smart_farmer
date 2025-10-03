class DailyForecast {
  final DateTime date;
  final double min;
  final double max;

  DailyForecast({required this.date, required this.min, required this.max});
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final double humidity; // نسبة تقديرية من daily relative humidity (إن لزم)

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });
}

class WeatherBundle {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherBundle({required this.current, required this.daily});
}
