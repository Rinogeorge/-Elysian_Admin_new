import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final int day;
  final bool isSelected;
  final VoidCallback onTap;

  const DaySelector({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.wb_sunny : Icons.wb_cloudy,
              color: isSelected ? Colors.yellowAccent : Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Day $day',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
