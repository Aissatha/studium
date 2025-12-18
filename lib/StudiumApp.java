import 'package:flutter/material.dart';

import 'core/config/routes.dart';
import 'features/applications/presentation/pages/applications_list_page.dart';
import 'features/messaging/presentation/pages/conversations_page.dart';

class StudiumApp extends StatelessWidget {
  const StudiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studium',
      debugShowCheckedModeBanner: false,

      // Page de départ
      initialRoute: Routes.applicationsList,

      // Routes nommées
      routes: {
        Routes.applicationsList: (_) => const ApplicationsListPage(),
        Routes.conversations: (_) => const ConversationsPage(), // ✅ ICI
      },

      // Fallback si route inconnue
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Page introuvable')),
        ),
      ),
    );
  }
}
