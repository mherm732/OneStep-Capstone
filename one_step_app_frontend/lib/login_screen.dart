import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Logging in with: $email, $password');
      // TODO: Add backend login call here
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
             Navigator.pop(context); // Pops current screen and returns to previous
          },
        ),
      ),
      body: Row(
        children: [
          // Left Panel
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

          // Right Panel
          Expanded(
            child: Container(
              color: const Color(0xff1d2528),
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
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
                              fontFamily: 'JetBrainsMono Nerd Font',
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
                          child: const Text('Log In'),
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
