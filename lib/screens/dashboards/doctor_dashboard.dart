import 'package:flutter/material.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DoctorHome(),
    const _AppointmentsPage(),
    const _ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartKare - Doctor Dashboard"),
        centerTitle: true,
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
      drawer: _DoctorDrawer(onTap: _onItemTapped),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0077B6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

//
// Drawer
//
class _DoctorDrawer extends StatelessWidget {
  final Function(int) onTap;
  const _DoctorDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 123, 194, 236),
                  Color.fromARGB(255, 72, 165, 218),
                  Color.fromARGB(255, 18, 144, 212),
                ],
              ),
            ),
            accountName: const Text("Dr. John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: const Text("doctor@smartkare.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.medical_services,
                  size: 40, color: Color(0xFF0077B6)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Color(0xFF0077B6)),
            title: const Text("Dashboard"),
            onTap: () => onTap(0),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month, color: Color(0xFF0077B6)),
            title: const Text("Appointments"),
            onTap: () => onTap(1),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFF0077B6)),
            title: const Text("Profile"),
            onTap: () => onTap(2),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title:
                const Text("Logout", style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

//
// Home — matches Patient UI and fills width (no right gap)
//
class _DoctorHome extends StatelessWidget {
  const _DoctorHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1FAFF),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFD6ECFF),
                child: Icon(Icons.person, size: 35, color: Color(0xFF0077B6)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Welcome Back, Doctor 👋",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Here is your clinical dashboard",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              )
            ],
          ),

          const SizedBox(height: 24),

          // Action tiles (responsive, no right gap)
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine columns by available width
              final double maxW = constraints.maxWidth;
              int columns;
              if (maxW >= 1200) {
                columns = 4;
              } else if (maxW >= 900) {
                columns = 3;
              } else {
                columns = 2;
              }
              const double spacing = 12;
              // Compute exact tile width so the row fills fully
              final double tileWidth =
                  (maxW - (spacing * (columns - 1))) / columns;

              return Wrap(
                alignment: WrapAlignment.start,
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _DoctorTile(
                    width: tileWidth,
                    label: "Today's Appointments",
                    icon: Icons.schedule,
                    color: const Color(0xFFBDE0FE),
                  ),
                  _DoctorTile(
                    width: tileWidth,
                    label: "Patient Records",
                    icon: Icons.folder_open,
                    color: const Color(0xFFD3F8E2),
                  ),
                  _DoctorTile(
                    width: tileWidth,
                    label: "Prescriptions",
                    icon: Icons.receipt_long,
                    color: const Color(0xFFFDE2E4),
                  ),
                  _DoctorTile(
                    width: tileWidth,
                    label: "Teleconsultations",
                    icon: Icons.video_call,
                    color: const Color(0xFFFFF4B5),
                  ),
                  _DoctorTile(
                    width: tileWidth,
                    label: "Profile & Settings",
                    icon: Icons.settings,
                    color: const Color(0xFFE0E7FF),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          const Text("Clinical Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          // Stats, also responsive
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxW = constraints.maxWidth;
              int columns;
              if (maxW >= 1200) {
                columns = 4;
              } else if (maxW >= 700) {
                columns = 4;
              } else {
                columns = 2;
              }
              const double spacing = 12;
              final double cardWidth =
                  (maxW - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _StatCard(
                      width: cardWidth, value: "12", label: "Appointments"),
                  _StatCard(width: cardWidth, value: "56", label: "Patients"),
                  _StatCard(
                      width: cardWidth, value: "34", label: "Prescriptions"),
                  _StatCard(width: cardWidth, value: "4.9★", label: "Rating"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//
// Tile
//
class _DoctorTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double width;

  const _DoctorTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Stat card
//
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final double width;

  const _StatCard({
    required this.value,
    required this.label,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 123, 194, 236),
            Color.fromARGB(255, 72, 165, 218),
            Color.fromARGB(255, 18, 144, 212),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

//
// Other pages
//
class _AppointmentsPage extends StatelessWidget {
  const _AppointmentsPage();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Doctor Appointments Page"));
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Doctor Profile Page"));
  }
}
