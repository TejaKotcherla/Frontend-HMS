import 'package:flutter/material.dart';
import 'universal_login.dart';

class UniversalRegisterPage extends StatefulWidget {
  const UniversalRegisterPage({super.key});

  @override
  State<UniversalRegisterPage> createState() => _UniversalRegisterPageState();
}

class _UniversalRegisterPageState extends State<UniversalRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Patient registered successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UniversalLoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("SmartKare - Patient Registration"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
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
                  // 🏥 Title
                  const Text(
                    "Create Patient Account 🏥",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // First name
                  _buildTextField(firstNameController, "First Name",
                      Icons.person_outline, false),
                  const SizedBox(height: 15),

                  // Last name
                  _buildTextField(lastNameController, "Last Name",
                      Icons.person_outline, false),
                  const SizedBox(height: 15),

                  // Email
                  _buildTextField(
                      emailController, "Email", Icons.email_outlined, false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                    if (value!.isEmpty) return "Please enter email";
                    if (!value.contains("@")) return "Invalid email format";
                    return null;
                  }),
                  const SizedBox(height: 15),

                  // Password
                  _buildPasswordField(
                      passwordController, "Password", obscurePassword, () {
                    setState(() => obscurePassword = !obscurePassword);
                  }),
                  const SizedBox(height: 15),

                  // Confirm Password
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

                  // Age
                  _buildTextField(
                    ageController,
                    "Age",
                    Icons.cake,
                    false,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),

                  // Blood Group
                  _buildTextField(bloodGroupController, "Blood Group",
                      Icons.bloodtype, false),
                  const SizedBox(height: 15),

                  // City
                  _buildTextField(
                      cityController, "City", Icons.location_city, false),
                  const SizedBox(height: 15),

                  // Country
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
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 20),

                  // Back to login
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

  // ------------------------------
  // 🔹 Helper Widgets
  // ------------------------------
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
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
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
