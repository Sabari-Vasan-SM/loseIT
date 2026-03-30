import 'package:flutter/material.dart';
import 'package:lose_it/features/post/models/post_model.dart';
import 'package:lose_it/core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final ItemStatus status;
  final bool isLarge;

  const StatusBadge({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  Color get _color {
    switch (status) {
      case ItemStatus.lost:
        return AppTheme.lostColor;
      case ItemStatus.found:
        return AppTheme.foundColor;
      case ItemStatus.police:
        return AppTheme.policeColor;
    }
  }

  IconData get _icon {
    switch (status) {
      case ItemStatus.lost:
        return Icons.search_rounded;
      case ItemStatus.found:
        return Icons.check_circle_outline_rounded;
      case ItemStatus.police:
        return Icons.local_police_outlined;
    }
  }

  String get _label {
    switch (status) {
      case ItemStatus.lost:
        return 'Lost';
      case ItemStatus.found:
        return 'Found';
      case ItemStatus.police:
        return 'Police';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 10,
        vertical: isLarge ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: isLarge ? 18 : 14, color: _color),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: isLarge ? 14 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
