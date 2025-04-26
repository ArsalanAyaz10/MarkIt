import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markit/core/services/pattern_storage_service.dart';
import 'package:markit/views/lockscreen/check_pattern.dart';
import 'package:pattern_lock/pattern_lock.dart';

class SetPattern extends StatefulWidget {
  const SetPattern({super.key});

  @override
  State<SetPattern> createState() => _SetPatternState();
}

class _SetPatternState extends State<SetPattern> {
  bool isConfirming = false;
  List<int>? firstPattern;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PatternStorageService patternStorage = PatternStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Set Pattern')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Text(
              isConfirming ? "Confirm Pattern" : "Set Pattern",
              style: const TextStyle(fontSize: 26),
            ),
          ),
          Flexible(
            child: PatternLock(
              selectedColor: Colors.amber,
              pointRadius: 12,
              onInputComplete: (List<int> input) async {
                if (input.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pattern must be at least 3 points"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                if (!isConfirming) {
                  // First input pattern check
                  setState(() {
                    firstPattern = input;
                    isConfirming = true;
                  });
                } else {
                  // Confirm input 
                  if (listEquals<int>(input, firstPattern)) {
                    // Patterns match, now save
                    await patternStorage.savePattern(input);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pattern set successfully"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Navigate after saving
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckPattern()),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Patterns do not match. Try again."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      firstPattern = null;
                      isConfirming = false;
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
