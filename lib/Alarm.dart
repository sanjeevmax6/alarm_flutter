//import 'dart:js';
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

const String _backgroundName = 'plugins.flutter.io/android_alarm_manager_background';

void _alarmManagerCallbackDispatcher() {

  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel _channel = MethodChannel(_backgroundName, JSONMethodCodec());

  _channel.setMethodCallHandler((MethodCall call) async {
    final dynamic args = call.arguments;
    final CallbackHandle handle = CallbackHandle.fromRawHandle(args[0]);

    final Function closure = PluginUtilities.getCallbackFromHandle(handle);

    if(closure == null) {
      print('Fatal: could not find callback');
      exit(-1);
    }

    if(closure is Function()) {
      closure();
    }
    else if(closure is Function(int)) {
      final int id = args[1];
      closure(id);
    }
  });

  _channel.invokeMethod<void>('AlarmService.initialized');
}

typedef DateTime _Now();

typedef CallbackHandle _GetCallbackHandle(Function callback);

class AndroidAlarmManager {
  static const String _channelName = 'plugins.flutter.io/android_alarm_manager';
  static MethodChannel _channel = const MethodChannel(
      _channelName, JSONMethodCodec());

  static _Now _now = () => DateTime.now();

  static _GetCallbackHandle _getCallbackHandle = (Function callback) =>
      PluginUtilities.getCallbackHandle(callback);


  @visibleForTesting
  static void setTestOverides(
      {_Now now, _GetCallbackHandle getCallbackHandle}) {
    _now = (now ?? _now);
    _getCallbackHandle = (getCallbackHandle ?? _getCallbackHandle);
  }

  static Future<bool> initialize() async {
    final CallbackHandle handle = _getCallbackHandle(_alarmManagerCallbackDispatcher);
    if(handle == null) {
      return false;
    }
    final bool r = await _channel.invokeMethod<bool>(
      'AlarmService.start', <dynamic>[handle.toRawHandle()]);
    return r ?? false;
  }

  static Future<bool> oneShot(
      Duration delay,
      int id,
      Function callback, {
        bool alarmClock = false,
        bool allowWhileidle = false,
        bool exact = false,
        bool wakeup = false,
        bool rescheduleOnReboot = false,
}) =>
      oneShotAt(
        _now().add(delay),
        id,
        callback,
        alarmClock: alarmClock,
        allowWhileIdle: allowWhileidle,
        exact: exact,
        wakeup: wakeup,
        rescheduleOnReboot: rescheduleOnReboot,
      );

  static Future<bool> oneShotAt(
      DateTime time,
      int id,
      Function callback, {
        bool alarmClock = false,
        bool allowWhileIdle = false,
        bool exact = false,
        bool wakeup = false,
        bool rescheduleOnReboot = false,
}) async {
    assert(callback is Function() || callback is Function(int));
    assert(id.bitLength < 32);
    final int startMillis = time.millisecondsSinceEpoch;
    final CallbackHandle handle = _getCallbackHandle(callback);
    if(handle == null){
      return false;
    }
    final bool r = await _channel.invokeMethod<bool>('Alarm.oneShotAt', <dynamic>[
      id,
      alarmClock,
      allowWhileIdle,
      exact,
      wakeup,
      startMillis,
      rescheduleOnReboot,
      handle.toRawHandle(),
    ]);
    return (r == null) ? false : r;
  }

  static Future<bool> periodic(
      Duration duration,
      int id,
      Function callback,{
        DateTime startAt,
        bool exact = false,
        bool wakeup = false,
        bool rescheduleOnReboot = false,
}) async {
    assert(callback is Function() || callback is Function(int));
    assert(id.bitLength < 32);
    final int now = _now().millisecondsSinceEpoch;
    final int period = duration.inMilliseconds;
    final int first = startAt != null ? startAt.millisecondsSinceEpoch : now + period;
    final CallbackHandle handle = _getCallbackHandle(callback);
    if(handle == null) {
      return false;
    }
    final bool r = await _channel.invokeMethod<bool>(
      'Alarm.periodic', <dynamic>[
        id,
        exact,
      wakeup,
      first,
      period,
      rescheduleOnReboot,
      handle.toRawHandle()
    ]);
    return (r == null) ? false : r;
  }

  static Future<bool> cancel(int id) async {
    final bool r = await _channel.invokeMethod<bool>('Alarm.cancel', <dynamic>[id]);
    return (r == null) ? false : r;
  }
}


class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {

  SharedPreferences prefs;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;


  final _scrollController = ScrollController();

  TimeOfDay _time;
  Timer _timer;

  DateTime someTime = new DateTime(2020,8,23,1,20,0,0,0);

  List<TimeOfDay> _alarms;
  List<String> _alarmName;
  List <TimeOfDay> _retrievedAlarms;
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _time = new TimeOfDay.now();
    _alarms = [];
    initializing();
//    AndroidAlarmManager.initialize();
  }

  @override
  void init() async {
    prefs = await SharedPreferences.getInstance();
    String extractTime = prefs.getString("theAlarm");
    _time = extractTime as TimeOfDay;

    prefs = await SharedPreferences.getInstance();
    String getTime = prefs.getString("theAlarm");
    List<String> splittedTime = getTime.split(':');
    setState(() {
      _time = splittedTime as TimeOfDay;
    });

  }

  void setAlarm() async {
    prefs = await SharedPreferences.getInstance();
    String storeTime = "${_time.hour}: ${_time.minute}";
    prefs.setString("theAlarm", storeTime);
  }

  void getAlarm() async {
    prefs = await SharedPreferences.getInstance();
    String getTime = prefs.getString("theAlarm");
    List<String> splittedTime = getTime.split(':');
    setState(() {
      _time = splittedTime as TimeOfDay;
    });

  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID',
        'Channel Title',
        'Channel Body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test'
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello There', 'Please subscribe my channel', notificationDetails);
  }

  Future<void> notificationAfterSec() async {
    RepeatInterval timeDelayed = RepeatInterval.Hourly;
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Second Channel',
        ' secondChannel Title',
        'second Channel Body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test'
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        1, "Hello", "Children", timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            print("");
          },
          child: Text("Okay"),),
      ],
    );
  }

  void runAlarm( DateTime RemainingTime) {
    AndroidAlarmManager.oneShotAt(
        RemainingTime,
        0,
      notification,
      wakeup: true,
    ).then((value) => print(value));
  }
  static void alarmTest() {
    print("test");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 97, 141, 2),

      body: Padding(
        padding: EdgeInsets.all(8.0),
//        child: Flexible(
//          child: ListView.builder(
//              itemCount: _alarms.length,
//              itemBuilder: (BuildContext context, int index) {
//                return Row(
//                  children: <Widget>[
//                    Text("${_alarms[index].format(context)}"
//                      , style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20.0,
//                    ),),
//                    IconButton(
//                      icon: Icon(Icons.delete, color: Colors.redAccent,),
//                      onPressed: () {
//                        setState(() {
//                          _alarms.removeAt(index);
//                          prefs.remove("${_alarmName[index]}");
//                        });
//                      },
//                      alignment: Alignment.centerRight,
//                    ),
//                    Divider(
//                      height: 2,
//                      color: Colors.white,
//                    ),
//                  ],
//                );
//              }
//          ),
//        ),
      child: Text("${_time.format(context)}" , style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
      ),
      )

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30.0,),
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          int addingIndex = _alarms.length - 1;
//          _pickTime(addingIndex);
          _pickOneTime(addingIndex);
        },
      ),
    );
  }

  Future _pickOneTime(int index) async {
    TimeOfDay time = await showTimePicker(
        context: this.context, initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return Theme(data: ThemeData(), child: child);
        });
    _time = time;
    final now = new DateTime.now();
    runAlarm(new DateTime(now.year, now.month, now.day, _time.hour, _time.minute));

    int relapseHour = (_time.hour - TimeOfDay.now().hour)*3600;
    int relapseMinute = (_time.minute - TimeOfDay.now().minute)*60;
    int remainingTime = relapseHour + relapseMinute;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {

        if(remainingTime < 1){
          timer.cancel();
          notification();
        }
        else{
          remainingTime = remainingTime - 1;
        }
        setAlarm();
      });
    });
  }


}