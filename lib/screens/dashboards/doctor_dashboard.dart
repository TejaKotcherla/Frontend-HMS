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
        elevation: 2,
        title: const Text(
          "SmartKare - Doctor Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

//
// Drawer (Menu bar)
//
class _DoctorDrawer extends StatelessWidget {
  final Function(int) onTap;
  const _DoctorDrawer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with gradient background
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
                // ✅ Responsive circular logo
                // ✅ Perfect circular logo – even edges, no gaps
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
          'assets/images/Logo.png', // 👈 your transparent logo path
          fit: BoxFit.fitWidth,       // ✅ fills left & right perfectly
          filterQuality: FilterQuality.high,
          width: size * 1.05,         // ✅ slight zoom for perfect circular fill
          height: size * 1.05,
        ),
      ),
    );
  },
),


                const SizedBox(height: 16),

                // ✅ Responsive doctor name
                const Text(
                  "Dr. john",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "john@smartkare.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.dashboard,
                  text: "Dashboard",
                  onTap: () => onTap(0),
                ),
                _DrawerItem(
                  icon: Icons.calendar_month,
                  text: "Appointments",
                  onTap: () => onTap(1),
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  text: "Profile & Settings",
                  onTap: () => onTap(2),
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
// Drawer Item Widget
//
class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color color;

  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = const Color(0xFF0077B6),
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: _isHovered ? widget.color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? widget.color.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: widget.color),
          title: Text(
            widget.text,
            style: TextStyle(
              color: widget.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

//
// Doctor Home (Dashboard Page)
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Here is your clinical dashboard",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxW = constraints.maxWidth;
              int columns = maxW >= 1200 ? 4 : maxW >= 900 ? 3 : 2;
              const double spacing = 12;
              final double tileWidth =
                  (maxW - (spacing * (columns - 1))) / columns;

              return Wrap(
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
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          const Text("Clinical Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double maxW = constraints.maxWidth;
              int columns = maxW >= 700 ? 4 : 2;
              const double spacing = 12;
              final double cardWidth =
                  (maxW - (spacing * (columns - 1))) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _StatCard(width: cardWidth, value: "12", label: "Appointments"),
                  _StatCard(width: cardWidth, value: "56", label: "Patients"),
                  _StatCard(width: cardWidth, value: "34", label: "Prescriptions"),
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
// Hoverable Doctor Tile
//
class _DoctorTile extends StatefulWidget {
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
  State<_DoctorTile> createState() => _DoctorTileState();
}

class _DoctorTileState extends State<_DoctorTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: 120,
        transform: isHovered
            ? (Matrix4.identity()..scale(1.05))
            : (Matrix4.identity()..scale(1.0)),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 34, color: Colors.black87),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Stat Card (with hover animation)
//
class _StatCard extends StatefulWidget {
  final String value;
  final String label;
  final double width;

  const _StatCard({
    required this.value,
    required this.label,
    required this.width,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        padding: const EdgeInsets.all(16),
        transform: isHovered
            ? (Matrix4.identity()..scale(1.05))
            : (Matrix4.identity()..scale(1.0)),
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
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

//
// Other Pages
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
    return const Center(child: Text("Doctor Profile & Settings Page"));
  }
}
