import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Alarm.dart' as alarm;
import './StopWatch.dart' as stopWatch;
import './TimerClock.dart' as timer;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:async';




void main() {
  runApp(new MaterialApp(
    home: MyTabs(),
  ));
}

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {

  String _timeString;
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = new TabController(length: 3, vsync: this);

    initializeDateFormatting();

    _timeString = _formatDateTime(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);

    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 97, 141, 2),
      appBar: AppBar(
//        title: Text("Clock"),
        backgroundColor: Color.fromRGBO(21, 67, 97, 2),
        bottom: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(
              icon: new Icon(Icons.alarm),
              text: "Alarm",
            ),
            Tab(
              icon: new Icon(Icons.watch_later),
              text: "Stop Watch",
            ),
            Tab(
              icon: new Icon(Icons.hourglass_empty),
              text: "Timer",
            )

          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          new alarm.Alarm(),
          new stopWatch.StopWatch(),
          new timer.Timer()
        ],
      ),
//      floatingActionButton: _bottomButtons(),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//  Widget _bottomButtons() {
//    return controller.index == 1
//        ? FloatingActionButton(
//      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm())),
//      backgroundColor: Color(0xff65d1ba),
//      child: Icon(
//        Icons.add,
//        size: 20.0,
//      ),
//    ): null;
//  }
//}


//class AddAlarm extends StatefulWidget {
//  @override
//  _AddAlarmState createState() => _AddAlarmState();
//}
//
//class _AddAlarmState extends State<AddAlarm> {
//
//
//  TimeOfDay _selectedTime;
//  ValueChanged<TimeOfDay> selectTime;
//
//
//  @override
//  void initState() {
//    _selectedTime = new TimeOfDay(
//        hour: 12,
//        minute: 30
//    );
//    super.initState();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Color(0xff1b2c),
//      appBar: AppBar(
//        backgroundColor: Color(0xff1b2c),
//      title: Column(
//        children: <Widget>[
//          Icon(Icons.alarm_add, color: Color(0xff65d1ba),),
//          Text("Add Alarm", style: TextStyle(
//            color: Color(0xff65d1ba),
//            fontSize: 25.0
//          ),)
//        ],
//      ),
//      ),
//      body: Padding(
//        padding: EdgeInsets.all(20.0),
//        child: Column(
//          children: <Widget>[
//            SizedBox(height: 60.0,),
//            GestureDetector(
//              child: Text(_selectedTime.format(context), style: TextStyle(
//                fontSize: 60.0,
//                fontWeight: FontWeight.bold,
//                color: Colors.white,
//              ),),
//              onTap: () {
//                _selectTime(context);
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay picked = await showTimePicker(
//        context: context,
//        initialTime: _selectedTime
//    );
//
//    setState(() {
//      _selectedTime = picked;
//    });
//  }
//
//}
//
//
//




