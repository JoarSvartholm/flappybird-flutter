import 'package:flappybird/preferences.dart';
import 'package:flutter/material.dart';

class SimpleScoreBoard extends StatefulWidget {

  SimpleScoreBoard({Key key}) : super(key: key);

  @override
  SimpleScoreBoardState createState() => SimpleScoreBoardState();
}

class SimpleScoreBoardState extends State<SimpleScoreBoard> {
  int score = 0;
  int best = preferences.bestScore;

  void increaseScore() async {
    score += 1;
    if (score > best) {
      best = score;
      preferences.bestScore = best;
    }
    setState(() { });
  }

  void reset() {
    setState(() {
      score = 0;
    });
  }

  int getScore() {
    return score;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Score",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  score.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              )
            ]),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Best",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                best.toString(),
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            )
          ],
        )
      ],
    );
  }
}
