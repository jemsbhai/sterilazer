import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

//    print('animation.value  ${animation.value} ');
//    print('inMinutes ${clockTimer.inMinutes.toString()}');
//    print('inSeconds ${clockTimer.inSeconds.toString()}');
//    print('inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    if(timerText =='0:00'){
      return Text('Sterilization finished!',style: TextStyle(
        fontSize: 22
      ),);
    } else {
      return Text(
        "$timerText",
        style: TextStyle(
          fontSize: 44,
          color: Theme
              .of(context)
              .primaryColor,
        ),
      );
    }
  }
}