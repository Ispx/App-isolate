import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isolate_app/isolate_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Isolate App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IsolateTimer _isolateTimer = IsolateTimer();
  DateTime? _date;
  @override
  void initState() {
    _isolateTimer.receivePort?.listen((date) {
      _date = date;
      setState(() {});
    });
    super.initState();
  }

  void start() {
    Timer.periodic(const Duration(seconds: 1), (e) {
      _isolateTimer.createIsolate();
    });
  }

  void stop() {
    _isolateTimer.close();
  }

  @override
  void dispose() {
    _isolateTimer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Expanded(flex: 1, child: Center()),
            Icon(
              Icons.timer,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'A cada segundo uma thread é criada para isolar a requisição do timer atual.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "${_date?.hour ?? '00'}:${_date?.minute ?? '00'}:${_date?.second ?? '00'}",
              style: Theme.of(context).textTheme.headline4,
            ),
            const Expanded(flex: 2, child: Center())
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => stop(),
            child: const Icon(Icons.stop),
          ),
          const SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () => start(),
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
