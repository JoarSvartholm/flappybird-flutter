import 'package:flutter/material.dart';

class Gate2 extends StatefulWidget {
  final opening;
  final width;
  final position;
  final level;

  final Barrier bottom;
  final Barrier top;

  Gate2(
      {Key key,
      this.width = 0.2,
      this.level,
      this.opening,
      this.position = 0.5})
      : bottom = Barrier(size: level, width: width),
        top = Barrier(size: 1 - level - opening, width: width),
        super(key: key);

  @override
  Gate2State createState() => Gate2State(this.position);
}

class Gate2State extends State<Gate2> {
  double position;
  bool onScreen = true;
  Duration animationDuration = Duration(milliseconds: 50);

  void move() {
    if (onScreen) {
      setState(() {
        if (animationDuration.inMilliseconds == 0) {
          animationDuration = Duration(milliseconds: 50);
        }
        position -= 0.05;
        if (position < -1.6) {
          onScreen = false;
        }
      });
    }
  }

  void reset() {
    setState(() {
      onScreen = true;
      position = 1.6;
      animationDuration = Duration(milliseconds: 0);
    });
  }

  Gate2State(this.position);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            duration: animationDuration,
            alignment: Alignment(position, 1.1),
            child: widget.bottom),
        AnimatedContainer(
          duration: animationDuration,
          alignment: Alignment(position, -1.1),
          child: widget.top,
        )
      ],
    );
  }
}

class Gate extends StatelessWidget {
  final width;
  final opening;
  final level;
  final position;

  Barrier bottomBarrier;
  Barrier topBarrier;

  Gate({this.width, this.opening, this.level, this.position}) {
    this.bottomBarrier = Barrier(size: level);
    this.topBarrier = Barrier(size: 1 - level - opening);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 0),
            alignment: Alignment(position, 1.1),
            child: this.bottomBarrier),
        AnimatedContainer(
          duration: Duration(milliseconds: 0),
          alignment: Alignment(position, -1.1),
          child: topBarrier,
        )
      ],
    );
  }
}

class Barrier extends StatelessWidget {
  final size;
  final width;

  Barrier({this.size, this.width = 0.2});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: width,
        heightFactor: size,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(
                width: 10,
                color: Colors.green[800],
              ),
              borderRadius: BorderRadius.circular(15)),
        ));
  }
}
