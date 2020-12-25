import 'package:flutter/material.dart';

class Gate extends StatelessWidget {
  final width;
  final opening;
  final level;
  final position;

  Barrier bottomBarrier;
  Barrier topBarrier;

  Gate({this.width, this.opening, this.level, this.position}) {
    this.bottomBarrier = Barrier(size: level);
    this.topBarrier = Barrier(size: 1-level - opening);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
            duration: Duration(milliseconds: 0),
            alignment: Alignment(position, 1.1), child: this.bottomBarrier),
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
