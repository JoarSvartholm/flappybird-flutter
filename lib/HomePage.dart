import 'dart:async';

import 'package:flappybird/barrier.dart';
import 'package:flappybird/bird.dart';
import 'package:flappybird/score.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<BirdState> birdKey = GlobalKey(debugLabel: "Bird");
  final GlobalKey<SimpleScoreBoardState> scoreKey =
      GlobalKey(debugLabel: "Simple score board");
  int refreshRate = 50;
  static final Duration duration = Duration(milliseconds: 50);

  double barrier1 = 1;
  double barrier2 = 3;

  bool hasStarted = false;

  void startGame() {
    setState(() {
      hasStarted = true;
    });
    scoreKey.currentState.reset();
    barrier1 = 1;
    barrier2 = barrier1 + 2;
    birdKey.currentState.reset();
    Timer.periodic(duration, (timer) {
      birdKey.currentState.step();
      if (!birdKey.currentState.alive) {
        _stopGame(timer);
      }
      setState(() {
        barrier1 -= 0.05;
        barrier2 -= 0.05;
        if (barrier1 < -1.5) {
          barrier1 = 2.5;
          scoreKey.currentState.increaseScore();
        }
        if (barrier2 < -1.5) {
          barrier2 = 2.5;
          scoreKey.currentState.increaseScore();
        }
      });
      /*if (birdHeight > 1) {
        _stopGame(timer);
      }
      if ((barrier1 - birdPosition).abs() < 0.1) {
        if (birdHeight > 0.5) {
          _stopGame(timer);
        }
      }
      if ((barrier2 - birdPosition).abs() < 0.1) {
        if (birdHeight > 0.4) {
          _stopGame(timer);
        }
      }*/
    });
  }

  void _stopGame(Timer timer) {
    timer.cancel();
    hasStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('main'),
      onTap: () {
        if (hasStarted) {
          birdKey.currentState.fly();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(children: [
                  Container(
                    color: Colors.blue,
                  ),
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
                ])),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
                    color: Colors.brown,
                    child: SimpleScoreBoard(key: scoreKey)))
          ],
        ),
      ),
    );
  }
}
