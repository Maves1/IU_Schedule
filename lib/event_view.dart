import 'package:flutter/material.dart';
import 'schedule_manager/schedule.dart';

class EventView extends StatelessWidget {
  final ScheduleEntry event;

  const EventView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 75, child: Text(event.toString()));
  }
}
