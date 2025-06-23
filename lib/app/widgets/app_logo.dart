import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 80});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.shield_outlined,
      size: size,
      color: AppColors.primary,
    );
  }
}
