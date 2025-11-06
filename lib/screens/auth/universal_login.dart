import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dashboards/patient_dashboard.dart';
import '../dashboards/doctor_dashboard.dart';
import '../dashboards/admin_dashboard.dart';
import 'universal_register.dart';

class UniversalLoginPage extends StatefulWidget {
  const UniversalLoginPage({super.key});

  @override
  State<UniversalLoginPage> createState() => _UniversalLoginPageState();
}

class _UniversalLoginPageState extends State<UniversalLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'Patient';

  bool showError = false;
  String errorMessage = "";
  bool isLoading = false;

  final String backendUrl = "http://127.0.0.1:8000/login"; // 🔹 Update this with your backend API

  bool isValidEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

  // -----------------------------
  // 🔹 LOGIN HANDLER (BACKEND)
  // -----------------------------
  Future<void> handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        showError = true;
        errorMessage = "Please enter email and password.";
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        showError = true;
        errorMessage = "Invalid email format. Please try again.";
      });
      return;
    }

    setState(() {
      showError = false;
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": selectedRole,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          // ✅ Navigate based on role
          Widget nextPage;
          switch (data["role"]) {
            case "Doctor":
              nextPage = const DoctorDashboard();
              break;
            case "Admin":
              nextPage = const AdminDashboard();
              break;
            default:
              nextPage = const PatientDashboard();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => nextPage),
          );
        } else {
          // ❌ Invalid credentials or other backend error
          setState(() {
            showError = true;
            errorMessage = data["message"] ?? "Invalid login credentials.";
          });
        }
      } else {
        setState(() {
          showError = true;
          errorMessage = "Server error (${response.statusCode}). Try again.";
        });
      }
    } catch (e) {
      setState(() {
        showError = true;
        errorMessage = "Network error: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  // -----------------------------
  // 🔹 CHANGE PASSWORD DIALOG (Frontend)
  // -----------------------------
  void _showChangePasswordDialog() {
    final emailCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Text(
              "Change Password",
              style: TextStyle(
                color: Color(0xFF0077B6),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enter your registered email and create a new password.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: "Registered Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: newPassCtrl,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF0077B6),
                        ),
                        onPressed: () =>
                            setState(() => obscureNew = !obscureNew),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: confirmPassCtrl,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF0077B6),
                        ),
                        onPressed: () =>
                            setState(() => obscureConfirm = !obscureConfirm),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.black54)),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailCtrl.text.trim();
                  final newPass = newPassCtrl.text.trim();
                  final confirmPass = confirmPassCtrl.text.trim();

                  if (email.isEmpty || !isValidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter a valid email."),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (newPass.isEmpty || newPass.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Password must be at least 6 characters long."),
                        backgroundColor: Colors.redAccent));
                    return;
                  }
                  if (newPass != confirmPass) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Passwords do not match."),
                        backgroundColor: Colors.redAccent));
                    return;
                  }

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Password updated successfully for $email! You can now log in."),
                    backgroundColor: Colors.green,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Update"),
              ),
            ],
          );
        });
      },
    );
  }

  // -----------------------------
  // 🔹 UI BUILD
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 166, 210, 234),
              Color.fromARGB(255, 93, 176, 220),
              Color(0xFF0077B6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Hi, Welcome! 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Access your SmartKare Portal",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  if (showError)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                  color: Colors.red.shade700, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: "Select Role",
                      prefixIcon: const Icon(Icons.people_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Patient', child: Text('Patient')),
                      DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    ],
                    onChanged: (v) => setState(() => selectedRole = v!),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showChangePasswordDialog,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Color(0xFF0077B6),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UniversalRegisterPage()),
                          );
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                            color: Color(0xFF0077B6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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