import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {

  final _isHours = true;
  bool isStartPressed = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
      isLapHours: true,
      onChange: (value) => print('onChange $value'),
      onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
      onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
    print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 97, 141, 2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data;
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          displayTime,
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),

                    ],

                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.minuteTime,
                initialData: _stopWatchTimer.minuteTime.value,
                builder: (context, snap){
                  final value = snap.data;
                  print('Listen every minute. $value');
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                ' minutes passed',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.secondTime,
                initialData: _stopWatchTimer.secondTime.value,
                builder: (context, snap) {
                  final value = snap.data;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'seconds passed' ,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 120,
              margin: EdgeInsets.all(8.0),
              child: StreamBuilder<List<StopWatchRecord>>(
                stream: _stopWatchTimer.records,
                initialData: _stopWatchTimer.records.value,
                builder: (context, snap) {
                  final value = snap.data;
                  if(value.isEmpty) {
                    return Container();
                  }
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut);
                  });
                  return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '${data.displayTime}',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                  itemCount: value.length,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            padding: EdgeInsets.all(4.0),
                            color: Colors.green,
                            icon: Icon(Icons.play_circle_outline, size: 50.0, ),
                            onPressed: () async {
                              isStartPressed = true;
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.start);
                            },

                          ),
                        ),// Start
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            padding: EdgeInsets.all(4.0),
                            color: Colors.red,
                            icon: Icon(Icons.stop, size: 50.0, ),
                            onPressed: () async {
                              if(isStartPressed) {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                              }
                            },

                          ),
                        ),  //Stop
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            padding: EdgeInsets.all(4.0),
                            color: Colors.grey,
                            icon: Icon(Icons.refresh, size: 50.0, ),
                            onPressed: () async {
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.reset);
                            },

                          ),// Reset
                        ),
                      ],
                    ),
                  ),

                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 4),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Padding(
                               padding: EdgeInsets.all(0).copyWith(right: 8),
                               child: IconButton(
                                 padding: EdgeInsets.all(4.0),
                                 color: Colors.orange,
                                 icon: Icon(Icons.call_split, size: 50.0,),
                                 onPressed: () async {
                                   _stopWatchTimer.onExecute
                                       .add(StopWatchExecute.lap);
                                 },

                               ), // Lap
                             ),
                           ],
                         ),
                       ),
                ],
              ),
            )
          ],
        ),

      ),

    );
  }
}


