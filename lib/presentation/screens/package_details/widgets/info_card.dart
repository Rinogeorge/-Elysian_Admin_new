import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String? subLabel;
  final IconData? icon;
  final Widget? customIcon;
  final Color backgroundColor;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.label,
    this.subLabel,
    this.icon,
    this.customIcon,
    required this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Fixed width as per design roughly
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customIcon != null)
            customIcon!
          else if (icon != null)
            Icon(icon, color: iconColor ?? Colors.black54, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          if (subLabel != null)
            Text(
              subLabel!,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
