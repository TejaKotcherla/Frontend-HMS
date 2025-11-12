// // appointment_page.dart
// import 'package:flutter/material.dart';

// class AppointmentPage extends StatefulWidget {
//   const AppointmentPage({super.key});

//   @override
//   State<AppointmentPage> createState() => _AppointmentPageState();
// }

// class _AppointmentPageState extends State<AppointmentPage> {
//   final _formKey = GlobalKey<FormState>();

//   String? selectedDoctor;
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   final symptomsController = TextEditingController();

//   bool _isLoading = false;

//   final List<String> doctors = [
//     "Dr. Rohan Mehta - Cardiologist",
//     "Dr. Priya Sharma - Neurologist",
//     "Dr. Karthik Rao - General Physician",
//     "Dr. Aditi Singh - Pediatrician",
//     "Dr. Varun Patel - Orthopedic Surgeon"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Appointment"),
//         backgroundColor: const Color(0xFF1976D2),
//         centerTitle: true,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: size.width < 600 ? size.width : 450,
//               ),
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(28.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.calendar_month_rounded,
//                             size: 70, color: Colors.blueAccent),
//                         const SizedBox(height: 10),
//                         const Text(
//                           "Schedule Your Appointment",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         const SizedBox(height: 25),

//                         // Doctor Dropdown
//                         DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             labelText: "Select Doctor",
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             prefixIcon:
//                                 const Icon(Icons.local_hospital_outlined),
//                             filled: true,
//                             fillColor: Colors.blue.shade50,
//                           ),
//                           items: doctors
//                               .map((doctor) => DropdownMenuItem(
//                                   value: doctor, child: Text(doctor)))
//                               .toList(),
//                           value: selectedDoctor,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedDoctor = value;
//                             });
//                           },
//                           validator: (value) =>
//                               value == null ? "Please select a doctor" : null,
//                         ),
//                         const SizedBox(height: 20),

//                         // Date Picker
//                         TextFormField(
//                           readOnly: true,
//                           decoration: InputDecoration(
//                             labelText: "Select Date",
//                             prefixIcon: const Icon(Icons.date_range),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             filled: true,
//                             fillColor: Colors.blue.shade50,
//                           ),
//                           onTap: () async {
//                             DateTime? picked = await showDatePicker(
//                               context: context,
//                               initialDate:
//                                   DateTime.now().add(const Duration(days: 1)),
//                               firstDate: DateTime.now(),
//                               lastDate:
//                                   DateTime.now().add(const Duration(days: 90)),
//                             );
//                             if (picked != null) {
//                               setState(() => selectedDate = picked);
//                             }
//                           },
//                           controller: TextEditingController(
//                             text: selectedDate == null
//                                 ? ''
//                                 : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                           ),
//                           validator: (value) =>
//                               selectedDate == null ? "Select a date" : null,
//                         ),
//                         const SizedBox(height: 20),

//                         // Time Picker
//                         TextFormField(
//                           readOnly: true,
//                           decoration: InputDecoration(
//                             labelText: "Select Time",
//                             prefixIcon: const Icon(Icons.access_time),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             filled: true,
//                             fillColor: Colors.blue.shade50,
//                           ),
//                           onTap: () async {
//                             TimeOfDay? picked = await showTimePicker(
//                               context: context,
//                               initialTime: TimeOfDay.now(),
//                             );
//                             if (picked != null) {
//                               setState(() => selectedTime = picked);
//                             }
//                           },
//                           controller: TextEditingController(
//                             text: selectedTime == null
//                                 ? ''
//                                 : selectedTime!.format(context),
//                           ),
//                           validator: (value) =>
//                               selectedTime == null ? "Select a time" : null,
//                         ),
//                         const SizedBox(height: 20),

//                         // Symptoms Field
//                         TextFormField(
//                           controller: symptomsController,
//                           maxLines: 3,
//                           decoration: InputDecoration(
//                             labelText: "Symptoms / Health Issue",
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             filled: true,
//                             fillColor: Colors.blue.shade50,
//                             prefixIcon:
//                                 const Icon(Icons.medical_information_outlined),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please describe your symptoms";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 25),

//                         // Submit Button
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 250),
//                           width: double.infinity,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ),
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 8,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                             onPressed: _isLoading
//                                 ? null
//                                 : () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       setState(() => _isLoading = true);
//                                       await Future.delayed(
//                                           const Duration(seconds: 2));

//                                       if (!mounted) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(const SnackBar(
//                                           content: Text(
//                                               "Appointment booked successfully!"),
//                                           backgroundColor: Colors.green,
//                                         ));
//                                         Navigator.pop(context);
//                                       }
//                                       setState(() => _isLoading = false);
//                                     }
//                                   },
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white)
//                                 : const Text(
//                                     "Book Appointment",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedDoctor;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final symptomsController = TextEditingController();

  bool _isLoading = false;

  final List<String> doctors = [
    "Dr. Rohan Mehta - Cardiologist",
    "Dr. Priya Sharma - Neurologist",
    "Dr. Karthik Rao - General Physician",
    "Dr. Aditi Singh - Pediatrician",
    "Dr. Varun Patel - Orthopedic Surgeon"
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // ✅ AppBar with gradient and white bold title
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
          "Book Appointment",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ✅ Body with same theme gradient background
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
                        const Icon(Icons.calendar_month_rounded,
                            size: 70, color: Colors.blueAccent),
                        const SizedBox(height: 10),
                        const Text(
                          "Schedule Your Appointment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Doctor Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Select Doctor",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            prefixIcon:
                                const Icon(Icons.local_hospital_outlined),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                          ),
                          items: doctors
                              .map((doctor) => DropdownMenuItem(
                                  value: doctor, child: Text(doctor)))
                              .toList(),
                          value: selectedDoctor,
                          onChanged: (value) {
                            setState(() {
                              selectedDoctor = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Please select a doctor" : null,
                        ),
                        const SizedBox(height: 20),

                        // Date Picker
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Select Date",
                            prefixIcon: const Icon(Icons.date_range),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.blue.shade50,
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
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                          validator: (value) =>
                              selectedDate == null ? "Select a date" : null,
                        ),
                        const SizedBox(height: 20),

                        // Time Picker
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Select Time",
                            prefixIcon: const Icon(Icons.access_time),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                          ),
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedTime = picked);
                            }
                          },
                          controller: TextEditingController(
                            text: selectedTime == null
                                ? ''
                                : selectedTime!.format(context),
                          ),
                          validator: (value) =>
                              selectedTime == null ? "Select a time" : null,
                        ),
                        const SizedBox(height: 20),

                        // Symptoms Field
                        TextFormField(
                          controller: symptomsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Symptoms / Health Issue",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                            prefixIcon:
                                const Icon(Icons.medical_information_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please describe your symptoms";
                            }
                            return null;
                          },
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

                                      if (!mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Appointment booked successfully!"),
                                          backgroundColor: Colors.green,
                                        ));
                                        Navigator.pop(context);
                                      }
                                      setState(() => _isLoading = false);
                                    }
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Book Appointment",
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

