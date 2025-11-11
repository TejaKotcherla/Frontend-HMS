import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

// SmartKare theme constants (same as admin_dashboard.dart)
const Color kPrimaryBlue = Color(0xFF0077B6);
const Color kAccentCyan = Color.fromRGBO(0, 180, 216, 1);

class PendingDoctorApprovals extends StatefulWidget {
  final String token;
  const PendingDoctorApprovals({super.key, required this.token});

  @override
  State<PendingDoctorApprovals> createState() => _PendingDoctorApprovalsState();
}

class _PendingDoctorApprovalsState extends State<PendingDoctorApprovals> {
  List<dynamic> pendingDoctors = [];
  bool isLoading = false;

  static const String baseUrl = "http://127.0.0.1:8000";

  @override
  void initState() {
    super.initState();
    fetchPendingDoctors();
  }

  Future<void> fetchPendingDoctors() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/pending-doctors'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          pendingDoctors = jsonDecode(response.body);
        });
      } else if (response.statusCode == 404) {
        setState(() {
          pendingDoctors = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No pending doctors found."),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to fetch doctors (${response.statusCode}): ${response.reasonPhrase}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching doctors: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> approveDoctor(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/approve-doctor/$id'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Doctor approved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        fetchPendingDoctors();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Approval failed: ${response.body}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> rejectDoctor(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/reject-doctor/$id'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚫 Doctor rejected successfully."),
            backgroundColor: Colors.orange,
          ),
        );
        fetchPendingDoctors();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Rejection failed: ${response.body}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Pending Doctor Approvals"),
        centerTitle: true,
        backgroundColor: kPrimaryBlue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingDoctors.isEmpty
              ? const Center(
                  child: Text(
                    "🎉 No pending doctors right now!",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(kAccentCyan.withOpacity(0.2)),
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Department")),
                        DataColumn(label: Text("Qualification")),
                        DataColumn(label: Text("Experience")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: pendingDoctors.map((doctor) {
                        return DataRow(
                          cells: [
                            DataCell(Text(doctor['id'].toString())),
                            DataCell(Text(
                              "${doctor['first_name']} ${doctor['last_name']}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            )),
                            DataCell(Text(doctor['email'] ?? 'N/A')),
                            DataCell(Text(doctor['department'] ?? 'N/A')),
                            DataCell(Text(doctor['qualification'] ?? 'N/A')),
                            DataCell(Text(doctor['experience'] ?? 'N/A')),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        approveDoctor(doctor['id']),
                                    icon: const Icon(Icons.check_circle_outline,
                                        color: Colors.white, size: 18),
                                    label: const Text("Approve"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        rejectDoctor(doctor['id']),
                                    icon: const Icon(Icons.cancel_outlined,
                                        color: Colors.white, size: 18),
                                    label: const Text("Reject"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fetchPendingDoctors,
        backgroundColor: kPrimaryBlue,
        label: const Text("Refresh"),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
