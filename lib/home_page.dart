import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Reveil.dart';
import 'notifi_service.dart';

DateTime scheduleTime = DateTime.now();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Reveil> myList = [
    Reveil(
      id: "0",
      startDate: "19/12/2023 12:00",
      endDate: "21/12/2023 12:30",
    ),
    Reveil(
      id: "1",
      startDate: "19/12/2023 13:00",
      endDate: "21/12/2023 18:30",
    ),
    Reveil(
      id: "2",
      startDate: "19/12/2023 12:00",
      endDate: "22/12/2023 19:30",
    ),
    Reveil(
      id: "3",
      startDate: "20/12/2023 16:00",
      endDate: "21/12/2023 1182:30",
    ),
    Reveil(
      id: "4",
      startDate: "19/12/2023 12:00",
      endDate: "22/12/2023 12:30",
    ),
    Reveil(
      id: "5",
      startDate: "20/12/2023 12:00",
      endDate: "22/12/2023 12:30",
    ),
    Reveil(
      id: "6",
      startDate: "20/12/2023 12:00",
      endDate: "21/12/2023 12:30",
    ),
    Reveil(
      id: "7",
      startDate: "17/12/2023 12:00",
      endDate: "21/12/2023 12:30",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DatePickerTxt(),
            ScheduleBtn(),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // DatePicker.showDateTimePicker(
        //   context,
        //   showTitleActions: true,
        //   onChanged: (date) => scheduleTime = date,
        //   onConfirm: (date) {},
        // );
        _selectDateTime(context);
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Future<void> _selectDateTime(
    BuildContext context,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2123),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        //scheduleTime = DateFormat('dd/MM/yyyy HH:mm').format(combinedDateTime);
        scheduleTime = combinedDateTime;

        //scheduleTime = DateFormat('dd/MM/yyyy HH:mm').parse(combinedDateTime);
        //DateFormat('dd/MM/yyyy HH:mm').format(combinedDateTime) as DateTime;
      }
    }
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('Schedule notifications'),
          onPressed: () {
            debugPrint('Notification Scheduled for $scheduleTime');
            log('Date Now ${DateTime.now()}');

            NotificationService().scheduleNotification(
              //NotificationService().showNotification(
              title: 'Scheduled Notification',
              body: '$scheduleTime',
              scheduledNotificationDateTime: scheduleTime,
            );
          },
        ),
        ElevatedButton(
          child: const Text('schedule Alarm_2'),
          onPressed: () {
            log('schedule Alarm_2 for $scheduleTime');
            log('Date Now ${DateTime.now()}');

            DateTime startDateFormatted = DateTime(2023, 12, 20, 15, 39, 00);
            log('startDateFormatted=$startDateFormatted');
            NotificationService().scheduleAlarm_2(startDateFormatted);
          },
        ),
      ],
    );
  }
}
