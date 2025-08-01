import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'goal_details_screen.dart';

class GoalCreationScreen extends StatefulWidget {
  const GoalCreationScreen({Key? key}) : super(key: key);

  @override
  _GoalCreationScreenState createState() => _GoalCreationScreenState();
}

class _GoalCreationScreenState extends State<GoalCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool isSubmitting = false;

  Future<void> _submitGoal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    final token = await secureStorage.read(key: 'jwt');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final goalData = {
      'title': _nameController.text,
      'goalDescription': _descController.text,
      'goalStatus': 'IN_PROGRESS',
    };

    final response = await http.post(
      Uri.parse('http://192.168.1.11:8080/api/goals/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(goalData),
    );

    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 200) {
      final goalJson = jsonDecode(response.body);
      final goalId = goalJson['goalId'];
      final title = goalJson['title'];
      final description = goalJson['goalDescription'];

      if (goalId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: goalId is null')),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GoalDetailsScreen(
            goalId: goalId.toString(),
            goalTitle: title ?? '',
            goalDescription: description ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      appBar: AppBar(
        title: const Text('Create New Goal', 
          style: const TextStyle(
            fontFamily: 'JetBrainsMono Nerd Font',
            color: Colors.white,
           ),
        ),
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Goal Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Goal Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _submitGoal,
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
                        : const Text('Create Goal'),
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
