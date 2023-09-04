import 'dart:async';
import 'package:dynamic_sland/services/DynamicIslandManager.dart';
import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  int seconds = 0;
  bool isRunning = false;
  Timer? timer;

  /// channel key is used to send data from flutter to swift side over
  /// a unique bridge (link between flutter & swift)
  final DynamicIslandManager diManager = DynamicIslandManager(channelKey: 'DI');

  void startTimer() {
    setState(() {
      isRunning = true;
    });

    // invoking startLiveActivity Method
    diManager.startLiveActivity(
      jsonData: DynamicIslandStopwatchDataModel(elapsedSeconds: 0).toJson(),
    );

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });

      // invoking the updateLiveActivity Method
      diManager.updateLiveActivity(
        jsonData: DynamicIslandStopwatchDataModel(
          elapsedSeconds: seconds,
        ).toJson(),
      );
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
    });

    // invoking the stopLiveActivity Method
    diManager.stopLiveActivity();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Stopwatch: $seconds seconds',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}