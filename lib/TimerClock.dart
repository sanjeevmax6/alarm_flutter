import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';



//class Timer extends StatefulWidget {
//  @override
//  _TimerState createState() => _TimerState();
//
//
//}
//
//class _TimerState extends State<Timer> with TickerProviderStateMixin{
//
//  var _timer = 0;
//  var _time = 0;
//  double _timerDouble = 0;
//
//  static int runningHours = 0;
//  static int runningMinutes = 0;
//  static int runningSeconds = 0;
//  double runningDoubleHours = 0;
//  double runningDoubleMinutes = 0;
//  double runningDoubleSeconds = 0;
//  Duration runningTime = new Duration();
//  String _timeText = "Not Set";
//
//  AnimationController controller;
//
//  String get timerString {
//    Duration duration = controller.duration * controller.value;
//    return '${duration.inHours}:${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    // ignore: unnecessary_statements
//    _timer = _time;
//    _time;
//    _timer = _time;
//    runningHours = (_timer/3600).toInt();
//    runningMinutes = ((_timer % 3600) / 60).toInt() ;
////    runningSeconds = (_timer % 60);
////    runningDoubleHours = runningHours.toDouble();
////    runningDoubleMinutes = runningMinutes.toDouble();
////    runningDoubleSeconds = runningSeconds.toDouble();
//
//    controller = AnimationController(
//      vsync: this,
//      duration: Duration(seconds:_timer),
//      value:  _timerDouble,
//    );
//  }
//
//  @override
//  void setState(fn) {
//    // TODO: implement setState
//    super.setState(fn);
//    // ignore: unnecessary_statements
//    _time;
//    _timer = _time;
//    _timer = _time;
//    runningTime = Duration(seconds: _timer);
//    _timerDouble = _timer.toDouble();
//  }
//
//  void dispose() {
//    controller.dispose();
//    super.dispose();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Color.fromRGBO(31, 97, 141, 2),
//      body: Padding(
//        padding: EdgeInsets.all(16.0),
//        child: Column(
//          children: <Widget>[
//            Expanded(
//              child: Align(
//                alignment: FractionalOffset.center,
//                child: AspectRatio(
//                  aspectRatio: 1.0,
//                  child: Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: AnimatedBuilder(
//                            animation: controller,
//                            builder: (BuildContext context, Widget child) {
//                              return new CustomPaint(
//                                painter: TimerPainter(
//                                  animation: controller,
//                                  backgroundColor: Colors.white,
//                                  color: Colors.green
//                                ),
//                              );
//                            },
//                          )
//                      ),
//                      Align(
//                        alignment: FractionalOffset.center,
//                        child: Column(
//                          children: <Widget>[
//                            Text(
//                              "${_timer}",
//                              style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 50.0,
//                              ),
//                            ),
//                            AnimatedBuilder(
//                              animation: controller,
//                              builder: (BuildContext context, Widget child) {
//                                return new Text(
//                                  timerString,
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 125.0,
//                                  ),
//                                );
//                              },
//                            )
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.all(8.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  FloatingActionButton(
//                    child: AnimatedBuilder(
//                      animation: controller,
//                      builder: (BuildContext context, Widget child) {
//                        return new Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow);
//                      },
//                    ),
//                    onPressed: () {
//                      if(controller.isAnimating)
//                        controller.stop();
//                      else{
//                        controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value );
//                      }
//                    },
//                  ),
//                  FloatingActionButton(
//                    child: Icon(Icons.add, color: Colors.white,),
//                    onPressed: () {
//                      DatePicker.showTimePicker(context,
//                      theme: DatePickerTheme(
//                        containerHeight: 210.0,
//                      ),
//                        showTitleActions: true, onConfirm: (time) {
//
//                        setState(() {
//
//                          _time = (time.hour*3600) + (time.minute * 60) + (time.second);
//                          _timeText = '${time.hour} : ${time.minute} : ${time.second}';
//                          _timer = _time;
//                        });
//                          }, currentTime: DateTime.now(), locale: LocaleType.en);
//                      setState(() {
////                        _time = (time.hour*3600) + (time.minute * 60) + (time.second);
////                        _timeText = '${time.hour} : ${time.minute} : ${time.second}';
//                      // ignore: unnecessary_statements
//                      _time;
//                      // ignore: unnecessary_statements
//                      _timeText;
//                      // ignore: unnecessary_statements
//                      runningTime;
//                      // ignore: unnecessary_statements
//                      _timer;
//                      });
//                    },
//                  ),
//                ],
//              ),
//            ),
//
//          ],
//        ),
//
//      ),
//
//    );
//  }
//}
//
//class TimerPainter extends CustomPainter {
//  TimerPainter({
//    this.animation,
//    this.backgroundColor,
//    this.color,
//
//}) : super(repaint: animation);
//
//  final Animation<double> animation;
//  final Color backgroundColor, color;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    Paint paint = Paint()
//        ..color = backgroundColor
//        ..strokeWidth = 5.0
//        ..strokeCap = StrokeCap.round
//        ..style = PaintingStyle.stroke;
//
//    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
//    paint.color = color;
//    double progress = (1.0 - animation.value)* 2* math.pi;
//    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
//
//    // TODO: implement paint
//  }
//
//  @override
//  bool shouldRepaint(TimerPainter old) {
//
//    return animation.value != old.animation.value ||
//        color != old.color ||
//        backgroundColor != old.backgroundColor;
//    // TODO: implement shouldRepaint
//
//  }
//}

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();

  static void periodic(Duration duration) {}
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {

  int hour = 0;
  int minute = 0;
  int second = 0;
  bool started = true;
  bool stopped = true;
  int timer = 0;
  String timeToDisplay = "";
  @override
  Widget build(BuildContext context) {

    void initState() {
      super.initState();


    }

    void start() {
      timer = (hour*3600) + (minute*60) + second;
//      Timer.periodic(Duration( seconds: 1,
//      ),(Timer t){
//        setState(() {
//          if(timer < 1) {
//            t.cancel();
//          }
//        });
//          }
//      );
//      Timer.periodic(
//          Duration(
//        seconds: 1,), (Timer t){
//        setState(() {
//          if(timer < 1){
//            t.cancel();
//          }
//          else{
//            timer = timer - 1;
//          }
//        });
//
//      });
    }
    void stop() {

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
}


