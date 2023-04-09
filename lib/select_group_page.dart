import 'package:flutter/material.dart';
import 'schedule_manager/schedule_manager.dart';
import 'local_storage.dart';

class SelectGroupPage extends StatefulWidget {
  const SelectGroupPage({super.key});

  @override
  State<SelectGroupPage> createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {
  final _scheduleClient = ScheduleManager();
  int _selectedCourse = 0;
  int _selectedGroup = 0;

  Future<bool> initSchedule() async {
    bool res = await _scheduleClient.retrieveScheduleInfo();

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initSchedule(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Select your group'),
              ),
              body: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text('Select a course:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _selectedCourse,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        }
                      },
                      items:
                          _scheduleClient.courses.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text('Select a group:'),
                    const Spacer(),
                    DropdownButton<int>(
                      value: _selectedGroup,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      onChanged: (int? value) {
                        if (value != null) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        }
                      },
                      items: _scheduleClient
                          .getGroupsForCourse(
                              _scheduleClient.courses[_selectedCourse])
                          .asMap()
                          .entries
                          .map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value.name),
                        );
                      }).toList(),
                    )
                  ],
                ),
                Center(
                    child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    var group = _scheduleClient.getGroupsForCourse(
                        _scheduleClient
                            .courses[_selectedCourse])[_selectedGroup];
                    LocalStorageService.saveGroup(group);
                  },
                ))
              ]));
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
