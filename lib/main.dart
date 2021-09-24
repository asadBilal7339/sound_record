import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sound_recorder/recorded_list.dart';
import 'package:sound_recorder/recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecorderHomeView(),
    );
  }
}

class RecorderHomeView extends StatefulWidget {
  const RecorderHomeView({Key key}) : super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  Directory appDirectory;
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            colors: [
              Colors.white12,
              Colors.blueGrey.shade100,
              Colors.cyan.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 150,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.75),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 2, 199, 226),
                    Colors.indigoAccent,
                    Colors.indigo.shade900,
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    100.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sound Recorder',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 30),
              child: RecorderView(
                onSaved: _onRecordComplete,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Sound List :',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RecordListView(
                records: records,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
}
