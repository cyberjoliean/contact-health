import '../entities/contact_record.dart';
import '../entities/health_metrics.dart';

class ContactAnalyzer {
  HealthMetrics analyze(List<ContactRecord> contacts) {
    int missingName = 0;
    int missingPhone = 0;
    int missingEmail = 0;
    int missingPhoto = 0;
    int emptyContacts = 0;

    final duplicateSignatures = <String, int>{};

    for (final contact in contacts) {
      if (!contact.hasName) missingName++;
      if (!contact.hasPhone) missingPhone++;
      if (!contact.hasEmail) missingEmail++;
      if (!contact.hasPhoto) missingPhoto++;
      if (contact.isEmptyRecord) emptyContacts++;

      final normalizedName = (contact.displayName ?? '').trim().toLowerCase();
      final normalizedPhone = contact.phones
          .map((p) => p.replaceAll(RegExp(r'[^0-9+]'), ''))
          .where((p) => p.isNotEmpty)
          .toList()
        ..sort();

      if (normalizedName.isNotEmpty || normalizedPhone.isNotEmpty) {
        final signature = '$normalizedName|${normalizedPhone.join(',')}';
        duplicateSignatures[signature] =
            (duplicateSignatures[signature] ?? 0) + 1;
      }
    }

    final duplicates = duplicateSignatures.values
        .where((count) => count > 1)
        .fold<int>(0, (sum, count) => sum + (count - 1));

    return HealthMetrics(
      total: contacts.length,
      missingName: missingName,
      missingPhone: missingPhone,
      missingEmail: missingEmail,
      missingPhoto: missingPhoto,
      duplicates: duplicates,
      emptyContacts: emptyContacts,
    );
  }
}
