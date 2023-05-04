import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:inno_schedule/services/notification_service/notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'schedule_manager/group.dart';

class LocalStorageService {
  static saveGroup(Group group) async {
    await _write(jsonEncode(group.toJson()));
  }

  static _getFile(String filename) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$filename');
    return file;
  }

  static _write(String text, {String filename = "group"}) async {
    if (kDebugMode) {
      print(text);
    }
    File file = await _getFile(filename);
    await file.writeAsString(text, mode: FileMode.write);
  }

  static _read({String filename = "group"}) async {
    File file = await _getFile(filename);
    final res = await file.readAsString();
    return res;
  }

  static getGroup() async {
    String group_ = await _read();
    return Group.fromJson(jsonDecode(group_));
  }

  static saveNotifications(Notifications notifications) async {
    await _write(jsonEncode(notifications.toJson()), filename: "notifications");
  }

  static getNotifications() async {
    String notifications_ = await _read(filename: "notifications");
    return Notifications.fromJson(jsonDecode(notifications_));
  }
}
