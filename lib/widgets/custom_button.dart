import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final child;
  final onPressed;
  const CustomButton({
    super.key, required this.child, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
          backgroundColor: deepBlue,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
