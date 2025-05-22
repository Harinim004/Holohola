import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_service.dart';
import 'main.dart'; // Ensure this is your home page file

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showError("Passwords do not match.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = await _authService.signUpWithEmailPassword(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Navigate directly to home page after signing up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ARCallHomePage()), // Redirect to home
        );
      }
    } catch (e) {
      _showError("Sign-up failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_nameController, "Full Name", Icons.person),
            _buildTextField(_phoneController, "Phone Number", Icons.phone),
            _buildTextField(_emailController, "Email", Icons.email),
            _buildTextField(_passwordController, "Password", Icons.lock, isPassword: true),
            _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock, isPassword: true),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.blueAccent.withOpacity(0.2),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
