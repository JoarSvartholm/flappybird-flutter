import 'dart:async';

import 'package:flutter/material.dart';

import 'barrier.dart';
import 'bird.dart';

class MainGame extends StatefulWidget {
  static final Duration duration = Duration(milliseconds: 50);

  final void Function() onScoreUpdate;
  final void Function() onScoreReset;
  final int Function() scoreFunction;

  MainGame({this.onScoreUpdate, this.onScoreReset, this.scoreFunction});

  @override
  _MainGameState createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  final GlobalKey<BirdState> birdKey = GlobalKey(debugLabel: "Bird");
  GlobalKey<GateState> gate1 = GlobalKey();
  final GlobalKey<GateState> gate2 = GlobalKey();

  static final Duration duration = Duration(milliseconds: 20);

  bool hasStarted = false;

  void startGame() {
    widget.onScoreReset();
    birdKey.currentState.reset();
    gate1.currentState.reset();
    gate2.currentState.reset();
    setState(() {
      hasStarted = true;
    });
    Timer.periodic(duration, (timer) {
      birdKey.currentState.step();
      gate1.currentState.move();
      gate2.currentState.move();
      if (!gate1.currentState.onScreen) {
        gate1.currentState.restart();
        widget.onScoreUpdate();
        increaseVelocityIfValid();
      }
      if (!gate2.currentState.onScreen) {
        gate2.currentState.restart();
        widget.onScoreUpdate();
        increaseVelocityIfValid();
      }
      if (gate1.currentState.isInside(birdKey.currentState.getAsRect()) ||
          gate2.currentState.isInside(birdKey.currentState.getAsRect())) {
        birdKey.currentState.kill();
      }
      if (!birdKey.currentState.alive) {
        setState(() {
          timer.cancel();
          hasStarted = false;
        });
      }
    });
  }

  void increaseVelocityIfValid() {
    var score = widget.scoreFunction();
    if (score > 0 && score % 10 == 0 && score < 101) {
      gate1.currentState.increaseVelocity();
      gate2.currentState.increaseVelocity();
    }

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
          Bird(
            key: birdKey,
            duration: duration,
            initialPosition: Offset(0.25, 0.5),
            size: 0.1,
          ),
          Gate(
            key: gate1,
            position: 0.75,
            duration: duration,
          ),
          Gate(
            key: gate2,
            position: 0.75 + 0.5 + 0.2,
            duration: duration,
          ),
          Container(
              alignment: Alignment(0, -0.25),
              child: hasStarted
                  ? null
                  : Text(
                      "T A P  T O  S T A R T",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
        ]),
      ),
    );
  }
}
