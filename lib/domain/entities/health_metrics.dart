class HealthMetrics {
  final int total;
  final int missingName;
  final int missingPhone;
  final int missingEmail;
  final int missingPhoto;
  final int duplicates;
  final int emptyContacts;

  const HealthMetrics({
    required this.total,
    required this.missingName,
    required this.missingPhone,
    required this.missingEmail,
    required this.missingPhoto,
    required this.duplicates,
    required this.emptyContacts,
  });

  double get completionPercent {
    if (total == 0) return 0;
    final complete = total - emptyContacts;
    return (complete / total) * 100;
  }
}
