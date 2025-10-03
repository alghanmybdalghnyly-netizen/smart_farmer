import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/diagnosis_page.dart';
import 'screens/crops_page.dart';
import 'screens/history_page.dart';
import 'screens/services_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartFarmerApp());
}

class SmartFarmerApp extends StatelessWidget {
  const SmartFarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المزارع الذكي',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAF5),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomePage(),
    DiagnosisPage(),
    CropsPage(),
    HistoryPage(),
    ServicesPage(),
  ];

  final _titles = const ['الرئيسية', 'التشخيص', 'المحاصيل', 'السجل', 'الخدمات'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(_titles[_index])),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'التشخيص'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture), label: 'المحاصيل'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'السجل'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'الخدمات'),
        ],
      ),
    );
  }
}
