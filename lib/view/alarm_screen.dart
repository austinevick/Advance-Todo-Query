import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_selection/widget/custom_button.dart';

class AlarmScreen extends StatefulWidget {
  final int? id;
  const AlarmScreen({super.key, this.id});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  String title = '';
  String note = '';

  @override
  void initState() {
    super.initState();
  }

  void getAlarmDetails() {
    setState(() {
      AlarmSettings? a = Alarm.getAlarm(widget.id!);
      title = a!.notificationTitle!;
      note = a.notificationBody!;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 100),
          Text(widget.id.toString()),
          const SizedBox(height: 10),
          const Text('11:05'),
          const SizedBox(height: 10),
          Text(title),
          const SizedBox(height: 20),
          Text(note),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                onPressed: () {
                  final now = DateTime.now();
                  final newAlarm = AlarmSettings(
                      id: widget.id!,
                      dateTime: now.add(const Duration(minutes: 3)),
                      assetAudioPath: 'assets/mozart.mp3');
                  Alarm.set(alarmSettings: newAlarm)
                      .then((_) => Navigator.pop(context));
                },
                radius: 100,
                color: Colors.green,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.snooze,
                  color: Colors.white,
                ),
              ),
              CustomButton(
                onPressed: () => Alarm.stop(widget.id!),
                radius: 100,
                color: Colors.red,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.alarm_off,
                  color: Colors.white,
                ),
              )
            ],
          ),
          const Spacer(),
        ],
      )),
    );
  }
}
