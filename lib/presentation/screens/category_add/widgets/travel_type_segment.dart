import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class TravelTypeSegment extends StatelessWidget {
  final TravelType selectedType;
  final Function(TravelType) onTypeChanged;

  const TravelTypeSegment({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSegmentButton(
            context,
            type: TravelType.domestic,
            icon: Icons.train,
            label: 'Domestic',
            isSelected: selectedType == TravelType.domestic,
          ),
          const SizedBox(width: 8),
          _buildSegmentButton(
            context,
            type: TravelType.international,
            icon: Icons.flight,
            label: 'International',
            isSelected: selectedType == TravelType.international,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    BuildContext context, {
    required TravelType type,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A7FD9) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF4A7FD9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF4A7FD9),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
