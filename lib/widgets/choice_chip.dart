import 'package:flutter/material.dart';

class ChoiceChipGroup extends StatelessWidget {
  const ChoiceChipGroup({
    super.key,
    required this.items,
    required this.selected,
    required this.onTap,
  });

  final List<String> items;
  final String selected;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        final isSelected = item == selected;

        return GestureDetector(
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffa67868) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color(0xffa67868), width: 2),
            ),
            child: Text(
              isSelected ? '✓ $item' : item,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
