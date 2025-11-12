// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms/screens/auth/universal_login.dart';

// 🌊 SmartKare Blue Theme Colors
const Color kPrimaryBlue = Color(0xFF0077B6);
const Color kAccentCyan = Color.fromRGBO(0, 180, 216, 1); // #00B4D8
const double kCardRadius = 14.0;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminHomePage(),
    ReportsShellPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "SmartKare - Admin Dashboard",
          style: TextStyle(
            color: Colors.white, // Black text color
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Black icons
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
      ),
      drawer: _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: kPrimaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryBlue, kAccentCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text("Super Admin",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text("admin@smartkare.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings,
                  size: 36, color: kPrimaryBlue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Doctor Details"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DoctorDetailsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_search),
            title: const Text("Patient Details"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PatientDetailsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Appointments"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AppointmentModulePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Doctor Bills"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DoctorBillsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments),
            title: const Text("Salaries"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StaffSalaryPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title:
                const Text("Logout", style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const UniversalLoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ================= Admin Home Page (Grid of modules) =================
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 2 : (width < 1000 ? 3 : 4);

    final modules = <_ModuleCardData>[
      _ModuleCardData(
          title: "Doctor Details",
          icon: Icons.medical_services_outlined,
          color: Colors.blue,
          route: () => const DoctorDetailsPage()),
      _ModuleCardData(
          title: "Patient Details",
          icon: Icons.people_outline,
          color: Colors.teal,
          route: () => const PatientDetailsPage()),
      _ModuleCardData(
          title: "Appointments",
          icon: Icons.calendar_today,
          color: Colors.indigo,
          route: () => const AppointmentModulePage()),
      _ModuleCardData(
          title: "Doctor Bills",
          icon: Icons.receipt_long,
          color: Colors.green,
          route: () => const DoctorBillsPage()),
      _ModuleCardData(
          title: "Doctor Salary",
          icon: Icons.payments,
          color: Colors.deepPurple,
          route: () => const DoctorSalaryPage()),
      _ModuleCardData(
          title: "Staff Salary",
          icon: Icons.account_balance_wallet,
          color: Colors.orange,
          route: () => const StaffSalaryPage()),
      _ModuleCardData(
          title: "Doctor Monthly Report",
          icon: Icons.insights,
          color: Colors.pink,
          route: () => const DoctorMonthlyReportPage()),
      _ModuleCardData(
          title: "Add Doctor",
          icon: Icons.person_add,
          color: Colors.lightBlue,
          route: () => const AddDoctorPage()),
      _ModuleCardData(
          title: "Delete Doctor",
          icon: Icons.delete_forever,
          color: Colors.redAccent,
          route: () => const DeleteDoctorPage()),
      _ModuleCardData(
          title: "Add Staff",
          icon: Icons.person_add_alt_1,
          color: Colors.cyan,
          route: () => const AddStaffPage()),
      _ModuleCardData(
          title: "Delete Staff",
          icon: Icons.delete_outline,
          color: Colors.brown,
          route: () => const DeleteStaffPage()),
      _ModuleCardData(
          title: "Delete Patient",
          icon: Icons.person_remove_alt_1,
          color: Colors.grey,
          route: () => const DeletePatientPage()),
    ];

    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Welcome row
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.person, size: 32, color: kPrimaryBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome Back, Admin 👋",
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text("Manage doctors, patients and operations",
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 74, 143, 180),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 41, 132, 181), width: 1.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DoctorMonthlyReportPage()));
                  },
                  icon: const Icon(Icons.insights),
                  label: const Text("Monthly Report"),
                )
              ],
            ),
            const SizedBox(height: 18),

            // Stat pills row (summary)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _StatPill(count: "34", label: "Doctors"),
                  SizedBox(width: 12),
                  _StatPill(count: "1,120", label: "Patients"),
                  SizedBox(width: 12),
                  _StatPill(count: "242", label: "Appointments"),
                  SizedBox(width: 12),
                  _StatPill(count: "18", label: "Staff"),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Grid of modules
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: modules
                    .map((m) => _ModuleCard(
                          data: m,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// small module card data holder
class _ModuleCardData {
  final String title;
  final IconData icon;
  final Color color;
  final Widget Function() route;

  const _ModuleCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _ModuleCard extends StatelessWidget {
  final _ModuleCardData data;
  const _ModuleCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => data.route()));
      },
      borderRadius: BorderRadius.circular(kCardRadius),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardRadius)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: data.color.withOpacity(0.12),
                child: Icon(data.icon, size: 28, color: data.color),
              ),
              const SizedBox(height: 12),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String count;
  final String label;
  const _StatPill({required this.count, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kPrimaryBlue, kAccentCyan]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        children: [
          Text(count,
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }
}

/// ================= Placeholders for pages =================

class DoctorDetailsPage extends StatelessWidget {
  const DoctorDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: simple list of doctors (dummy data)
    final doctors = const [
      {"name": "Dr. Aarav Sharma", "specialty": "Cardiologist", "id": "D001"},
      {"name": "Dr. Meera Iyer", "specialty": "Neurologist", "id": "D002"},
      {"name": "Dr. Rohit Verma", "specialty": "Pediatrician", "id": "D003"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Details"),
        backgroundColor: kPrimaryBlue,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final d = doctors[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.medical_services, color: kPrimaryBlue),
            ),
            title: Text(d['name']!,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(d['specialty']!),
            trailing: PopupMenuButton<String>(
              onSelected: (v) {
                // implement actions later
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: doctors.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddDoctorPage())),
        label: const Text("Add Doctor"),
        icon: const Icon(Icons.person_add),
        backgroundColor: kPrimaryBlue,
      ),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  const PatientDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = const [
      {"name": "Sana R.", "age": "28", "id": "P1001"},
      {"name": "Rahul G.", "age": "35", "id": "P1002"},
      {"name": "Priya S.", "age": "41", "id": "P1003"},
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Patient Details"), backgroundColor: kPrimaryBlue),
      body: ListView.builder(
        itemCount: patients.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final p = patients[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  child: const Icon(Icons.person, color: Colors.teal)),
              title: Text(p['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("Age: ${p['age']} • ID: ${p['id']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DeletePatientPage())),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddPatientPage())),
        label: const Text("Add Patient"),
        icon: const Icon(Icons.person_add_alt),
        backgroundColor: kPrimaryBlue,
      ),
    );
  }
}

class AppointmentModulePage extends StatelessWidget {
  const AppointmentModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder list of appointment items
    final appts = const [
      {"patient": "Sana R.", "doctor": "Dr. Aarav", "time": "2025-11-07 10:00"},
      {
        "patient": "Rahul G.",
        "doctor": "Dr. Meera",
        "time": "2025-11-08 14:30"
      },
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Appointments"), backgroundColor: kPrimaryBlue),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final a = appts[i];
          return ListTile(
            leading: const Icon(Icons.calendar_today, color: kPrimaryBlue),
            title: Text("${a['patient']} → ${a['doctor']}"),
            subtitle: Text(a['time']!),
            trailing:
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: appts.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddAppointmentPage())),
        label: const Text("New Appointment"),
        icon: const Icon(Icons.add),
        backgroundColor: kPrimaryBlue,
      ),
    );
  }
}

class DoctorBillsPage extends StatelessWidget {
  const DoctorBillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder bills table/list
    final bills = const [
      {"doctor": "Dr. Aarav", "amount": "\$1,200", "month": "Oct 2025"},
      {"doctor": "Dr. Meera", "amount": "\$950", "month": "Oct 2025"},
    ];

    return Scaffold(
      appBar: AppBar(
          title: const Text("Doctor Bills"), backgroundColor: kPrimaryBlue),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final b = bills[i];
          return ListTile(
            leading: const Icon(Icons.receipt, color: kPrimaryBlue),
            title: Text(b['doctor']!),
            subtitle: Text("${b['month']} • ${b['amount']}"),
            trailing:
                TextButton(onPressed: () {}, child: const Text("Mark Paid")),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: bills.length,
      ),
    );
  }
}

class DoctorSalaryPage extends StatelessWidget {
  const DoctorSalaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder content
    return Scaffold(
      appBar: AppBar(
          title: const Text("Doctor Salary"), backgroundColor: kPrimaryBlue),
      body: const Center(
        child: Text("Doctor salary management coming soon.",
            style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class StaffSalaryPage extends StatelessWidget {
  const StaffSalaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Staff Salary"), backgroundColor: kPrimaryBlue),
      body: const Center(
          child: Text("Staff salary management coming soon.",
              style: TextStyle(fontSize: 16))),
    );
  }
}

class DoctorMonthlyReportPage extends StatelessWidget {
  const DoctorMonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple placeholder that shows month selection + summary cards
    return Scaffold(
      appBar: AppBar(
          title: const Text("Doctor Monthly Report"),
          backgroundColor: kPrimaryBlue),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Select month: ",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: "October 2025",
                  items: const [
                    DropdownMenuItem(
                        value: "October 2025", child: Text("October 2025")),
                    DropdownMenuItem(
                        value: "September 2025", child: Text("September 2025")),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                    child: _ReportSummaryCard(
                        label: "Total Consults", value: "420")),
                SizedBox(width: 12),
                Expanded(
                    child: _ReportSummaryCard(
                        label: "Avg Rating", value: "4.6/5")),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 4,
                child: Center(
                    child: Text("Monthly chart/graph placeholder",
                        style: TextStyle(color: Colors.black54))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ======= Simple small pages for add/delete operations and reports =======

class AddDoctorPage extends StatelessWidget {
  const AddDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Doctor"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Form to add a doctor goes here.")),
    );
  }
}

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Patient"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Form to add a patient goes here.")),
    );
  }
}

class AddAppointmentPage extends StatelessWidget {
  const AddAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("New Appointment"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Appointment creation form goes here.")),
    );
  }
}

class AddStaffPage extends StatelessWidget {
  const AddStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Add Staff"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Add staff form goes here.")),
    );
  }
}

class DeleteDoctorPage extends StatelessWidget {
  const DeleteDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Delete Doctor"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Select and delete doctor entries here.")),
    );
  }
}

class DeletePatientPage extends StatelessWidget {
  const DeletePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Delete Patient"), backgroundColor: kPrimaryBlue),
      body:
          const Center(child: Text("Select and delete patient entries here.")),
    );
  }
}

class DeleteStaffPage extends StatelessWidget {
  const DeleteStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Delete Staff"), backgroundColor: kPrimaryBlue),
      body: const Center(child: Text("Select and delete staff entries here.")),
    );
  }
}

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insurance"),
        backgroundColor: Color(0xFF0077B6), // same blue as the theme
      ),
      body: const Center(
        child: Text(
          "Insurance management features coming soon...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

/// Reports shell (placeholder) and settings
class ReportsShellPage extends StatelessWidget {
  const ReportsShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart,
                size: 80, color: kPrimaryBlue.withOpacity(0.9)),
            const SizedBox(height: 14),
            Text("Reports & Analytics",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
                "Monthly, weekly and custom reports for doctors and operations."),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DoctorMonthlyReportPage())),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue),
              child: const Text("Open Monthly Report"),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Center(
        child: Text("Settings and integrations coming soon.",
            style: GoogleFonts.poppins(fontSize: 18)),
      ),
    );
  }
}

/// small UI helper widgets
class _ReportSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  const _ReportSummaryCard(
      {required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
