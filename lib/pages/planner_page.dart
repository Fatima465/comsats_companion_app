import 'package:flutter/material.dart';
import '../services/planner_service.dart';
import '../models/planner_model.dart';
import '../utils/constants.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final _service = PlannerService();

  void _showAddDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSecondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add New Plan", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            TextField(
              controller: titleController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Title", labelStyle: TextStyle(color: Colors.white70)),
            ),
            TextField(
              controller: descController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(), // PRECONDITION: No past dates
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) selectedDate = picked;
                    },
                    label: const Text("Date"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) selectedTime = picked;
                    },
                    label: const Text("Time"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                
                await _service.addPlanner(
                  title: titleController.text,
                  description: descController.text,
                  date: selectedDate,
                  time: selectedTime.format(context),
                );
                
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Save Plan", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Planner")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<PlannerModel>>(
        stream: _service.getPlannersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final plans = snapshot.data ?? [];
          if (plans.isEmpty) return _buildEmptyView();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                color: kSecondaryColor,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    child: Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(plan.title, 
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: Text(
                    "${DateFormat('MMM dd, yyyy').format(plan.planDate)} at ${plan.planTime}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _service.deletePlanner(plan.id),
                  ),
                  onTap: () => _showDetailDialog(plan),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetailDialog(PlannerModel plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSecondaryColor,
        title: Text(plan.title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${DateFormat('EEEE, MMM dd').format(plan.planDate)}", 
              style: const TextStyle(color: Colors.white70)),
            Text("Time: ${plan.planTime}", 
              style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white24, height: 20),
            const Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 5),
            Text(plan.description.isEmpty ? "No description provided." : plan.description,
              style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Close", style: TextStyle(color: kPrimaryColor))
          )
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 80, color: Colors.white30),
          SizedBox(height: 20),
          Text("No Tasks Yet", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Click the + button to stay organized.", style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}

class DateFormat {
  DateFormat(String s);
  
  format(DateTime planDate) {}
}