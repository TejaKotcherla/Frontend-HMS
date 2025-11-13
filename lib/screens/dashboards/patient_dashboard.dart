import 'package:flutter/material.dart';
import 'package:frontend_hms/screens/auth/universal_login.dart';
import 'package:lottie/lottie.dart';
import '../appointments/appointment_page.dart';
import '../Insurance/insurance_page.dart';

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
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ AppBar with gradient
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

      // ✅ Drawer
      drawer: _PatientDrawer(onTap: (index) {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      }),

      // ✅ Page Body
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _pages[_selectedIndex],
      ),

      // ✅ Bottom Navigation Bar
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
// 🩵 Patient Drawer (all solid blue items)
//
class _PatientDrawer extends StatelessWidget {
  final Function(int) onTap;
  const _PatientDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const Color menuColor = Color(0xFF0077B6);

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0077B6),
                  Color(0xFF0096C7),
                  Color(0xFF00B4D8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double size = constraints.maxWidth < 400
                        ? 70
                        : constraints.maxWidth < 800
                            ? 85
                            : 100;
                    return Container(
                      width: size,
                      height: size,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fitWidth,
                          filterQuality: FilterQuality.high,
                          width: size * 1.05,
                          height: size * 1.05,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Patient Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "patient@smartkare.com",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Drawer Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_rounded,
                  text: "Dashboard",
                  color: menuColor,
                  onTap: () => onTap(0),
                ),
                _DrawerItem(
                  icon: Icons.calendar_month_rounded,
                  text: "Appointments",
                  color: menuColor,
                  onTap: () => onTap(1),
                ),
                _DrawerItem(
                  icon: Icons.health_and_safety_rounded,
                  text: "Reports",
                  color: menuColor,
                  onTap: () => onTap(2),
                ),
                _DrawerItem(
                  icon: Icons.person_rounded,
                  text: "Profile & Settings",
                  color: menuColor,
                  onTap: () => onTap(3),
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const UniversalLoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🧱 Drawer Item
//
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}

//
// ------------------ Dashboard Home ---------------------
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Header(),
          SizedBox(height: 20),
          _QuickActions(),
          SizedBox(height: 25),
          _HealthOverview(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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

//
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
        "background": const Color(0xFFE3F2FD),
        "onTap": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AppointmentPage()));
        }
      },
      {
        "icon": Icons.policy_rounded,
        "title": "Insurance",
        "color": const Color(0xFF9C27B0),
        "background": const Color(0xFFE6D9F3),
        "onTap": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const InsurancePage()));
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
      ),
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

//
// ------------------ Hover Card ---------------------
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
                  Text(widget.value!,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                Text(widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color:
                            widget.gradient ? Colors.white : Colors.black87)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ------------------ Other Pages ---------------------
class HealthReportsPage extends StatelessWidget {
  const HealthReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            Lottie.asset('assets/animations/health_report.json', height: 200));
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