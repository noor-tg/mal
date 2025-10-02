import 'dart:io';
import 'package:mal/shared/query_builder.dart';
import 'package:mal/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvExporter {
  /// Export SQLite table to CSV file
  static Future<String> exportTableToCsv(String userUid) async {
    try {
      // Query all data from the table
      final List<Map<String, dynamic>> data = await QueryBuilder(
        'entries',
      ).where('user_uid', '=', userUid).getAll();

      if (data.isEmpty) {
        throw Exception('Table is empty');
      }

      // Get column names from the first row
      final List<String> columns = data.first.keys.toList();

      // Build CSV content
      final StringBuffer csvBuffer = StringBuffer();

      // Add header row
      // ignore: cascade_invocations
      csvBuffer.writeln(columns.map(_escapeCsvField).join(','));

      // Add data rows
      for (final row in data) {
        final rowValues = columns.map((col) {
          final value = row[col];
          return _escapeCsvField(value?.toString() ?? '');
        });
        csvBuffer.writeln(rowValues.join(','));
      }

      // Generate file path
      final directory = await _getDownloadDirectory();
      final date = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '_')
          .replaceAll('.', '_');
      final csvFileName = 'entries_$date.csv';
      final filePath = '${directory.path}/$csvFileName';

      // Write to file
      final file = File(filePath);
      await file.writeAsString(csvBuffer.toString());

      logger.i(filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  /// Escape CSV field (handle commas, quotes, newlines)
  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
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
