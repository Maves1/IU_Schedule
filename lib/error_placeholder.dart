import 'package:flutter/material.dart';
import 'package:inno_schedule/schedule_manager/schedule_manager.dart';

Widget errorPlaceholder(ScheduleManager scheduleManager) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Center(
        child: Text("It seems there are problems with the Internet connection"),
      ),
      Center(
        child: ElevatedButton(
            onPressed: () => scheduleManager.loadSchedule(),
            child: const Text("Retry")),
      )
    ],
  );
}