import 'package:flutter/material.dart';
import 'package:markit/Widgets/add_worker_bottom_sheet.dart';
import 'package:markit/core/services/worker_storage_service.dart';
import 'package:markit/models/worker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkerStorageService workerService = WorkerStorageService();

  void _openAddWorkerBottomSheet(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final contactController = TextEditingController();
    final wageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddWorkerBottomSheet(
          nameController: nameController,
          ageController: ageController,
          contactController: contactController,
          wageController: wageController,
          onSubmit: (Worker worker) async {
            List<Worker> existingWorkers = await workerService.loadWorkerData();
            existingWorkers.add(worker);
            await workerService.saveWorkerData(existingWorkers);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '✅ Worker "${worker.name}" added successfully!',
                  ),
                ),
              );
              setState(() {}); // Refresh UI
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddWorkerBottomSheet(context),
        splashColor: Colors.amberAccent[500],
        elevation: 2,
        backgroundColor: Colors.amber,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        height: 50,
        elevation: 2,
        padding: const EdgeInsets.all(8),
        color: Colors.yellow[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.amberAccent[100],
        centerTitle: true,
        title: const Text(
          "MarkIt",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WorkerListView(workerService: workerService),
    );
  }
}

class WorkerListView extends StatefulWidget {
  final WorkerStorageService workerService;

  const WorkerListView({super.key, required this.workerService});

  @override
  State<WorkerListView> createState() => _WorkerListViewState();
}

class _WorkerListViewState extends State<WorkerListView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Worker>>(
          future: widget.workerService.loadWorkerData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No workers found'));
            } else {
              final workers = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final worker = workers[index];
                  return SingleChildScrollView(
                    child: SafeArea(
                      child: Card(
                        color: Colors.amber[200],
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10),
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.person, size: 20),
                          title: Text(
                            worker.name,
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          autofocus: true,
                          dense: true,
                          iconColor: Colors.blueGrey,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () async {
                              List<Worker> updatedWorkers =
                                  await widget.workerService.loadWorkerData();
                              updatedWorkers.removeAt(index);
                              await widget.workerService.saveWorkerData(
                                updatedWorkers,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✅ Worker "${worker.name}" removed successfully!',
                                  ),
                                ),
                              );
                              setState(() {}); // Refresh UI
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
