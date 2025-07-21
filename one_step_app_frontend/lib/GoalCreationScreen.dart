import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HomeDashboardScreen.dart';
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
      print('JWT token not found.');
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

    print("Full JSON to send: ${jsonEncode(goalData)}");

    final response = await http.post(
      Uri.parse('http://192.168.1.121:8080/api/goals/create'), // Adjust if needed
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
        print('Error: goalId is null after creation.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: goalId is null')),
        );
        return;
      }

      print('Goal created: ID = $goalId');

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
        title: const Text('Create New Goal'),
        backgroundColor: const Color(0xff1d2528),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
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
    );
  }
}
