import 'package:flutter/material.dart';
import 'package:hms/screens/auth/universal_login.dart';
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

      // ✅ Drawer (side menu bar)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                "SmartKare Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Appointments"),
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text("Reports"),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Settings page coming soon...")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.redAccent)),
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
        "color": Colors.purple,
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
        "color": Colors.orange,
        "onTap": () {}
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _HoverCard(
                color: action["color"] as Color,
                icon: action["icon"] as IconData,
                title: action["title"] as String,
                onTap: action["onTap"] as VoidCallback,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ------------------ Health Overview ---------------------

class _HealthOverview extends StatelessWidget {
  const _HealthOverview();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        "label": "Appointments",
        "value": "3",
        "icon": Icons.calendar_today,
        "color": Colors.blueAccent
      },
      {
        "label": "Reports",
        "value": "2",
        "icon": Icons.insert_drive_file,
        "color": Colors.green
      },
      {
        "label": "AI Checks",
        "value": "5",
        "icon": Icons.psychology,
        "color": Colors.purple
      },
      {
        "label": "Health Score",
        "value": "92%",
        "icon": Icons.favorite,
        "color": Colors.redAccent
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Health Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stats.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _HoverCard(
                  color: item["color"] as Color,
                  icon: item["icon"] as IconData,
                  title: item["label"] as String,
                  value: item["value"] as String,
                  gradient: true,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ------------------ Hover Card Widget ---------------------

class _HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  final String? value;
  final bool gradient;

  const _HoverCard({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
    this.value,
    this.gradient = false,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: widget.gradient
                  ? null
                  : Border.all(color: widget.color, width: 1),
              gradient: widget.gradient
                  ? LinearGradient(
                      colors: [
                        widget.color.withOpacity(0.8),
                        widget.color.withOpacity(0.6)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.gradient ? null : widget.color.withOpacity(0.15),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: 45,
                    color: widget.gradient ? Colors.white : widget.color),
                const SizedBox(height: 12),
                if (widget.value != null)
                  Text(
                    widget.value!,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: widget.gradient ? Colors.white : Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
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
