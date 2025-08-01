import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'goal_details_screen.dart';

class StepCreationScreen extends StatefulWidget {
  final String goalId;
  final String title;
  final String description;

  const StepCreationScreen({
    Key? key,
    required this.goalId,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _StepCreationScreenState createState() => _StepCreationScreenState();
}

class _StepCreationScreenState extends State<StepCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _dueDateController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isSubmitting = false;

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dueDateController.text = picked.toIso8601String();
    }
  }

  Future<void> _submitStep() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final token = await secureStorage.read(key: "jwt");
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not authenticated")),
      );
      return;
    }

    final stepData = {
      "stepDescription": _descController.text,
      "dueDate": _dueDateController.text,
      "stepStatus": "IN_PROGRESS",
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.11:8080/api/goals/steps/create/${widget.goalId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(stepData),
    );

    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 200) {
      final stepJson = jsonDecode(response.body);
      final stepId = stepJson['stepId'];

      if (stepId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: stepId is null')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GoalDetailsScreen(
            goalId: widget.goalId,
            goalTitle: widget.title,
            goalDescription: widget.description,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      appBar: AppBar( 
        title: const Text(
          'Create New Step',
          style: TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1d2528),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Step Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dueDateController,
                    readOnly: true,
                    onTap: () => _selectDueDate(context),
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffd9f316),
                      foregroundColor: const Color(0xff1d2528),
                      textStyle: const TextStyle(
                        fontFamily: 'JetBrainsMono Nerd Font',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Create Step'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
