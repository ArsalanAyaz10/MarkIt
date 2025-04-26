import 'package:flutter/material.dart';
import 'package:markit/models/worker.dart';

class AddWorkerBottomSheet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController contactController;
  final TextEditingController wageController;
  final Future<void> Function(Worker) onSubmit;

  const AddWorkerBottomSheet({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.contactController,
    required this.wageController,
    required this.onSubmit,
  });

  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Worker Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Contact Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: wageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Wage',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  ageController.text.isNotEmpty &&
                  contactController.text.isNotEmpty &&
                  wageController.text.isNotEmpty) {
                Worker newWorker = Worker(
                  id: generateId(),
                  name: nameController.text,
                  age: int.parse(ageController.text),
                  contactNumber: contactController.text,
                  wage: double.parse(wageController.text),
                );

                await onSubmit(newWorker);

                nameController.clear();
                ageController.clear();
                contactController.clear();
                wageController.clear();

                Navigator.pop(context);
              }
            },
            child: const Text('Add Worker'),
          ),
        ],
      ),
    );
  }
}
