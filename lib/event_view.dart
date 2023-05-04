import 'package:flutter/material.dart';
import 'package:inno_schedule/services/notification_service/notification_service.dart';
import 'package:intl/intl.dart';
import 'schedule_manager/schedule.dart';

class EventView extends StatefulWidget {
  final ScheduleEntry event;

  EventView({super.key, required this.event});

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  late bool isSwitched = NotificationService.eventNotificationsEnabled('${widget.event.title} ${widget.event.professor} ${widget.event.location} ${widget.event.startDateTime}');
  late IconData icon = isSwitched ? Icons.notifications_on_outlined : Icons.notifications_off_outlined;

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
                          Text(DateFormat("HH:mm").format(widget.event.startDateTime)),
                          const Text("-"),
                          Text(DateFormat("HH:mm").format(widget.event.endDateTime))
                        ]),
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          child: Text(widget.event.title,
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                              textAlign: TextAlign.center),
                        ),
                        Text(widget.event.professor),
                        Text(widget.event.location),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              icon = isSwitched ? Icons.notifications_on_outlined : Icons.notifications_off_outlined;
                            });
                            NotificationService.switchNotifications('${widget.event.title} ${widget.event.professor} ${widget.event.location} ${widget.event.startDateTime}',
                                widget.event.startDateTime,
                                title: widget.event.title,
                                body:
                                'Today at ${DateFormat("HH:mm").format(widget.event.startDateTime)} - ${DateFormat("HH:mm").format(widget.event.endDateTime)}');
                          }),
                      Icon(icon)
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
