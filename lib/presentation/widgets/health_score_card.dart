import 'package:flutter/material.dart';

class HealthScoreCard extends StatelessWidget {
  final int score;

  const HealthScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 80
        ? Colors.green
        : score >= 50
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    color: color,
                  ),
                ),
                Text('$score'),
              ],
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Contact Health Score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
