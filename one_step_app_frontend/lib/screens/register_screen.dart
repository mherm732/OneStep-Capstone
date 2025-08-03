import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_step_app_flutter/screens/HomeDashboardScreen.dart';
import 'package:one_step_app_flutter/environment.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<String?> registerUser(String name, String email, String password) async {
  const String baseUrl = Environment.apiBaseUrl; 
  final Uri url = Uri.parse('$baseUrl/api/auth/register');

  try {
    print('sending POST request to url');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? token = responseData['token']; 

      if(token != null) {
        await secureStorage.write(key: 'jwt', value: token);
        print('Registration successful. Token saved');
        return token;
      } else {
          print("No token found in response.");
          return null;
      }
    } else {
      print(' Registration failed: ${response.statusCode}');
      print('Body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Network error: $e');
    return null;
  }
}

void _submitForm() async {
  print('SUBMIT BUTTON CLICKED');

  if (_formKey.currentState!.validate()) {
    print('FORM VALID');

    _formKey.currentState!.save();

    print('Name: $name, Email: $email, Password: $password');

    String? token = await registerUser(name, email, password);

    if (token != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
      );
    } else if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  } else {
    print('FORM INVALID');
  }
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1d2528),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
        Navigator.pop(context); 
          },
        ),
      ),
      body: Row(
        children: [
           Container(
            width: screenWidth * 0.4,
            color: const Color(0xffd5d1bf),
            child: Center(
              child: Text(
                'One Step',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono Nerd Font',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff1d2528),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xff1d2528),
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create an account',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono Nerd Font',
                      fontSize: 36,
                      color: const Color(0xffe6e6e6),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Name',
                          onSaved: (val) => name = val!,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (val) => email = val!,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: 'Password',
                          obscureText: true,
                          onSaved: (val) => password = val!,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffd9f316),
                            foregroundColor: const Color(0xff1d2528),
                            textStyle: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xffe6e6e6)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff707070)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffd9f316), width: 2),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      onSaved: onSaved,
    );
  }
}
