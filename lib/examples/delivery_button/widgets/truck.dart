import 'package:flutter/material.dart';
import 'dart:math' as math;

class TruckWidget extends StatelessWidget {
  const TruckWidget({super.key, this.doorsDegree = 0, this.opacity = 0});

  /// 0 doors closed
  /// 220 doors open
  final double doorsDegree;

  /// 0 transparent
  /// 1 lights on
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.5,
      child: CustomPaint(
        foregroundPainter: Truck(opacity: opacity, doorsDegree: doorsDegree),
        child: const SizedBox(
          height: 50,
          width: 150,
        ),
      ),
    );
  }
}

class Truck extends CustomPainter {
  Truck({this.doorsDegree = 0, this.opacity = 0});

  // 0 doors closed
  // 220 doors open
  final double doorsDegree;

  // 0 transparent
  // 1 lights on
  final double opacity;

  final lineWidth = 25;

  @override
  void paint(Canvas canvas, Size size) {
    //Create paint 1 for the truck box
    final boxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cabin1Paint = Paint()
      ..color = const Color(0xFF86AFEA)
      ..style = PaintingStyle.fill;

    final cabin2Paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final cabin3Paint = Paint()
      ..color = const Color(0xFF003B9F)
      ..style = PaintingStyle.fill;

    final doorsPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    //Create a square box with border radius
    final box = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 75, 50), const Radius.circular(2));
    //Draw the box
    canvas.drawRRect(box, boxPaint);

    //Draw Cabin
    final pathCabin = Path();
    //Positioned in 76,0
    pathCabin.moveTo(76, 0);
    //draw line to 100,0
    pathCabin.lineTo(100, 0);
    // draw arc to 105, 5
    pathCabin.arcToPoint(const Offset(105, 10),
        radius: const Radius.circular(10));
    //draw line to 105, 45
    pathCabin.lineTo(105, 40);
    //draw arc to 100, 50
    pathCabin.arcToPoint(const Offset(100, 50),
        radius: const Radius.circular(10));
    //draw line to 76, 50
    pathCabin.lineTo(76, 50);
    //draw line to 76, 0
    pathCabin.lineTo(76, 0);
    pathCabin.close();
    //Draw the path
    canvas.drawPath(pathCabin, cabin3Paint);

    //Draw glass
    final pathGlass = Path();
    //Positioned 76, 0
    pathGlass.moveTo(76, 0);
    //Create arc to 96, 20
    pathGlass.arcToPoint(const Offset(96, 15),
        radius: const Radius.circular(15));
    //Create line to 96, 30
    pathGlass.lineTo(96, 35);
    //Create arc to 76, 50
    pathGlass.arcToPoint(const Offset(76, 50),
        radius: const Radius.circular(15));
    //Create line to 76, 0
    pathGlass.lineTo(76, 0);
    pathGlass.close();
    //Draw the path
    canvas.drawPath(pathGlass, cabin2Paint);

    //Draw cabin
    final path = Path();
    //Positioned in right 76 and top 0
    path.moveTo(76, 0);
    //Create arc to 86, 10
    path.arcToPoint(const Offset(86, 10), radius: const Radius.circular(10));
    //Create line to 86, 40
    path.lineTo(86, 40);
    //Create arc to 76, 50
    path.arcToPoint(const Offset(76, 50), radius: const Radius.circular(10));
    //Create line to 76, 0
    path.lineTo(76, 0);
    path.close();
    //Draw the path
    canvas.drawPath(path, cabin1Paint);

    //Draw lights
    final pathLights = Path();
    //Positioned in 105,5
    pathLights.moveTo(103, 7);
    //draw line to 105,5
    pathLights.lineTo(106, 7);
    //draw line to 105, 10
    pathLights.lineTo(106, 17);
    //draw line to 104, 10
    pathLights.lineTo(103, 17);
    //draw line to 104, 5
    pathLights.lineTo(103, 7);
    //Draw the path
    canvas.drawPath(pathLights, boxPaint);

    //Positioned in 105,5
    pathLights.moveTo(103, 43);
    //draw line to 105,5
    pathLights.lineTo(106, 43);
    //draw line to 105, 10
    pathLights.lineTo(106, 33);
    //draw line to 104, 10
    pathLights.lineTo(103, 33);
    //draw line to 104, 5
    pathLights.lineTo(103, 43);
    pathLights.close();
    //Draw the path
    canvas.drawPath(pathLights, boxPaint);

    //Draw line with angle
    final pathDoors = Path();
    //Move to 0,0
    pathDoors.moveTo(3, 3);
    final positionInRadian = doorsDegree.clamp(0, 210) * math.pi / 180;
    Offset startPoint = Offset(lineWidth * math.cos(positionInRadian) + 3,
        lineWidth * math.sin(positionInRadian) + 3);
    pathDoors.lineTo(startPoint.dx, startPoint.dy);
    canvas.drawPath(pathDoors, doorsPaint);

    pathDoors.moveTo(3, 47);
    final positionInRadian2 =
        ((doorsDegree + 20).clamp(0, 210) + 90) * math.pi / 180;
    Offset startPoint2 = Offset(lineWidth * math.sin(positionInRadian2) + 3,
        lineWidth * math.cos(positionInRadian2) + 47);
    pathDoors.lineTo(startPoint2.dx, startPoint2.dy);
    pathDoors.close();
    canvas.drawPath(pathDoors, doorsPaint);

    //Draw lights
    final gradient = LinearGradient(
      colors: [Colors.transparent, Colors.yellow.withOpacity(opacity)],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
    );

    final lightPath = Path();

    lightPath.moveTo(105, 10);
    lightPath.lineTo(150, 0);
    lightPath.lineTo(150, 24);
    lightPath.lineTo(105, 14);
    lightPath.lineTo(105, 7);

    canvas.drawPath(
      lightPath,
      Paint()..shader = gradient.createShader(lightPath.getBounds()),
    );

    lightPath.moveTo(105, 40);
    lightPath.lineTo(150, 50);
    lightPath.lineTo(150, 26);
    lightPath.lineTo(105, 36);
    lightPath.lineTo(105, 43);
    lightPath.close();
    canvas.drawPath(
      lightPath,
      Paint()..shader = gradient.createShader(lightPath.getBounds()),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
