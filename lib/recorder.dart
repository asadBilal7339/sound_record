import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key key, @required this.onSaved}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _RecorderViewState extends State<RecorderView> {
  bool isStart = false;

  FlutterAudioRecorder2 audioRecorder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          //color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: isStart == false
                    ? () async {
                        await _recordVoice();
                        setState(() {
                          isStart = !isStart;
                        });
                      }
                    : () {},
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                minWidth: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 18),
                color: isStart == false ? Colors.indigo : Colors.black38,
              ),
              SizedBox(width: 45),
              FlatButton(
                onPressed: isStart == true
                    ? () async {
                        await _stopRecording();
                        setState(() {
                          isStart = !isStart;
                        });
                      }
                    : () {},
                child: Text(
                  'Stop',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                minWidth: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 18),
                color: isStart == true ? Colors.indigo : Colors.black38,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();

    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();
      await _startRecording();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Allow permissions'),
      ));
    }
  }
}
