import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/widget/button_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Timer'),
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
  static int maxSeconds = 60;
  int seconds = maxSeconds;
  int inputSeconds = 0;
  int repeatCount = 0;
  int pauseDuration = 0;
  Timer? timer;
  final inputSecondsController = TextEditingController();
  final repeatCountController = TextEditingController();
  final pauseDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputSecondsController.text = inputSeconds.toString();
    repeatCountController.text = repeatCount.toString();
    pauseDurationController.text = pauseDuration.toString();
  }

  void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (seconds > 0) {
          setState(() => seconds--);
        } else {
          if (repeatCount > 0) {
            repeatCount--;
            Future.delayed(
              Duration(seconds: pauseDuration),
              () =>
                  startTimerWithInput(inputSeconds, repeatCount, pauseDuration),
            );
          } else {
            stopTimer(reset: false);
          }
        }
      },
    );
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  void startTimerWithInput(
      int inputSeconds, int repeatCount, int pauseDuration) {
    setState(
      () {
        seconds = inputSeconds;
        maxSeconds = inputSeconds;
        inputSecondsController.text = inputSeconds.toString();
        repeatCountController.text = repeatCount.toString();
        pauseDurationController.text = pauseDuration.toString();
      },
    );
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (seconds > 0) {
          setState(() => seconds--);
        } else {
          stopTimer(reset: false);
          if (repeatCount > 1) {
            repeatCount--;
            Future.delayed(
                Duration(seconds: pauseDuration),
                () => startTimerWithInput(
                    inputSeconds, repeatCount, pauseDuration));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.blueAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.4, 0.7],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Input Seconds: $inputSeconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Repeat Count: $repeatCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Pause Duration: $pauseDuration',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetTimeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Set Timer"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: inputSecondsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter time in seconds",
                    ),
                    onChanged: (text) {
                      inputSeconds = int.parse(text);
                    },
                  ),
                  TextField(
                    controller: repeatCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter repeat count",
                    ),
                    onChanged: (text) {
                      repeatCount = int.parse(text);
                    },
                  ),
                  TextField(
                    controller: pauseDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter pause duration in seconds",
                    ),
                    onChanged: (text) {
                      pauseDuration = int.parse(text);
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ButtonWidget(
                  text: "Start",
                  onClicked: () {
                    Navigator.of(context).pop();
                    startTimerWithInput(
                        inputSeconds, repeatCount, pauseDuration);
                  },
                ),
                ButtonWidget(
                  text: "Cancel",
                  onClicked: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        "Set Timer",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'Pause' : 'Resume',
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
              ),
              const SizedBox(width: 12),
              ButtonWidget(
                text: 'Cancel',
                onClicked: stopTimer,
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: 'Start Timer!',
                color: Colors.black,
                backgroundColor: Colors.white,
                onClicked: () {
                  startTimer();
                },
              ),
              const SizedBox(width: 12),
              _buildSetTimeButton(),
            ],
          );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - seconds / maxSeconds,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 12,
              backgroundColor: Colors.greenAccent,
            ),
            Center(
              child: buildTime(),
            ),
          ],
        ),
      );

  Widget buildTime() {
    if (seconds == 0) {
      return const Icon(
        Icons.done,
        color: Colors.greenAccent,
        size: 112,
      );
    } else {
      return Text(
        '$seconds',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    }
  }
}
