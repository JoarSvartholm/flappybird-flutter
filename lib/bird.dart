import 'package:flutter/material.dart';

class Bird extends StatefulWidget {
  final double size;
  final Offset initialPosition;
  static final double launchVelocity = 1.5;
  static final Image birdImage = Image.asset('lib/images/bird.png');
  final Duration duration;

  const Bird({Key key, this.duration, this.size = 0.1, this.initialPosition})
      : super(key: key);

  @override
  BirdState createState() => BirdState(initialPosition: initialPosition);
}

class BirdState extends State<Bird> {
  double initialHeight = 0;
  Offset initialPosition;
  double height = 0;
  double velocity = 0;
  double _time = 0;
  bool alive = true;

  BirdState({Offset initialPosition}) : this.height = initialPosition.dy;

  void fly() {
    setState(() {
      _time = 0;
      initialHeight = height;
    });
  }

  void kill() {
    setState(() {
      alive = false;
    });
  }

  void reset() {
    setState(() {
      initialHeight = widget.initialPosition.dy;
      _time = 0;
      alive = true;
    });
  }

  void step() {
    setState(() {
      _time += widget.duration.inMilliseconds / Duration.millisecondsPerSecond;
      velocity = 9.82 * _time - 2 * Bird.launchVelocity;
      height = velocity * _time / 2 + initialHeight;

      if (height > 1) {
        alive = false;
        height = 1;
        velocity = 0;
      }
    });
  }

  Rect getAsRect() {
    return Rect.fromCenter(
        center: Offset(widget.initialPosition.dx, height),
        width: widget.size,
    height: widget.size);
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = getAsRect();
    return AnimatedContainer(
        duration: widget.duration,
        alignment: FractionalOffset(
            rect.left / ( 1 - rect.width), rect.top / (1 - rect.width)),
        child: Transform.rotate(
            angle: 0.2 * velocity,
            child: FractionallySizedBox(
                widthFactor: widget.size,
                heightFactor: widget.size,
                child: Bird.birdImage)));
  }
}
