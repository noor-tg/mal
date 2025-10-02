import 'dart:io';
import 'package:mal/enums.dart';
import 'package:mal/l10n/app_localizations.dart';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/utils.dart';
import 'package:mal/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExporterService {
  /// Export SQLite table to TSV file
  static Future<String> exportEntriesToTsv(
    String userUid,
    AppLocalizations l10n,
  ) async {
    try {
      // Query all data from the table
      final List<Map<String, dynamic>> data = await QueryBuilder('entries')
          .where('user_uid', '=', userUid)
          .select(['description', 'amount', 'type', 'category', 'date'])
          .sortBy('date', SortingDirection.desc)
          .getAll();

      if (data.isEmpty) {
        throw Exception('Table is empty');
      }

      // Get column names from the first row
      final List<String> columns = data.first.keys.toList();

      const utf8Bom = '\uFEFF';
      // Build TSV content
      final StringBuffer tsvBuffer = StringBuffer(utf8Bom);

      // Add header row
      // ignore: cascade_invocations
      tsvBuffer.writeln(
        [
          l10n.description,
          l10n.amount,
          l10n.type,
          l10n.category,
          l10n.date,
        ].join('\t'),
      );

      // Add data rows
      for (final row in data) {
        final rowValues = columns.map((col) {
          var value = row[col];
          if (col == 'date') {
            value = (value as String).replaceAll('T', ' ').substring(0, 19);
          }
          if (col == 'amount') {
            value = moneyFormat(value);
          }
          return _escapeTsvField(value?.toString() ?? '');
        });
        tsvBuffer.writeln(rowValues.join('\t'));
      }

      // Generate file path
      final directory = await _getDownloadDirectory();
      final date = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '_')
          .replaceAll('.', '_');
      final tsvFileName = 'entries_$date.csv';
      final filePath = '${directory.path}/$tsvFileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(tsvBuffer.toString());

      logger.i(filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to export TSV: $e');
    }
  }

  /// Escape TSV field (handle tabs, newlines)
  static String _escapeTsvField(String field) {
    // Replace tabs with spaces and remove newlines
    return field
        .replaceAll('\t', ' ')
        .replaceAll('\n', ' ')
        .replaceAll('\r', ' ');
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Request storage permission for Android
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }

      // Try to get Downloads directory
      final directory = Directory('/storage/emulated/0/Download');
      if (directory.existsSync()) {
        return directory;
      }

      // Fallback to external storage
      return await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      // iOS uses app documents directory
      return getApplicationDocumentsDirectory();
    } else {
      // Desktop or other platforms
      return await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }
  }
}
