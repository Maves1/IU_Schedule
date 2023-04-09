import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'schedule_manager/schedule_manager.dart';
import 'schedule_manager/schedule.dart';
import 'event_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _scheduleClient = ScheduleManager();
  Schedule? _schedule;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future<bool> initSchedule() async {
    bool res = await _scheduleClient.retrieveScheduleInfo();
    var courses = _scheduleClient.courses;
    var groups = _scheduleClient.getGroupsForCourse(courses[0]);
    _schedule = await _scheduleClient.getScheduleForGroup(groups[0]);
    return res;
  }

  List<ScheduleEntry> _getEventsByDay(DateTime day) {
    return _schedule?.events
            .where((e) => e.startDateTime.weekday == day.weekday)
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: initSchedule(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              TableCalendar(
                eventLoader: _getEventsByDay,
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay =
                        focusedDay; // update `_focusedDay` here as well
                  });
                },
              ),
              SizedBox(height: 8.0),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: _getEventsByDay(_selectedDay ?? _focusedDay)
                    .map((e) => EventView(event: e))
                    .toList(),
              ))
            ]);
          }

          return const CircularProgressIndicator();
        });
  }
}
