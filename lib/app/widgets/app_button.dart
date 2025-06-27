import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFilled;
  final bool isDisabled;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFilled = true,
    this.isDisabled = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isDisabled
          ? AppColors.disabled
          : (isFilled ? AppColors.button : Colors.transparent),
      foregroundColor: isFilled ? AppColors.buttonText : AppColors.primary,
      side: isFilled
          ? null
          : const BorderSide(color: AppColors.primary, width: 2),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: Size(width ?? double.infinity, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: buttonStyle,
      child: Text(label),
    );
  }
}
