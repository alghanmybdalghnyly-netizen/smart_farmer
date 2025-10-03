import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  static const routeName = '/services';
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('الخدمات: أدوات مساندة سنضيفها لاحقًا.'),
      ),
    );
  }
}
