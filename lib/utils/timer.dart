import 'package:flutter/material.dart';
import 'dart:math' as math;

class Timer extends StatefulWidget {

  final int duration;
  final int progress;
  const Timer({Key key, this.duration, this.progress}): super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    if(widget.progress == null) {
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.duration),
      );
    }
    else {
      controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.duration * 60),
      );
    }
    if (widget.progress == null) {
      controller.forward(from: 0);
    }
    else {
      controller.forward(from: widget.progress.toDouble()/600000);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget child) {
              return CustomPaint(
                painter: TimerPainter(
                  animation: controller,
                  backgroundColor: Colors.blueGrey,
                  color: Colors.red,
                )
              );
            },
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    paint.color = color;
    double progress = animation.value;
    canvas.drawLine(Offset(0, size.height / 2), Offset(progress*size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
