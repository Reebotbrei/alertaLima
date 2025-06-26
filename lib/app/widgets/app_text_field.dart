import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final IconData? iconEye;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onEyeTab;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.iconEye,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onEyeTab,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        suffixIcon: iconEye != null
            ? IconButton(icon: Icon(iconEye, color: AppColors.primary),
            onPressed: onEyeTab,)
            : null,
      ),
    );
  }
}
