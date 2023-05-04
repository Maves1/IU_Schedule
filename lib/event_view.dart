import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'schedule_manager/schedule.dart';

class EventView extends StatelessWidget {
  final ScheduleEntry event;

  const EventView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: ColoredBox(
          color: Colors.greenAccent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(2, 3, 4, 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 40,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat("HH:mm").format(event.startDateTime)),
                          const Text("-"),
                          Text(DateFormat("HH:mm").format(event.endDateTime))
                        ]),
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          child: Text(event.title,
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                              textAlign: TextAlign.center),
                        ),
                        Text(event.professor),
                        Text(event.location),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Switch(value: false, onChanged: (value) => {}),
                      const Icon(Icons.notifications_off_outlined)
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
