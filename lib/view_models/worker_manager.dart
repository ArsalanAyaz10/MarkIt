import 'package:flutter/material.dart';
import '../models/worker.dart';


class WorkerManager extends ChangeNotifier {

  final List<Worker> _worker = [];

  List<Worker> get worker => _worker;

  void addWorker(Worker worker) {
    _worker.add(worker);
    
    notifyListeners();
  }

  void removeWorker(String id) {
    _worker.removeWhere((worker) => worker.id == id);
    notifyListeners();
  }

}
