import 'group.dart';

class Schedule {
  final Group _group;
  final List<ScheduleEntry> _scheduleEventsList;

  Schedule(this._group, this._scheduleEventsList);

  Group get group => _group;

  List<ScheduleEntry> get events => _scheduleEventsList;

  @override
  String toString() {
    return events.join("\n");
  }
}

class ScheduleEntry {
  final String title;
  final String professor;
  final String location;

  final DateTime startDateTime;
  final DateTime endDateTime;

  // final DateTime dateUntil;

  ScheduleEntry(this.title, this.professor, this.location, this.startDateTime,
      this.endDateTime);

  @override
  String toString() {
    final timePeriod =
        "${startDateTime.hour}:${startDateTime.minute} - ${endDateTime.hour}:${endDateTime.minute}";
    return "$title\n$professor\n$location\n$timePeriod\n";
  }
}
