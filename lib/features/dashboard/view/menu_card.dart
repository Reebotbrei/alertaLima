import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color colorIcono;
  final Color fondo;
  final Color texto;
  
  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.colorIcono,
    required this.fondo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: colorIcono),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: texto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
