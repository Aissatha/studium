import 'package:flutter/material.dart';
import 'package:studium_app/features/applications/presentation/pages/applications_list_page.dart';
import 'package:studium_app/core/config/routes.dart';

final routes = <String, WidgetBuilder>{
  Routes.applicationsList: (_) => const ApplicationsListPage(),
};
