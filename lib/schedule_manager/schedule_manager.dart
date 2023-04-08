import 'dart:convert';
import 'dart:core';
import 'dart:io';

import "package:http/http.dart";
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:inno_schedule/schedule_manager/group.dart';
import 'package:inno_schedule/schedule_manager/schedule.dart';

class ScheduleManager {

  final String baseUrl = "https://innohassle.ru/schedule/";
  late final String academicUrl;
  // late final String electivesUrl;

  final Set<Group> _groups;

  ScheduleManager() : _groups = <Group>{} {
    academicUrl = "$baseUrl/academic.json";
  }

  Future<bool> retrieveScheduleInfo() async {
    var client = Client();

    try {
      var response = await client.get(Uri.parse(academicUrl));
      var academicJson = json.decode(response.body);

      // calendars -> [[name, course, file], ...]
      final calendars = academicJson["calendars"];
      for (var entry in calendars) {
        var groupName = entry["name"];
        var courseYear = entry["course"];
        var calendarUrl = entry["file"];

        var currGroup = Group(groupName, courseYear, calendarUrl);

        _groups.add(currGroup);
      }

      client.close();
      return true;

    } on SocketException catch(e) {
      print(e.toString());
    } on HttpException catch(e) {
      print(e.toString());
    } on Exception catch(e) {
      print(e.toString());
    }

    client.close();
    return false;
  }

  Future<Map<String, dynamic>> _retrieveGroupScheduleJson(final Group group) async {
    var client = Client();

    try {
      final calendarUrl = "$baseUrl/${group.calendarUrl}";

      final response = await client.get(Uri.parse(calendarUrl));
      final calendar = ICalendar.fromString(response.body);

      client.close();
      return calendar.toJson();
    } on Exception catch(e) {
      print(e.toString());
    }

    client.close();
    return <String, dynamic>{};
  }

  Future<Schedule> getScheduleForGroup(final Group group) async {
    Map<String, dynamic> jsonSchedule = await _retrieveGroupScheduleJson(group);

    if (jsonSchedule.isEmpty) {
      throw Exception("Couldn't retrieve schedule");
    }

    var eventsList = <ScheduleEntry>[];

    for (var entry in jsonSchedule["data"]) {
      final courseName = entry["summary"];
      
      final description = entry["description"].toString();
      final professor = description.substring(0, description.lastIndexOf("\\n"));
      final location = entry["location"];

      final startTime = DateTime.parse(entry["dtstart"]["dt"].toString());
      final endTime = DateTime.parse(entry["dtend"]["dt"].toString());

      // TODO: implement
      // final dateUntil = DateTime.parse(entry["dtend"].toString());

      eventsList.add(ScheduleEntry(courseName, professor, location,
                                   startTime, endTime));
    }

    Schedule schedule = Schedule(group, eventsList);
    return schedule;
  }

  List<String> get courses {
    Set<String> coursesSet = <String>{};
    for (var group in _groups) {
      coursesSet.add(group.year);
    }

    return coursesSet.toList();
  }

  List<Group> getGroupsForCourse(final String course) {
    Set<Group> groups = <Group>{};
    for (var group in _groups) {
      if (group.year == course) {
        groups.add(group);
      }
    }

    return groups.toList();
  }
}


// Usage example
Future<void> main() async {
  
  // Firstly we need to create an instance of ScheduleManager
  ScheduleManager scheduleManager = ScheduleManager();
  
  // Then we download schedule info
  bool result = await scheduleManager.retrieveScheduleInfo();

  // Then we can see courses (BS Year 1, BS Year 2, ...)
  var courses = scheduleManager.courses;
  // print("courses: $courses");
  
  // And we can get groups for a particular year
  var groups = scheduleManager.getGroupsForCourse(courses[2]);

  // print("groups for course ${courses[0]} are: \n$groups");

  // And finally we can get an instance of a Schedule for a particular group
  var schedule = await scheduleManager.getScheduleForGroup(groups[2]);
  print(schedule);
}