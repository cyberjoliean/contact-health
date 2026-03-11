import 'package:flutter_contacts/flutter_contacts.dart';

import '../../domain/entities/contact_record.dart';

class DeviceContactsService {
  Future<bool> requestPermission() async {
    return FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<ContactRecord>> fetchContacts() async {
    final granted = await requestPermission();
    if (!granted) {
      throw Exception('Permission denied: contacts access was not granted');
    }

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    return contacts.map((c) {
      final countryCode = c.phones.isNotEmpty ? _extractCountryCode(c.phones.first.number) : null;

      return ContactRecord(
        displayName: c.displayName,
        phones: c.phones.map((p) => p.number).toList(),
        emails: c.emails.map((e) => e.address).toList(),
        company: c.organizations.isNotEmpty ? c.organizations.first.company : null,
        photoUri: c.photoOrThumbnail != null ? 'in-memory-photo' : null,
        countryCode: countryCode,
      );
    }).toList();
  }

  String? _extractCountryCode(String phone) {
    final normalized = phone.replaceAll(RegExp(r'\s+'), '');
    if (!normalized.startsWith('+')) return null;

    final digits = normalized.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return null;

    final lengths = [3, 2, 1];
    for (final len in lengths) {
      if (digits.length >= len) {
        return '+${digits.substring(0, len)}';
      }
    }

    return null;
  }
}
