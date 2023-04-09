import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'schedule_manager/group.dart';

class LocalStorageService {
  static saveGroup(Group group) async {
    await _write(jsonEncode(group.toJson()));
  }

  static _getFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/group');
    return file;
  }

  static _write(String text) async {
    File file = await _getFile();
    await file.writeAsString("$text\n", mode: FileMode.append);
  }

  static _read() async {
    File file = await _getFile();
    final res = await file.readAsString();
    return res;
  }

  static getGroup() async {
    String group_ = await _read();
    Group.fromJson(jsonDecode(group_));
  }
}