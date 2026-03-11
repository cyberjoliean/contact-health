import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/contact_record.dart';

class TelegramBackupService {
  Future<File> buildContactsJson(List<ContactRecord> contacts) async {
    final jsonMap = {
      'contacts': contacts
          .map(
            (c) => {
              'name': c.displayName ?? '',
              'phones': c.phones,
              'emails': c.emails,
              'company': c.company ?? '',
            },
          )
          .toList(),
    };

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/contacts_backup.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(jsonMap),
      flush: true,
    );
    return file;
  }

  Future<void> sendBackup({
    required String botToken,
    required String chatId,
    required File file,
  }) async {
    final uri = Uri.parse('https://api.telegram.org/bot$botToken/sendDocument');

    final request = http.MultipartRequest('POST', uri)
      ..fields['chat_id'] = chatId
      ..files.add(await http.MultipartFile.fromPath('document', file.path));

    final response = await request.send();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      throw Exception('Telegram API error (${response.statusCode}): $body');
    }
  }
}
