import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;

  const CustomAppBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      title: const Text('Custom Tour Creation'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: CustomPaint(
                  painter: _ProgressPainter(currentStep: currentStep),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => const SizedBox(width: 40),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Text(
                    _getStepName(index),
                    style: TextStyle(
                      color: index <= currentStep ? Colors.blue : Colors.grey,
                      fontWeight: index == currentStep
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepName(int index) {
    switch (index) {
      case 0:
        return 'Destination';
      case 1:
        return 'Agency';
      case 2:
        return 'Planning';
      case 3:
        return 'Summary';
      case 4:
        return 'Payment';
      default:
        return '';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80.0);
}


class _ProgressPainter extends CustomPainter {
  final int currentStep;

  _ProgressPainter({required this.currentStep});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double stepWidth = size.width / 4;
    final double y = size.height / 2;

    for (int i = 0; i < 5; i++) {
      final double x = i * stepWidth;
      final color = i <= currentStep ? Colors.blue : Colors.grey;
      paint.color = color;

      canvas.drawCircle(
        Offset(x, y),
        8,
        paint
          ..style = i <= currentStep
              ? PaintingStyle.fill
              : PaintingStyle.stroke,
      );

      if (i < 4) {
        final double nextX = (i + 1) * stepWidth;
        final lineColor = i < currentStep ? Colors.blue : Colors.grey;
        paint.color = lineColor;
        canvas.drawLine(Offset(x + 10, y), Offset(nextX - 10, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
