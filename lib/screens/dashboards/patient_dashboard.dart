import 'package:flutter/material.dart';
import 'package:hms/screens/auth/universal_login.dart';
import 'package:lottie/lottie.dart';
import '../appointments/appointment_page.dart';
import '../insurance/insurance_page.dart';

class PatientDashboard extends StatefulWidget {
  final Map<String, dynamic> user;  // <-- Added
  
  const PatientDashboard({super.key, required this.user});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    DashboardHome(user: widget.user),     // <-- Pass user
    AppointmentPage(),
    ProfilePage(user: widget.user),       // <-- Pass user
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
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
          "SmartKare - Patient Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      drawer: _PatientDrawer(
        user: widget.user,                // <-- Pass user
        onTap: (index) {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
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

//
// -------------------- PATIENT DRAWER --------------------
class _PatientDrawer extends StatelessWidget {
  final Function(int) onTap;
  final Map<String, dynamic> user;    // <-- Added

  const _PatientDrawer({required this.onTap, required this.user});

  @override
  Widget build(BuildContext context) {
    const Color menuColor = Color(0xFF0077B6);

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0077B6), Color(0xFF0096C7), Color(0xFF00B4D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.person, size: 55, color: Colors.blueAccent),
                ),
                const SizedBox(height: 16),

                // 👇 DYNAMIC NAME
                Text(
                  "${user['first_name']} ${user['last_name']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // 👇 DYNAMIC EMAIL
                Text(
                  user['email'] ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _DrawerItem(icon: Icons.dashboard_rounded, text: "Dashboard", color: menuColor, onTap: () => onTap(0)),
                _DrawerItem(icon: Icons.calendar_month_rounded, text: "Appointments", color: menuColor, onTap: () => onTap(1)),
                _DrawerItem(icon: Icons.health_and_safety_rounded, text: "Reports", color: menuColor, onTap: () => onTap(2)),
                _DrawerItem(icon: Icons.person_rounded, text: "Profile & Settings", color: menuColor, onTap: () => onTap(3)),

                const Divider(),
                _DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const UniversalLoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//
// --------------------- DRAWER ITEM ----------------------
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}

//
// ------------------- DASHBOARD HOME ---------------------
class DashboardHome extends StatelessWidget {
  final Map<String, dynamic> user;   // <-- Added

  const DashboardHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(user: user),   // <-- Pass user
          const SizedBox(height: 20),
          const _QuickActions(),
          const SizedBox(height: 25),
          const _HealthOverview(),
        ],
      ),
    );
  }
}

//
// ----------------------- HEADER -------------------------
class _Header extends StatelessWidget {
  final Map<String, dynamic> user;   // <-- Added

  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, size: 40, color: Colors.blueAccent),
        ),
        const SizedBox(width: 16),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👇 DYNAMIC GREETING
            Text(
              "Welcome Back, ${user['first_name']} 👋",
              style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Text("Your health is our priority!", style: TextStyle(color: Colors.black54)),
          ],
        )
      ],
    );
  }
}

//
// -------------------- QUICK ACTIONS ---------------------
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        "icon": Icons.add_circle_outline,
        "title": "Book Appointment",
        "color": Colors.blueAccent,
        "background": const Color(0xFFE3F2FD),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentPage()));
        }
      },
      {
        "icon": Icons.policy_rounded,
        "title": "Insurance",
        "color": const Color(0xFF9C27B0),
        "background": const Color(0xFFE6D9F3),
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const InsurancePage()));
        },
      },
      {
        "icon": Icons.receipt_long_rounded,
        "title": "My Reports",
        "color": Colors.green,
        "background": const Color(0xFFE8F5E9),
        "onTap": () {},
      },
      {
        "icon": Icons.support_agent_rounded,
        "title": "Contact Support",
        "color": Colors.orange,
        "background": const Color(0xFFFFF3E0),
        "onTap": () {},
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _ActionCard(
              icon: action["icon"] as IconData,
              title: action["title"] as String,
              color: action["color"] as Color,
              background: action["background"] as Color,
              onTap: action["onTap"] as VoidCallback,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

//
// ------------------- HEALTH OVERVIEW --------------------
class _HealthOverview extends StatelessWidget {
  const _HealthOverview();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"label": "Appointments", "value": "3", "icon": Icons.calendar_today, "color": Colors.blueAccent},
      {"label": "Reports", "value": "2", "icon": Icons.insert_drive_file, "color": Colors.green},
      {"label": "AI Checks", "value": "5", "icon": Icons.psychology, "color": Colors.purple},
      {"label": "Health Score", "value": "92%", "icon": Icons.favorite, "color": Colors.redAccent},
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

//
// --------------------- PROFILE PAGE ---------------------
class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;   // <-- Added

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Name: ${user['first_name']} ${user['last_name']}\nEmail: ${user['email']}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

//
// ----------------------- HOVER CARD ---------------------
class _HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String? value;
  final bool gradient;

  const _HoverCard({
    required this.icon,
    required this.title,
    required this.color,
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
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: widget.gradient
                ? LinearGradient(
                    colors: [
                      widget.color.withOpacity(0.8),
                      widget.color.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.gradient ? null : widget.color.withOpacity(0.15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 45, color: widget.gradient ? Colors.white : widget.color),
              if (widget.value != null)
                Text(widget.value!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: widget.gradient ? Colors.white : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
