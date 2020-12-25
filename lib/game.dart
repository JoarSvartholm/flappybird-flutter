import 'dart:async';

import 'package:flutter/material.dart';

import 'barrier.dart';
import 'bird.dart';

class MainGame extends StatefulWidget {
  static final Duration duration = Duration(milliseconds: 50);

  final void Function() onScoreUpdate;
  final void Function() onScoreReset;

  MainGame({this.onScoreUpdate, this.onScoreReset});

  @override
  _MainGameState createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  final GlobalKey<BirdState> birdKey = GlobalKey(debugLabel: "Bird");

  static final Duration duration = Duration(milliseconds: 50);

  double barrier1 = 1;
  double barrier2 = 2;
  bool hasStarted = false;

  void startGame() {
    hasStarted = true;
    widget.onScoreReset();
    birdKey.currentState.reset();
    Timer.periodic(duration, (timer) {
      birdKey.currentState.step();
      if (!birdKey.currentState.alive) {
        setState(() {
          timer.cancel();
          hasStarted = false;
        });
      }

      setState(() {
        barrier1 -= 0.05;
        barrier2 -= 0.05;
        if (barrier1 < -1.5) {
          barrier1 = 2.5;
          widget.onScoreUpdate();
        }
        if (barrier2 < -1.5) {
          barrier2 = 2.5;
          widget.onScoreUpdate();
        }
      });

    });
    setState(() {
      hasStarted = hasStarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (hasStarted) {
          birdKey.currentState.fly();
        } else {
          startGame();
        }
      },
      child: Container(
        color: Colors.blue,
        child: Stack(children: [
          Bird(key: birdKey, duration: duration),
          Gate(level: 0.4, opening: 0.35, position: barrier1),
          Gate(
            level: 0.3,
            opening: 0.4,
            position: barrier2,
          ),
          Container(
              alignment: Alignment(0, -0.25),
              child: hasStarted
                  ? null
                  : Text(
                "T A P  T O  S T A R T",
                style:
                TextStyle(fontSize: 20, color: Colors.white),
              )),
        ]),
      ),
    );
  }
}
