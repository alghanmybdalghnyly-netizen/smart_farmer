import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/weather_service.dart';
import '../models/weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  static const routeName = '/weather';
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherBundle> _future;

  @override
  void initState() {
    super.initState();
    _future = WeatherService.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: FutureBuilder<WeatherBundle>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _ErrorView(
              message: snap.error.toString(),
              onRetry: () => setState(() => _future = WeatherService.loadWeather()),
            );
          }
          final data = snap.data!;
          return RefreshIndicator(
            onRefresh: () async =>
                setState(() => _future = WeatherService.loadWeather()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // بطاقة الحالة الحالية
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.primary.withOpacity(.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('الحالة الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.thermostat, color: cs.primary),
                          const SizedBox(width: 8),
                          Text('${data.current.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.air, color: cs.primary),
                          const SizedBox(width: 8),
                          Text('الرياح: ${data.current.windSpeed.toStringAsFixed(1)} م/ث'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: cs.primary),
                          const SizedBox(width: 8),
                          Text('الرطوبة: ${data.current.humidity.toStringAsFixed(0)}%'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 7 أيام
                const Text('توقعات 7 أيام', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                ...data.daily.take(7).map((d) => _DayTile(d: d)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final DailyForecast d;
  const _DayTile({required this.d});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final df = DateFormat('EEE d MMM', 'ar');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(df.format(d.date))),
          Text('${d.max.toStringAsFixed(0)}° / ${d.min.toStringAsFixed(0)}°',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, color: cs.error, size: 40),
            const SizedBox(height: 12),
            Text('تعذر جلب الطقس:\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
