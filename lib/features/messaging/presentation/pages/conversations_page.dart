import 'package:flutter/material.dart';

import '../widgets/conversation_tile.dart';
import 'chat_page.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  static final List<ConversationUiModel> conversations = [
    ConversationUiModel(
      id: '1',
      name: 'Sophie Martin',
      company: 'TechCorp Solutions',
      lastMessage:
      'Bonjour Marie, nous aimerions planifier un entretien avec vous pour le poste de développeuse frontend.',
      time: '14:32',
      unread: 2,
      avatarUrl: null,
      online: true,
    ),
    ConversationUiModel(
      id: '2',
      name: 'Alexandre Dubois',
      company: 'StartupLab',
      lastMessage:
      'Merci pour votre candidature. Pouvez-vous nous envoyer votre portfolio ?',
      time: '11:45',
      unread: 0,
      avatarUrl: null,
      online: false,
    ),
    ConversationUiModel(
      id: '3',
      name: 'Camille Rousseau',
      company: 'Digital Agency Pro',
      lastMessage: 'Félicitations ! Nous souhaitons vous proposer le poste.',
      time: 'Hier',
      unread: 0,
      avatarUrl: null,
      online: true,
    ),
    ConversationUiModel(
      id: '4',
      name: 'Thomas Leroy',
      company: 'Innovation Hub',
      lastMessage:
      'Nous avons bien reçu votre dossier et vous recontacterons prochainement.',
      time: 'Lundi',
      unread: 0,
      avatarUrl: null,
      online: false,
    ),
    ConversationUiModel(
      id: '5',
      name: 'Julie Moreau',
      company: 'WebDesign Studio',
      lastMessage:
      'Bonjour, nous organisons un événement networking jeudi prochain. Êtes-vous intéressée ?',
      time: 'Dimanche',
      unread: 0,
      avatarUrl: null,
      online: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: action search / filter
            },
            icon: const Icon(Icons.search, color: Color(0xFF111827)),
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          // Conversations
          ...conversations.map(
                (c) => ConversationTile(
              conversation: c,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatPage(conversation: c),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Empty-ish section + tip (comme React)
          _StayConnectedCard(),
          const SizedBox(height: 14),
          _QuickTipCard(),
        ],
      ),
    );
  }
}

class _StayConnectedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: const [
          SizedBox(height: 4),
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFDBEAFE),
            child: Icon(Icons.chat_bubble_outline, color: Color(0xFF2563EB), size: 28),
          ),
          SizedBox(height: 12),
          Text(
            'Restez connecté',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Communiquez directement avec les recruteurs et ne manquez aucune opportunité professionnelle.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF4B5563), height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _QuickTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFF5F3FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conseil',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Répondez rapidement aux messages pour montrer votre motivation !',
                  style: TextStyle(color: Color(0xFF4B5563)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
