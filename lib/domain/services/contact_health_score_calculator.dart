import '../entities/health_metrics.dart';

class ContactHealthScoreCalculator {
  int calculate(HealthMetrics metrics) {
    if (metrics.total == 0) return 100;

    final total = metrics.total;
    final missingNamePenalty = 20 * (metrics.missingName / total);
    final missingPhonePenalty = 20 * (metrics.missingPhone / total);
    final missingEmailPenalty = 10 * (metrics.missingEmail / total);
    final missingPhotoPenalty = 10 * (metrics.missingPhoto / total);
    final duplicatesPenalty = 25 * (metrics.duplicates / total);
    final emptyContactsPenalty = 15 * (metrics.emptyContacts / total);

    final rawScore = 100 -
        missingNamePenalty -
        missingPhonePenalty -
        missingEmailPenalty -
        missingPhotoPenalty -
        duplicatesPenalty -
        emptyContactsPenalty;

    return rawScore.clamp(0, 100).round();
  }
}
