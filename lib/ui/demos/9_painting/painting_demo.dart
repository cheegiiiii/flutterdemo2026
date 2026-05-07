import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class PaintingDemo extends StatefulWidget {
  const PaintingDemo({super.key});

  @override
  State<PaintingDemo> createState() => _PaintingDemoState();
}

// class _PaintingDemoState extends State<PaintingDemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(),
//       // body: Center(
//       //   child: Container(
//       //     // color: Colors.cyan,
//       //     child: ProgressBar(
//       //       barColor: Colors.blue,
//       //       thumbColor: Colors.red,
//       //       thumbSize: 20.0,
//       //     ),
//       //   ),
//       // ),
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
//           child: CustomPaint(size: Size(300, 300), painter: MyPainter()),
//         ),
//       ),
//     );
//   }
// }

// class MyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final path = Path()
//       ..moveTo(50, 50)
//       // ..lineTo(200, 200)
//       // ..quadraticBezierTo(30, 150, 150, 100)
//       // ..quadraticBezierTo(270, 50, 240, 150);
//       ..cubicTo(30, 150, 270, 50, 240, 150);

//     final paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;
//     canvas.drawPath(path, paint);
//   }

class _PaintingDemoState extends State<PaintingDemo> {
  Offset startPoint = const Offset(50, 50);
  Offset controlPoint1 = const Offset(30, 150); // BLUE
  Offset controlPoint2 = const Offset(270, 50); // RED
  Offset endPoint = const Offset(240, 150);

  int? selectedPoint;

  void _selectPoint(Offset tapPosition) {
    const radius = 25.0;

    if ((tapPosition - controlPoint1).distance <= radius) {
      selectedPoint = 1;
    } else if ((tapPosition - controlPoint2).distance <= radius) {
      selectedPoint = 2;
    } else {
      selectedPoint = null;
    }
  }

  void _movePoint(Offset position) {
    setState(() {
      if (selectedPoint == 1) {
        controlPoint1 = position;
      } else if (selectedPoint == 2) {
        controlPoint2 = position;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Bezier Control Points")),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          child: GestureDetector(
            onPanStart: (details) {
              _selectPoint(details.localPosition);
            },
            onPanUpdate: (details) {
              _movePoint(details.localPosition);
            },
            child: CustomPaint(
              size: const Size(300, 300),
              painter: MyPainter(
                startPoint: startPoint,
                controlPoint1: controlPoint1,
                controlPoint2: controlPoint2,
                endPoint: endPoint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({
    required this.startPoint,
    required this.controlPoint1,
    required this.controlPoint2,
    required this.endPoint,
  });

  final Offset startPoint;
  final Offset controlPoint1;
  final Offset controlPoint2;
  final Offset endPoint;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

    final curvePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, curvePaint);

    // Helper lines
    // final helperPaint = Paint()
    //   ..color = Colors.grey
    //   ..strokeWidth = 1;

    // canvas.drawLine(startPoint, controlPoint1, helperPaint);
    // canvas.drawLine(endPoint, controlPoint2, helperPaint);

    // Blue control point
    final bluePaint = Paint()..color = Colors.blue;
    canvas.drawCircle(controlPoint1, 6, bluePaint);

    // Red control point
    final redPaint = Paint()..color = Colors.red;
    canvas.drawCircle(controlPoint2, 6, redPaint);

    // Start and end points
    // final blackPaint = Paint()..color = Colors.black;
    // canvas.drawCircle(startPoint, 6, blackPaint);
    // canvas.drawCircle(endPoint, 6, blackPaint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.controlPoint1 != controlPoint1 ||
        oldDelegate.controlPoint2 != controlPoint2 ||
        oldDelegate.startPoint != startPoint ||
        oldDelegate.endPoint != endPoint;
  }
}

@override
bool shouldRepaint(CustomPainter old) {
  return false;
}

class ProgressBar extends LeafRenderObjectWidget {
  const ProgressBar({
    super.key,
    required this.barColor,
    required this.thumbColor,
    this.thumbSize = 20.0,
  });

  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderProgressBar renderObject,
  ) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}

class RenderProgressBar extends RenderBox {
  RenderProgressBar({
    required Color barColor,
    required Color thumbColor,
    required double thumbSize,
  }) : _barColor = barColor,
       _thumbColor = thumbColor,
       _thumbSize = thumbSize {
    // initialize the gesture recognizer
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx / size.width;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Color get barColor => _barColor;
  Color _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbSize => _thumbSize;
  double _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  static const _minDesiredWidth = 100.0;
  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;
  @override
  double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;
  @override
  double computeMinIntrinsicHeight(double width) => thumbSize;
  @override
  double computeMaxIntrinsicHeight(double width) => thumbSize;

  double _currentThumbValue = 0.5;
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // paint bar
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);
    // paint thumb
    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);
    canvas.restore();
  }

  late HorizontalDragGestureRecognizer _drag;
  @override
  bool hitTestSelf(Offset position) => true;
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }
}
