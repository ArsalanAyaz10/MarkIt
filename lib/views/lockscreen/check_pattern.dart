import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markit/core/services/pattern_storage_service.dart'; 
import 'package:markit/views/home/home_screen.dart';
import 'package:pattern_lock/pattern_lock.dart';

class CheckPattern extends StatefulWidget {
  const CheckPattern({super.key});

  @override
  State<CheckPattern> createState() => _CheckPatternState();
}

class _CheckPatternState extends State<CheckPattern> {
  List<int>? savedPattern;
  bool isLoading = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadSavedPattern();
  }

  Future<void> loadSavedPattern() async {
    PatternStorageService patternStorage = PatternStorageService();
    List<int>? loadedPattern = await patternStorage.getPattern();

    setState(() {
      savedPattern = loadedPattern;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("Check Pattern")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: const Text(
              "Draw your pattern",
              style: TextStyle(fontSize: 26),
            ),
          ),
          Flexible(
            child: PatternLock(
              selectedColor: Colors.red,
              pointRadius: 8,
              showInput: true,
              dimension: 3,
              relativePadding: 0.7,
              selectThreshold: 25,
              fillPoints: true,
              onInputComplete: (List<int> input) {
                if (listEquals<int>(input, savedPattern)) {
                  // Pattern matched
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Pattern does not match",
                        style: TextStyle(color: Colors.red),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
