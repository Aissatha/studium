import 'package:flutter/material.dart';

import 'application_card.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    final style = _style(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: style.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.fg),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: style.fg,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeStyle _style(ApplicationStatus s) {
    switch (s) {
      case ApplicationStatus.accepted:
        return const _BadgeStyle(
          bg: Color(0xFFDCFCE7),
          fg: Color(0xFF15803D),
          border: Color(0xFFBBF7D0),
          icon: Icons.check_circle,
        );
      case ApplicationStatus.pending:
        return const _BadgeStyle(
          bg: Color(0xFFFFEDD5),
          fg: Color(0xFFC2410C),
          border: Color(0xFFFED7AA),
          icon: Icons.schedule,
        );
      case ApplicationStatus.rejected:
        return const _BadgeStyle(
          bg: Color(0xFFFEE2E2),
          fg: Color(0xFFB91C1C),
          border: Color(0xFFFECACA),
          icon: Icons.cancel,
        );
    }
  }
}

class _BadgeStyle {
  final Color bg;
  final Color fg;
  final Color border;
  final IconData icon;

  const _BadgeStyle({
    required this.bg,
    required this.fg,
    required this.border,
    required this.icon,
  });
}
