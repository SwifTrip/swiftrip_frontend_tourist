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
                  painter: ,
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
