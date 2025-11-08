import 'package:flutter/material.dart';
import 'universal_login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UniversalRegisterPage extends StatefulWidget {
  const UniversalRegisterPage({super.key});

  @override
  State<UniversalRegisterPage> createState() => _UniversalRegisterPageState();
}

class _UniversalRegisterPageState extends State<UniversalRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Common Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  // Doctor-specific Controllers
  final departmentController = TextEditingController();
  final qualificationController = TextEditingController();
  final experienceController = TextEditingController();
  final bloodGroupController = TextEditingController(); // For Patient only

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String userType = "Patient"; // Default selection

  static const String baseUrl = "http://127.0.0.1:8000";

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // Build request body safely
    final Map<String, dynamic> body = {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone_number': phoneNumberController.text.trim(),
      'password': passwordController.text.trim(),
      'gender': genderController.text.trim(),
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'city': cityController.text.trim(),
      'country': countryController.text.trim(),
      'role': userType.toLowerCase(), // "patient" or "doctor"
      'blood_group':
          userType == "Patient" ? bloodGroupController.text.trim() : null,
      'department':
          userType == "Doctor" ? departmentController.text.trim() : null,
      'qualification':
          userType == "Doctor" ? qualificationController.text.trim() : null,
      'experience':
          userType == "Doctor" ? experienceController.text.trim() : null,
    };

    // Debug log (check Flutter console)
    print("🧾 Register Request Body: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        final message = userType == "Patient"
            ? "Patient registered successfully!"
            : "Doctor registration submitted for admin approval.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );

        if (userType == "Doctor") {
          _showApprovalDialog();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UniversalLoginPage()),
          );
        }
      } else {
        // Handle error safely (even if backend crashes or returns invalid JSON)
        String errorMessage;
        try {
          final decoded = jsonDecode(response.body);
          errorMessage = decoded['detail'] ??
              decoded['message'] ??
              response.reasonPhrase ??
              'Unknown error';
        } catch (e) {
          errorMessage = "Server returned ${response.statusCode}";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: $errorMessage"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showApprovalDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Request Submitted 🩺"),
        content: const Text(
            "Your registration request has been sent to the admin.\nPlease wait for approval."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const UniversalLoginPage()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("SmartKare - Universal Registration"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Create Your Account 🏥",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  // Toggle: Patient / Doctor
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(12),
                    isSelected: [userType == "Patient", userType == "Doctor"],
                    onPressed: (index) {
                      setState(() {
                        userType = index == 0 ? "Patient" : "Doctor";
                      });
                    },
                    color: Colors.blueAccent,
                    selectedColor: Colors.white,
                    fillColor: Colors.blueAccent,
                    children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text("Patient")),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text("Doctor")),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Common Fields
                  _buildTextField(
                    firstNameController,
                    "First Name",
                    Icons.person_outline,
                    false,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return "Please enter first name";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    lastNameController,
                    "Last Name",
                    Icons.person_outline,
                    false,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return "Please enter last name";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                      emailController, "Email", Icons.email_outlined, false,
                      keyboardType: TextInputType.emailAddress, validator: (v) {
                    if (v!.isEmpty) return "Please enter email";
                    if (!v.contains("@")) return "Invalid email format";
                    return null;
                  }),
                  const SizedBox(height: 15),
                  _buildTextField(
                      phoneNumberController, "Phone Number", Icons.phone, false,
                      keyboardType: TextInputType.phone, validator: (v) {
                    if (v!.isEmpty) return "Please enter phone number";
                    if (v.length < 10) return "Enter valid phone number";
                    return null;
                  }),
                  const SizedBox(height: 15),
                  _buildPasswordField(
                      passwordController, "Password", obscurePassword, () {
                    setState(() => obscurePassword = !obscurePassword);
                  }),
                  const SizedBox(height: 15),
                  _buildPasswordField(confirmPasswordController,
                      "Confirm Password", obscureConfirmPassword, () {
                    setState(
                        () => obscureConfirmPassword = !obscureConfirmPassword);
                  }),
                  const SizedBox(height: 15),

                  // Gender
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.wc),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      genderController.text = value!;
                    },
                    validator: (value) =>
                        value == null ? "Please select gender" : null,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(ageController, "Age", Icons.cake, false,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 15),

                  // Conditional Fields
                  if (userType == "Patient") ...[
                    _buildTextField(bloodGroupController, "Blood Group",
                        Icons.bloodtype, false),
                    const SizedBox(height: 15),
                  ] else ...[
                    _buildTextField(departmentController, "Department",
                        Icons.local_hospital_outlined, false),
                    const SizedBox(height: 15),
                    _buildTextField(qualificationController, "Qualification",
                        Icons.school_outlined, false),
                    const SizedBox(height: 15),
                    _buildTextField(experienceController, "Experience (Years)",
                        Icons.work_outline, false,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 15),
                  ],

                  // Common City & Country
                  _buildTextField(
                      cityController, "City", Icons.location_city, false),
                  const SizedBox(height: 15),
                  _buildTextField(
                      countryController, "Country", Icons.flag, false),
                  const SizedBox(height: 25),

                  // Register Button
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            userType == "Doctor"
                                ? "Submit for Approval"
                                : "Register",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UniversalLoginPage()),
                          );
                        },
                        child: const Text(
                          "Login Here",
                          style: TextStyle(
                            color: Colors.blueAccent,
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

  // Reusable Widgets
  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool obscure,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator ?? (value) => value!.isEmpty ? "Enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      bool obscure, VoidCallback onToggle) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value!.isEmpty) return "Please enter $label";
        if (label == "Confirm Password" && value != passwordController.text) {
          return "Passwords do not match";
        }
        if (value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
