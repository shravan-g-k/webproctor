import 'dart:async';
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:webproctor/pages/join_exam/attemp_exam_page.dart';
import 'package:js/js.dart' as js;

@js.JS('startEyeDetection')
external void startEyeDetection();

@js.JS('stopEyeDetection')
external void stopEyeDetection();

@js.JS()
external set eyeStateCallback(void Function(bool) f);

class ProctorWrapper extends StatefulWidget {
  const ProctorWrapper({super.key, required this.examData});
  final Map<String, dynamic> examData;

  @override
  State<ProctorWrapper> createState() => _ProctorWrapperState();
}

class _ProctorWrapperState extends State<ProctorWrapper> {
  bool _isDetecting = false;
  int _alertCount = 0;
  bool debarred = false;
  int? _lastUnseenTime;
  Timer? _warningTimer;
  static const int _warningThresholdSeconds = 5;
  static const int _maxWarnings = 3;
  int _tabSwitchCount = 0;
  bool _isWindowFocused = true;

  @override
  void initState() {
    super.initState();
    html.document.documentElement!.requestFullscreen();
    _setupEyeDetection();
    _setupTabVisibilityDetection();
    _disableRightClick();
    _toggleDetection();
    _setupWindowFocusListener();
  }

  void _setupEyeDetection() {
    eyeStateCallback = js.allowInterop((bool detected) {
      if (detected) {
        _lastUnseenTime = null;
        _warningTimer?.cancel();
      } else {
        _handleFaceNotDetected();
      }
    });
  }

  void _setupTabVisibilityDetection() {
    html.document.onVisibilityChange.listen((_) {
      if (html.document.hidden!) {
        _handleTabSwitch();
      }
    });
  }

  void _handleFaceNotDetected() {
    if (_lastUnseenTime == null) {
      _lastUnseenTime = DateTime.now().millisecondsSinceEpoch;
      _warningTimer =
          Timer(const Duration(seconds: _warningThresholdSeconds), () {
        _showWarning('Face not detected');
      });
    }
  }

  void _handleTabSwitch() {
    _tabSwitchCount++;
    if (_tabSwitchCount >= 3) {
      _showWarning('Tab switched');
    }
  }

  void _disableRightClick() {
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  void _showWarning(String reason) {
    setState(() {
      _alertCount++;
    });

    if (_alertCount > _maxWarnings) {
      setState(() {
        debarred = true;
      });
    } else {
      _playWarningSound();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Alert',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Text(
              'Warning $_alertCount of $_maxWarnings\nReason: $reason',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _playWarningSound() {
    html.AudioElement audio = html.AudioElement();
    audio.src = 'assets/beep.mp3';
    audio.play();
  }

  void _toggleDetection() {
    setState(() {
      _isDetecting = !_isDetecting;
    });
    if (_isDetecting) {
      startEyeDetection();
    } else {
      stopEyeDetection();
    }
  }

  void _setupWindowFocusListener() {
    html.window.onFocus.listen((_) {
      setState(() {
        _isWindowFocused = true;
      });
    });
    html.window.onBlur.listen((_) {
      _showWarning("Window Changed");
      setState(() {
        _isWindowFocused = false;
      });
    });
  }

  @override
  void dispose() {
    _warningTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return debarred
        ? const Scaffold(
            body: Center(
              child: Text(
                "Debarred",
                style: TextStyle(fontSize: 24),
              ),
            ),
          )
        : QuizPage(
            examData: widget.examData,
          );
  }
}
