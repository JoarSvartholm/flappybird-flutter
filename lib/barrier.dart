import 'dart:math';

import 'package:flutter/material.dart';

class Gate extends StatefulWidget {
  final opening;
  final width;
  final position;
  final level;
  final Duration duration;

  final SimpleBarrier bottom;
  final SimpleBarrier top;

  Gate(
      {Key key,
      this.width = 0.2,
      this.duration,
      this.level,
      this.opening,
      this.position = 0.5})
      : bottom = SimpleBarrier(height: level, width: width),
        top = SimpleBarrier(height: 1 - level - opening, width: width),
        super(key: key);

  @override
  GateState createState() => GateState(this.position);
}

class GateState extends State<Gate> {
  double position;
  bool onScreen = true;
  double velocity = 0.5;
  Duration animationDuration = Duration(milliseconds: 0);

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
      onScreen = true;
      position = 1 + widget.width;
      animationDuration = Duration(milliseconds: 0);
    });
  }

  void reset() {
    setState(() {
      onScreen = true;
      position = widget.position;
      animationDuration = Duration(milliseconds: 0);
    });
  }

  bool isInside(Rect rect) {
    if (rect.right < position) return false;
    if (rect.left > position + widget.width) return false;
    if (rect.top > 1 - widget.level) return true;
    if (rect.bottom < 1 - widget.level - widget.opening) return true;
    return false;
  }

  GateState(this.position);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: animationDuration,
          alignment: FractionalOffset(position / (1 - widget.width), 1),
          child: widget.bottom,
        ),
        AnimatedContainer(
          duration: animationDuration,
          alignment: FractionalOffset(position / (1 - widget.width), 0),
          child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: widget.top),
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
        color: Colors.green,
      ),
    );
  }
}
