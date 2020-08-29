import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();

  static void periodic(Duration duration, Null Function(Timer t) param1) {}

  void cancel() {

  }

}

class _TimerState extends State<Timer> {

  int hour = 0;
  int minute = 0;
  int second = 0;
  bool started = true;
  bool stopped = true;
  int timer = 0;
  String timeToDisplay = "";
  bool checkTimer = true;
  Timer timmy;

  @override
  Widget build(BuildContext context) {

    void initState() {
      super.initState();

    }


    void stop() {
      setState(() {
        started = true;
        stopped = true;
        checkTimer = false;

      });

    }

    void dispose() {
      super.dispose();
      timmy.cancel();

    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("HH", style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    NumberPicker.integer(
                        initialValue: hour,
                        minValue: 0,
                        maxValue: 23,
                        listViewWidth: 80.0,
                        onChanged: (value) {
                          setState(() {
                            hour = value;
                          });
                        },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("MM", style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    NumberPicker.integer(
                      initialValue: minute,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 80.0,
                      onChanged: (value) {
                        setState(() {
                          hour = value;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("SS", style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    NumberPicker.integer(
                      initialValue: second,
                      minValue: 0,
                      maxValue: 23,
                      listViewWidth: 80.0,
                      onChanged: (value) {
                        setState(() {
                          hour = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(timeToDisplay, style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_circle_outline, size: 70.0, color: Colors.green,),
                  padding: EdgeInsets.all(10.0),
                  onPressed: started ? start : null,
                ),
                SizedBox(width: 100.0,),
                IconButton(
                  icon: Icon(Icons.stop, size: 70.0, color: Colors.red,),
                  onPressed: stopped ? null : stop,
                  padding: EdgeInsets.all(10.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future start() async {
    setState(() {
      started = false;
      stopped = false;
    });
    timer = (hour*3600) + (minute*60) + second;
    Timer timmy = new Timer();
    Timer.periodic(
        Duration(seconds: 1,),
            (Timer t){
          setState(() {
            if(timer < 1 || checkTimer == false){
              t.cancel();
              checkTimer = true;
              timeToDisplay = "";
              started = false;
              stopped = false;
            }
            else if(timer < 60) {
              timeToDisplay = timer.toString();
              timer = timer - 1;
            }
            else if(timer < 3600) {
              int m = timer ~/3600;
              int s = timer - (60*m);
              timeToDisplay = m.toString() + ":" + s.toString();
              timer = timer -1;
            }
            else {
              int h = timer ~/3600;
              int t = timer - (3600 * h);
              int m = t ~/60;
              int s = t - (60*m);
              timeToDisplay = h.toString() + ":" + m.toString() + ":" + s.toString();
              timer = timer - 1;
            }
          });
        }
    );
  }
}


