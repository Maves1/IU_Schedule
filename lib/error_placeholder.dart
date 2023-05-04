import 'package:flutter/material.dart';
import 'package:inno_schedule/schedule_manager/schedule_manager.dart';

Widget errorPlaceholder(ScheduleManager scheduleManager) {
  return Expanded(
    child: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_outlined, size: 50),
        const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("No Internet Connection")),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: ElevatedButton(
              onPressed: () => scheduleManager.loadSchedule(),
              child: const Text("Retry")),
        )
      ],
    )),
  );
}
