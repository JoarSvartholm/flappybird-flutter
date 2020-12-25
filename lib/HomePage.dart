import 'dart:async';

import 'package:flappybird/bird.dart';
import 'package:flappybird/game.dart';
import 'package:flappybird/score.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SimpleScoreBoardState> scoreKey =
      GlobalKey(debugLabel: "Simple score board");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: MainGame(onScoreReset: () {
                scoreKey.currentState.reset();
              }, onScoreUpdate: () {
                scoreKey.currentState.increaseScore();
              })),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
              child: Container(
                  color: Colors.brown, child: SimpleScoreBoard(key: scoreKey)))
        ],
      ),
    );
  }
}
