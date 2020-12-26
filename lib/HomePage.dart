import 'package:flappybird/game.dart';
import 'package:flappybird/score.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
              }, scoreFunction: () {
                return scoreKey.currentState.getScore();
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
