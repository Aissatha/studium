import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/config/env.dart';
import 'core/network/supabase_client.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charge .env depuis les assets (pubspec.yaml)
  await dotenv.load(fileName: '.env');

  Env.validate();
  await SupabaseClientProvider.init();

  final app = await builder(); // marche pour Widget ou Future<Widget>
  runApp(app);
}
