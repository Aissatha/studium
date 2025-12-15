import 'package:flutter/material.dart';

class StudiumApp extends StatelessWidget {
  const StudiumApp({super.key}); // const OK ici

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studium',
      home: Scaffold(
        body: Center(
          child: Text('Studium App'),
        ),
      ),
    );
  }
}
