import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:markit/models/worker.dart';

class WorkerStorageService {
  static const _workerKey = 'workers';

  Future<void> saveWorkerData(List<Worker> workers) async {
    final prefs = await SharedPreferences.getInstance();
    final workerJsonList = workers.map((worker) => jsonEncode(worker.toJson())).toList();

    await prefs.setStringList(_workerKey, workerJsonList);
  }

  Future<List<Worker>> loadWorkerData() async {
  final prefs = await SharedPreferences.getInstance();
  final workerJsonList = prefs.getStringList(_workerKey) ?? [];

  return workerJsonList.map((jsonStr) {
    final jsonMap = jsonDecode(jsonStr);
    return Worker.fromJson(jsonMap);
  }).toList();
}

}
