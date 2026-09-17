import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class FilterChipBar extends StatefulWidget {
  final Function(String) onFilterSelected;

  const FilterChipBar({super.key, required this.onFilterSelected});

  @override
  State<FilterChipBar> createState() => _FilterChipBarState();
}

class _FilterChipBarState extends State<FilterChipBar> {
  int _selectedIndex = 0;
  final List<String> _filters = ['For You', 'Chill', 'Workout', 'Focus', 'Sleep', 'Offline Vault'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onFilterSelected(_filters[index]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightPillDark : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: isSelected ? AppColors.lightPillDark : AppColors.lightBorder,
                ),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? AppColors.lightPillText : AppColors.lightTextSub,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
