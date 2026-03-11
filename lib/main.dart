import 'package:flutter/material.dart';

import 'domain/entities/health_metrics.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const ContactHealthApp());
}

class ContactHealthApp extends StatelessWidget {
  const ContactHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleMetrics = HealthMetrics(
      total: 520,
      missingName: 14,
      missingPhone: 23,
      missingEmail: 301,
      missingPhoto: 412,
      duplicates: 36,
      emptyContacts: 11,
    );

    return MaterialApp(
      title: 'Contact Health',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomeScreen(score: 68, metrics: sampleMetrics),
    );
  }
}
