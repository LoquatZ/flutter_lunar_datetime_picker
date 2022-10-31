import 'package:flutter/material.dart';
import 'package:flutter_lunar_datetime_picker/date_init.dart';
import 'package:flutter_lunar_datetime_picker/flutter_lunar_datetime_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("日期选择器"),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            lunarPicker: false,
            dateInitTime: DateInitTime(
                currentTime: DateTime.now(),
                maxTime: DateTime(2026, 12, 12),
                minTime: DateTime(2018, 3, 4)),
            onConfirm: (time,luanr) {
              debugPrint(time.toString());
            },
            onChanged: (time,lunar) {
              debugPrint("change:${time.toString()}");
            },
          );
        },
        child: const Text("选择"),
      )),
    );
  }
}
