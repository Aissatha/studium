import 'package:flutter/material.dart';

import '../widgets/message_bubble.dart';
import '../widgets/conversation_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.conversation});

  final ConversationUiModel conversation;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _input = TextEditingController();

  final List<ChatMessageUiModel> _messages = [
    ChatMessageUiModel(
      id: '1',
      sender: 'Sophie Martin',
      message: "Bonjour Marie ! J'espère que vous allez bien.",
      time: '14:30',
      isOwn: false,
    ),
    ChatMessageUiModel(
      id: '2',
      sender: 'Sophie Martin',
      message:
      "Nous avons examiné votre profil et nous sommes très intéressés par votre candidature pour le poste de développeuse frontend.",
      time: '14:31',
      isOwn: false,
    ),
    ChatMessageUiModel(
      id: '3',
      sender: 'Marie',
      message:
      "Bonjour Sophie ! Merci beaucoup pour votre message. Je suis très intéressée par cette opportunité.",
      time: '14:35',
      isOwn: true,
    ),
    ChatMessageUiModel(
      id: '4',
      sender: 'Sophie Martin',
      message:
      "Parfait ! Seriez-vous disponible pour un entretien cette semaine ? Nous pourrions organiser un appel vidéo.",
      time: '14:32',
      isOwn: false,
    ),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageUiModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: 'Marie',
          message: text,
          time: _hhmm(),
          isOwn: true,
        ),
      );
      _input.clear();
    });
  }

  String _hhmm() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conversation;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF3F4F6)),
                  child: const Icon(Icons.person, color: Color(0xFF6B7280)),
                ),
                if (c.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.online ? const Color(0xFF22C55E) : const Color(0xFF9CA3AF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        c.online ? 'En ligne' : 'Hors ligne',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: call action
            },
            icon: const Icon(Icons.phone, color: Color(0xFF111827)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              itemCount: _messages.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MessageBubble(message: _messages[i]),
              ),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: attach file
                  },
                  icon: const Icon(Icons.attach_file, color: Color(0xFF9CA3AF)),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _input,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            decoration: const InputDecoration(
                              hintText: 'Tapez votre message...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _send,
                          icon: const Icon(Icons.send, color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageUiModel {
  final String id;
  final String sender;
  final String message;
  final String time;
  final bool isOwn;

  ChatMessageUiModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.isOwn,
  });
}
