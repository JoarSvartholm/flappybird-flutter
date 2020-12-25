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
  GlobalKey<Gate2State> gate1 = GlobalKey();
  final GlobalKey<Gate2State> gate2 = GlobalKey();

  static final Duration duration = Duration(milliseconds: 50);

  bool hasStarted = false;

  void startGame() {
    widget.onScoreReset();
    birdKey.currentState.reset();
    setState(() {
      hasStarted = true;
    });
    Timer.periodic(duration, (timer) {
      birdKey.currentState.step();
      gate1.currentState.move();
      gate2.currentState.move();
      if (!gate1.currentState.onScreen) {
        gate1.currentState.reset();
        widget.onScoreUpdate();
      }
      if (!gate2.currentState.onScreen) {
        gate2.currentState.reset();
        widget.onScoreUpdate();
      }
      if (!birdKey.currentState.alive) {
        setState(() {
          timer.cancel();
          hasStarted = false;
        });
      }
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
          Gate2(key: gate1, level: 0.4, opening: 0.35, position: 0.5),
          Gate2(key: gate2, level: 0.2, opening: 0.45, position: 2.1),
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
