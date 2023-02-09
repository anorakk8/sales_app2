import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ExportFile {
  write(String text) async {
    final directory = Directory('/storage/emulated/0/Download');
    directory ?? '';
    final path = '${directory?.path}/sales_app_locations.txt';
    final File file = File(path);

    print(path);
    await file.writeAsString(text);
  }
}
