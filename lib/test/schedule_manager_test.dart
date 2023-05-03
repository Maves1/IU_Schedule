import 'package:flutter_test/flutter_test.dart';
import 'package:inno_schedule/schedule_manager/schedule_manager.dart';
import 'package:inno_schedule/schedule_manager/group.dart';

void main() {
  ScheduleManager scheduleManager = ScheduleManager();
  List<String> courses;
  List<Group> courseGroups;

  group("schedule_manager", () {

    test("schedule must be available", () async {
      expect(await scheduleManager.retrieveScheduleInfo(), true);
    });

    test("courses must not be empty", () {
      courses = scheduleManager.courses;
      expect(courses.isNotEmpty, true);
    });

    test("course must have at least 1 group", () {
      courses = scheduleManager.courses;

      courseGroups = scheduleManager.getGroupsForCourse(courses[0]);
      expect(courseGroups.isNotEmpty, true);
    });

    test("group schedule must be available", () async {
      courses = scheduleManager.courses;
      if (courses.isNotEmpty) {
        courseGroups = scheduleManager.getGroupsForCourse(courses[0]);

        if (courseGroups.isNotEmpty) {
          var schedule = await scheduleManager
              .getScheduleForGroup(courseGroups[0]);

          expect(schedule.events.isNotEmpty, true);
        }
      }
    });

  });
}