import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../appointments/appointment_page.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardHome(),
    AppointmentPage(),
    HealthReportsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("SmartKare - Patient Dashboard"),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded), label: "Appointments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety_rounded), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}

// ------------------ Dashboard Home ---------------------

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const _QuickActions(),
          const SizedBox(height: 25),
          const _HealthOverview(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, size: 40, color: Colors.blueAccent),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back, Teja 👋",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            Text("Your health is our priority!",
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

// ------------------ Quick Actions ---------------------

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        "icon": Icons.add_circle_outline,
        "title": "Book Appointment",
        "color": Colors.blueAccent,
        "onTap": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AppointmentPage()));
        }
      },
      {
        "icon": Icons.chat_bubble_outline,
        "title": "AI Symptom Checker",
        "color": Colors.purpleAccent,
        "onTap": () {}
      },
      {
        "icon": Icons.receipt_long_rounded,
        "title": "My Reports",
        "color": Colors.green,
        "onTap": () {}
      },
      {
        "icon": Icons.support_agent_rounded,
        "title": "Contact Support",
        "color": Colors.orangeAccent,
        "onTap": () {}
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: actions.map((action) {
        return InkWell(
          onTap: action["onTap"] as VoidCallback,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (action["color"] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: action["color"] as Color, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action["icon"] as IconData,
                    color: action["color"] as Color, size: 40),
                const SizedBox(height: 10),
                Text(
                  action["title"] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ------------------ Health Overview ---------------------

class _HealthOverview extends StatelessWidget {
  const _HealthOverview();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"label": "Appointments", "value": "3", "icon": Icons.calendar_today},
      {"label": "Reports", "value": "2", "icon": Icons.insert_drive_file},
      {"label": "AI Checks", "value": "5", "icon": Icons.psychology},
      {"label": "Health Score", "value": "92%", "icon": Icons.favorite},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Health Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: stats.map((item) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withValues(alpha: 0.7),
                    Colors.lightBlueAccent.withValues(alpha: 0.7)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item["icon"] as IconData,
                        size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(item["value"] as String,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(item["label"] as String,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ------------------ Other Pages ---------------------

class HealthReportsPage extends StatelessWidget {
  const HealthReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset('assets/animations/health_report.json',
            height: 200, repeat: true));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Profile & Settings coming soon...",
          style: TextStyle(fontSize: 16)),
    );
  }
}
