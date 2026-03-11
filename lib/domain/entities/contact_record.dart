class ContactRecord {
  final String? displayName;
  final List<String> phones;
  final List<String> emails;
  final String? company;
  final String? photoUri;
  final String? countryCode;

  const ContactRecord({
    required this.displayName,
    required this.phones,
    required this.emails,
    required this.company,
    required this.photoUri,
    required this.countryCode,
  });

  bool get hasName => (displayName ?? '').trim().isNotEmpty;
  bool get hasPhone => phones.any((p) => p.trim().isNotEmpty);
  bool get hasEmail => emails.any((e) => e.trim().isNotEmpty);
  bool get hasPhoto => (photoUri ?? '').trim().isNotEmpty;

  bool get isEmptyRecord => !hasName && !hasPhone && !hasEmail;
}
