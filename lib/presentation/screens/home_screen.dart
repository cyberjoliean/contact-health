import 'package:flutter/material.dart';

import '../../domain/entities/health_metrics.dart';
import '../widgets/health_score_card.dart';

class HomeScreen extends StatelessWidget {
  final int score;
  final HealthMetrics metrics;

  const HomeScreen({
    super.key,
    required this.score,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Health')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HealthScoreCard(score: score),
          const SizedBox(height: 12),
          _KpiTile(label: 'Всего контактов', value: '${metrics.total}'),
          _KpiTile(label: 'Заполненность', value: '${metrics.completionPercent.toStringAsFixed(1)}%'),
          _KpiTile(label: 'Дубликаты', value: '${metrics.duplicates}'),
          const SizedBox(height: 16),
          const Text(
            'Быстрые рекомендации',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (metrics.duplicates > 0)
            const ListTile(
              leading: Icon(Icons.merge),
              title: Text('Объединить дубликаты'),
            ),
          if (metrics.emptyContacts > 0)
            const ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Удалить пустые контакты'),
            ),
          if (metrics.missingEmail > 0)
            const ListTile(
              leading: Icon(Icons.alternate_email),
              title: Text('Добавить email у важных контактов'),
            ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;

  const _KpiTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
