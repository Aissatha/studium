import 'package:flutter/material.dart';

import '../pages/chat_page.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final ChatMessageUiModel message;

  @override
  Widget build(BuildContext context) {
    final m = message;
    final isOwn = m.isOwn;

    final bg = isOwn ? const Color(0xFF2563EB) : const Color(0xFFF3F4F6);
    final fg = isOwn ? Colors.white : const Color(0xFF111827);
    final timeColor = isOwn ? const Color(0xFFBFDBFE) : const Color(0xFF6B7280);

    return Row(
      mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isOwn ? 18 : 6),
                bottomRight: Radius.circular(isOwn ? 6 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(m.message, style: TextStyle(color: fg, fontSize: 13, height: 1.25)),
                const SizedBox(height: 6),
                Text(m.time, style: TextStyle(color: timeColor, fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
