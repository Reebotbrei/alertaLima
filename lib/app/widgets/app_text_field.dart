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
  final FocusNode? focusNode;
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.iconEye,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onEyeTab,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        hintText: hintText,
        hintStyle: TextStyle(color: const Color.fromARGB(255, 155, 154, 154)),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        suffixIcon: iconEye != null
            ? IconButton(
                icon: Icon(iconEye, color: AppColors.primary),
                onPressed: onEyeTab,
              )
            : null,
      ),
    );
  }
}
