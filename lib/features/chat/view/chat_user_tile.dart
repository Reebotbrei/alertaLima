import 'package:alerta_lima/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.buttonText,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(10),
        child: Row(children: [
          const Icon(Icons.person),
          const SizedBox(width: 10),
          Text(text),
        ])
      )
    );
  }
}
