// appointment_page.dart
import 'package:flutter/material.dart';
import 'dart:math';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  // Patient fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;
  String? reasonForVisit;

  // Appointment fields
  String? selectedDept;
  String? selectedDoctor;
  DateTime? selectedDate;
  String? selectedSlot; // selected time slot

  bool _isLoading = false;

  // Time slots
  final List<String> timeSlots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "4:00 PM",
    "4:30 PM",
    "5:00 PM",
  ];

  // Departments and related doctors
  final Map<String, List<String>> departmentDoctors = {
    "Cardiology": ["Dr. Rohan Mehta", "Dr. Shalini Kapoor"],
    "Neurology": ["Dr. Priya Sharma", "Dr. Charan Vyas"],
    "Pediatrics": ["Dr. Aditi Singh", "Dr. Hrithik Nair"],
    "Orthopedics": ["Dr. Varun Patel", "Dr. Ajay Krishna"],
    "General Medicine": ["Dr. Karthik Rao", "Dr. Ramesh Gupta"],
  };

  final List<String> genders = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ⭐ UPDATED BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF90CAF9), Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/appointment_background.png"),
            repeat: ImageRepeat.repeat,
            opacity: 0.22,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width : 420,
              ),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 70, color: Color.fromARGB(255, 0, 119, 182)),
                        const SizedBox(height: 10),

                        const Text(
                          "Schedule Your Appointment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0077B6),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // NAME
                        _inputField(
                          controller: nameController,
                          label: "Patient Name",
                          icon: Icons.person,
                          validator: (v) =>
                              v!.isEmpty ? "Enter patient name" : null,
                        ),
                        const SizedBox(height: 20),

                        // AGE
                        _inputField(
                          controller: ageController,
                          label: "Age",
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v!.isEmpty ? "Enter age" : null,
                        ),
                        const SizedBox(height: 20),

                        // GENDER
                        DropdownButtonFormField<String>(
                          decoration:
                              _decor("Gender", Icons.person_3_outlined),
                          items: genders
                              .map((g) => DropdownMenuItem(
                                  value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedGender = v),
                          validator: (v) =>
                              v == null ? "Select gender" : null,
                        ),
                        const SizedBox(height: 20),

                        // DEPARTMENT
                        DropdownButtonFormField<String>(
                          decoration: _decor(
                              "Select Department", Icons.business),
                          items: departmentDoctors.keys
                              .map((dept) => DropdownMenuItem(
                                  value: dept, child: Text(dept)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedDept = v;
                              selectedDoctor = null;
                            });
                          },
                          validator: (v) =>
                              v == null ? "Select department" : null,
                        ),
                        const SizedBox(height: 20),

                        // DOCTOR (depends)
                        DropdownButtonFormField<String>(
                          decoration: _decor(
                              "Select Doctor", Icons.local_hospital),
                          items: selectedDept == null
                              ? []
                              : departmentDoctors[selectedDept]!
                                  .map((doc) => DropdownMenuItem(
                                      value: doc, child: Text(doc)))
                                  .toList(),
                          value: selectedDoctor,
                          onChanged: (v) =>
                              setState(() => selectedDoctor = v),
                          validator: (v) =>
                              v == null ? "Select doctor" : null,
                        ),
                        const SizedBox(height: 20),

                        // DATE
                        TextFormField(
                          readOnly: true,
                          decoration:
                              _decor("Select Date", Icons.date_range),
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 90)),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                          validator: (v) =>
                              selectedDate == null ? "Select date" : null,
                        ),
                        const SizedBox(height: 20),

                        // TIME SLOT HEADER
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Select Time Slot",
                            style: TextStyle(
                              color: Color(0xFF0077B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ⭐ ANIMATED TIME SLOTS
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: timeSlots.map((slot) {
                            final bool isSelected =
                                selectedSlot == slot;

                            return InkWell(
                              onTap: () {
                                setState(() => selectedSlot = slot);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedScale(
                                scale: isSelected ? 1.12 : 1.0,
                                duration:
                                    const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                child: AnimatedContainer(
                                  duration: const Duration(
                                      milliseconds: 250),
                                  curve: Curves.easeOut,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFF0077B6)
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Color(0xFF0077B6)
                                          : Colors.grey.shade400,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Color(0xFF0077B6)
                                                  .withOpacity(0.4),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                              offset:
                                                  const Offset(0, 4),
                                            )
                                          ]
                                        : const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            )
                                          ],
                                  ),
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          isSelected ? 16 : 14.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // REASON
                        TextFormField(
                          maxLines: 3,
                          decoration: _decor(
                              "Reason for Visit",
                              Icons.medical_information_outlined),
                          onChanged: (v) => reasonForVisit = v,
                          validator: (v) =>
                              v!.isEmpty ? "Enter reason" : null,
                        ),
                        const SizedBox(height: 25),

                        // PAYMENT BUTTON
                        _paymentButton(),
                        const SizedBox(height: 25),

                        // SUBMIT BUTTON
                        _submitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------- UI HELPERS -------------------------

  InputDecoration _decor(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      filled: true,
      fillColor: Colors.blue.shade50,
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _decor(label, icon),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  // PAYMENT BUTTON
  Widget _paymentButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Payment processed successfully (demo)."),
            backgroundColor: Colors.green,
          ));
        },
        child: const Text(
          "Pay Consultation Fee",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }

  // SUBMIT BUTTON
  Widget _submitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  if (selectedSlot == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a time slot"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() => _isLoading = false);

                  _showConfirmationDialog();
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Confirm Appointment",
                style:
                    TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  // -------------------- CONFIRMATION POPUP ---------------------
  void _showConfirmationDialog() {
    final appointmentId = "APT${Random().nextInt(999999)}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Appointment Confirmed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(
              "Appointment ID: $appointmentId",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
                "Your appointment with $selectedDoctor on ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at $selectedSlot is confirmed."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
