import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Gate extends StatefulWidget {
  final width;
  final position;
  final Duration duration;
  static final double initialVelocity = 0.5;

  Gate({Key key, this.width = 0.2, this.duration, this.position = 0.5})
      : super(key: key);

  @override
  GateState createState() => GateState(this.position);
}

class GateState extends State<Gate> {
  var rand = Random();
  double position;
  bool onScreen = true;
  double velocity = Gate.initialVelocity;
  Duration animationDuration = Duration(milliseconds: 0);

  SimpleBarrier top;
  SimpleBarrier bottom;

  GateState(this.position) {
    updateBarriers();
  }

  void updateBarriers() {
    double level = rand.nextDouble() * 0.5 + 0.1;
    double opening = rand.nextDouble() * (1 - level - 0.1 - 0.3) + 0.3;
    bottom = SimpleBarrier(height: level);
    top = SimpleBarrier(height: 1 - level - opening);
  }

  void increaseVelocity() {
    velocity += 0.1;
  }

  void move() {
    if (onScreen) {
      setState(() {
        if (animationDuration.inMilliseconds == 0) {
          animationDuration = widget.duration;
        }
        position -= velocity *
            animationDuration.inMilliseconds /
            Duration.millisecondsPerSecond;
        if (position < -widget.width) {
          onScreen = false;
        }
      });
    }
  }

  void restart() {
    setState(() {
      updateBarriers();
      onScreen = true;
      position = 1 + widget.width;
      animationDuration = Duration(milliseconds: 0);
    });
  }

  void reset() {
    setState(() {
      updateBarriers();
      onScreen = true;
      position = widget.position;
      animationDuration = Duration(milliseconds: 0);
      velocity = Gate.initialVelocity;
    });
  }

  bool isInside(Rect rect) {
    if (rect.right < position) return false;
    if (rect.left > position + widget.width) return false;
    if (rect.top > 1 - bottom.height) return true;
    if (rect.bottom < top.height) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: animationDuration,
          alignment: FractionalOffset(position / (1 - widget.width), 1),
          child: bottom,
        ),
        AnimatedContainer(
          duration: animationDuration,
          alignment: FractionalOffset(position / (1 - widget.width), 0),
              child: top
        ),
      ],
    );
  }
}

class SimpleBarrier extends StatelessWidget {
  final height;
  final width;

  SimpleBarrier({this.height, this.width = 0.2});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: width,
        heightFactor: height,
        child: Container(
            height: 30,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.green[500], Colors.green[800]]))));
  }
}
