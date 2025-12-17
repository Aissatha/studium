import 'package:flutter/material.dart';

import 'status_badge.dart';

class ApplicationCard extends StatelessWidget {
  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  final ApplicationUiModel application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.business, color: Color(0xFF6B7280)),
              // Si tu veux logos: Image.network(application.logoUrl!, fit: BoxFit.cover)
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.company,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              application.position,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right,
                          color: Color(0xFF9CA3AF)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        application.dateLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Spacer(),
                      StatusBadge(status: application.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// UI model local (tu le remplaceras plus tard par ton Domain model)
enum ApplicationStatus { accepted, pending, rejected }

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.accepted:
        return 'Acceptée';
      case ApplicationStatus.pending:
        return 'En attente';
      case ApplicationStatus.rejected:
        return 'Refusée';
    }
  }
}

class ApplicationUiModel {
  final int id;
  final String company;
  final String position;
  final String dateLabel;
  final ApplicationStatus status;
  final String? logoUrl;

  const ApplicationUiModel({
    required this.id,
    required this.company,
    required this.position,
    required this.dateLabel,
    required this.status,
    required this.logoUrl,
  });
}
