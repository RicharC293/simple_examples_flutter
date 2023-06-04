import 'package:flutter/material.dart';

class Package extends StatelessWidget {
  const Package({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PackagePainter(),
      isComplex: true,
      child: const SizedBox(
        height: 20,
        width: 20,
      ),
    );
  }
}

class PackagePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final packagePaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final ropePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final packageRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(2),
    );
    canvas.drawRRect(packageRect, packagePaint);

    final path = Path();

    path.moveTo(1, 1);
    path.lineTo(size.width - 1, size.height -1);
    canvas.drawPath(path, ropePaint);
    path.moveTo(size.width-1, 1);
    path.lineTo(1, size.height-1);
    canvas.drawPath(path, ropePaint);



  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
