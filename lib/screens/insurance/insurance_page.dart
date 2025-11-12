import 'package:flutter/material.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMedicalProvider;
  String? selectedAccidentProvider;

  final Map<String, String> medicalProviders = {
    "Star Health and Allied Insurance": "Health / Family / Senior Citizen",
    "HDFC ERGO Health Insurance": "Individual / Corporate",
    "ICICI Lombard General Insurance": "Health / Family Floater",
    "Max Bupa (Niva Bupa)": "Health / Critical Illness",
    "Aditya Birla Health Insurance": "Health / Fitness Reward Plans",
    "Reliance Health Insurance": "Health / OPD / COVID",
    "Bajaj Allianz General Insurance": "Family / Maternity / Cancer",
    "Care Health Insurance (Religare)": "Cashless / Pre-existing",
    "TATA AIG Health Insurance": "Family / Senior Citizen",
    "Oriental Insurance Company Ltd.": "Government / PSU Health Plans",
  };

  final Map<String, String> accidentProviders = {
    "ICICI Lombard Accident Cover": "Personal / Group Accident",
    "Bajaj Allianz Personal Accident Policy": "Road / Air / Disability",
    "HDFC ERGO Accident Insurance": "Death / Disability / Hospital Cash",
    "TATA AIG Accident Guard": "Personal / Travel Accident",
    "Reliance Personal Accident Insurance": "Accidental Death / Injury",
    "Aditya Birla Accident Shield": "Individual / Family Accident Cover",
    "New India Assurance PA Policy": "Government / Private Employee Accident",
    "United India Insurance": "Accidental Death & Hospitalization",
    "National Insurance Co. Ltd.": "Personal Accident (PAN India)",
    "SBI General Accident Insurance": "Personal / Corporate Accident",
  };

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // ✅ Gradient AppBar
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 131, 188, 199),
                Color.fromARGB(255, 92, 172, 219),
                Color(0xFF0077B6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Insurance Providers",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ✅ Gradient Background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 131, 188, 199),
              Color.fromARGB(255, 92, 172, 219),
              Color(0xFF0077B6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width < 600 ? size.width : 450,
              ),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.health_and_safety_rounded,
                            size: 70, color: Colors.blueAccent),
                        const SizedBox(height: 10),
                        const Text(
                          "Select Your Insurance Plans",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Medical Provider Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Medical (Health) Provider",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon:
                                const Icon(Icons.local_hospital_outlined),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                          ),
                          items: medicalProviders.keys
                              .map((provider) => DropdownMenuItem(
                                  value: provider, child: Text(provider)))
                              .toList(),
                          value: selectedMedicalProvider,
                          onChanged: (value) {
                            setState(() {
                              selectedMedicalProvider = value;
                            });
                          },
                          validator: (value) => value == null
                              ? "Please select a medical provider"
                              : null,
                        ),
                        const SizedBox(height: 15),

                        // Accident Provider Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Accident Provider",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon: const Icon(Icons.car_crash_rounded),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                          ),
                          items: accidentProviders.keys
                              .map((provider) => DropdownMenuItem(
                                  value: provider, child: Text(provider)))
                              .toList(),
                          value: selectedAccidentProvider,
                          onChanged: (value) {
                            setState(() {
                              selectedAccidentProvider = value;
                            });
                          },
                          validator: (value) => value == null
                              ? "Please select an accident provider"
                              : null,
                        ),
                        const SizedBox(height: 25),

                        // Info Display
                        if (selectedMedicalProvider != null)
                          Text(
                            "🩺 ${medicalProviders[selectedMedicalProvider]!}",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 15),
                          ),
                        if (selectedAccidentProvider != null)
                          Text(
                            "🚑 ${accidentProviders[selectedAccidentProvider]!}",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 15),
                          ),
                        const SizedBox(height: 25),

                        // Submit Button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 131, 188, 199),
                                Color.fromARGB(255, 92, 172, 219),
                                Color(0xFF0077B6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      await Future.delayed(
                                          const Duration(seconds: 2));

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Insurance selection submitted successfully!"),
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.pop(context);
                                      setState(() => _isLoading = false);
                                    }
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Submit Selection",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
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
}
