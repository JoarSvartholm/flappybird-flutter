import 'package:flutter/material.dart';

class Bird extends StatefulWidget {
  final double size;
  final double initialPosition = -0.5;
  static final double initialHeight = 0;
  static final double launchVelocity = 2;
  static final Image birdImage = Image.asset('lib/images/bird.png');
  final Duration duration;

  const Bird({Key key, this.duration, this.size = 0.1}) : super(key: key);

  @override
  BirdState createState() => BirdState();
}

class BirdState extends State<Bird> {
  double initialHeight = Bird.initialHeight;
  double height = Bird.initialHeight;
  double velocity = 0;
  double _time = 0;
  bool alive = true;

  void fly() {
    setState(() {
      _time = 0;
      initialHeight = height;
    });
  }

  void reset() {
    setState(() {
      initialHeight = Bird.initialHeight;
      _time = 0;
      alive = true;
    });
  }

  void step() {
    setState(() {
      _time += 0.05;
      velocity = 9.82 * _time - 2 * Bird.launchVelocity;
      height = velocity * _time / 2 + initialHeight;

      if (height > 1) {
        alive = false;
        height = 1;
        velocity = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: widget.duration,
        alignment: Alignment(widget.initialPosition, height),
        child: Transform.rotate(
          angle: 0.2 * velocity,
          child: FractionallySizedBox(
              heightFactor: widget.size,
              widthFactor: widget.size,
              child: Bird.birdImage),
        ));
  }
}
