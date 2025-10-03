import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_forecast.dart';

class WeatherService {
  /// يطلب صلاحية الموقع ويعيد إحداثيات المستخدم
  static Future<Position> _getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض صلاحية الموقع نهائياً من النظام.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('تم رفض صلاحية الموقع.');
      }
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  }

  /// يجلب حالة الطقس الحالية وتوقع 7 أيام من Open-Meteo
  static Future<WeatherBundle> loadWeather() async {
    final pos = await _getPosition();
    final lat = pos.latitude.toStringAsFixed(4);
    final lon = pos.longitude.toStringAsFixed(4);

    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
          '?latitude=$lat&longitude=$lon'
          '&current=temperature_2m,wind_speed_10m'
          '&daily=temperature_2m_max,temperature_2m_min,relative_humidity_2m_max'
          '&timezone=auto',
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('فشل طلب الطقس (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;

    // current
    final currentObj = json['current'] as Map<String, dynamic>;
    final current = CurrentWeather(
      temperature: (currentObj['temperature_2m'] as num).toDouble(),
      windSpeed: (currentObj['wind_speed_10m'] as num).toDouble(),
      humidity:  // نستخدم أعلى رطوبة يومية كقيمة تقريبية للحالي إن توفرت
      (json['daily']?['relative_humidity_2m_max'] != null &&
          (json['daily']['relative_humidity_2m_max'] as List).isNotEmpty)
          ? ((json['daily']['relative_humidity_2m_max'][0] as num).toDouble())
          : 0.0,
    );

    // daily
    final dates = (json['daily']['time'] as List).cast<String>();
    final mins = (json['daily']['temperature_2m_min'] as List).cast<num>();
    final maxs = (json['daily']['temperature_2m_max'] as List).cast<num>();

    final daily = <DailyForecast>[];
    for (int i = 0; i < dates.length; i++) {
      daily.add(DailyForecast(
        date: DateTime.parse(dates[i]),
        min: mins[i].toDouble(),
        max: maxs[i].toDouble(),
      ));
    }

    return WeatherBundle(current: current, daily: daily);
  }
}
