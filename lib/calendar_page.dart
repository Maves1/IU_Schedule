import 'package:flutter/material.dart';
import 'package:inno_schedule/error_placeholder.dart';
import 'package:inno_schedule/schedule_manager/api_response.dart';
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
  final _scheduleClient = ScheduleManager.instance();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<ScheduleEntry> _getEventsByDay(DateTime day) {
    return _scheduleClient.currSchedule.events
        .where((e) => e.startDateTime.weekday == day.weekday)
        .toList();
  }

  String _getSelectedGroupString() {
    return '${_scheduleClient.currGroup.year} - ${_scheduleClient.currGroup.name}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<APIResponse<Schedule>>(
        stream: _scheduleClient.scheduleStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data?.status) {
              case LoadStatus.loading:
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [CircularProgressIndicator()]);
              case LoadStatus.success:
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
                  const SizedBox(height: 8.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                            child: TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pushNamed("/config"),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Colors.green)))),
                                child: Text(_getSelectedGroupString())),
                          ),
                        )
                      ]),
                  const SizedBox(height: 8.0),
                  Expanded(
                      child: ListView(
                    shrinkWrap: true,
                    children: _getEventsByDay(_selectedDay ?? _focusedDay)
                        .map((e) => EventView(event: e))
                        .toList(),
                  ))
                ]);
              default:
                return errorPlaceholder(_scheduleClient);
            }
          }
          return errorPlaceholder(_scheduleClient);
        });
  }
}
