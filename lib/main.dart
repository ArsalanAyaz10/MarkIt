import 'package:flutter/material.dart';
import 'package:markit/views/lockscreen/check_pattern.dart';
import 'package:markit/views/lockscreen/set_pattern.dart';
import 'package:markit/core/services/pattern_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> decideHome() async {
    PatternStorageService patternStorage = PatternStorageService();
    bool hasPattern = await patternStorage.isPatternSet();

    if (hasPattern) {
      return const CheckPattern();
    } else {
      return const SetPattern();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markit',
      home: FutureBuilder<Widget>(
        future: decideHome(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          }
        },
      ),
    );
  }
}
