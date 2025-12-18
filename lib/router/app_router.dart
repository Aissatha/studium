import 'package:flutter/material.dart';
import 'package:stadium/features/applications/presentation/pages/applications_list_page.dart';
import 'package:stadium/core/config/routes.dart';


final routes = <String, WidgetBuilder>{
  Routes.applicationsList: (_) => const ApplicationsListPage(),
};
