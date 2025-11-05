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
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                ),
              ),
              accountName: const Text("Dr. Emily Watson",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: const Text("dr.emily@smartkare.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.medical_services,
                    size: 40, color: Colors.blueAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text("Appointments"),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Profile"),
              onTap: () => _onItemTapped(2),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: "Appointments"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
    );
  }
}

//
// --- Home Section for Doctor ---
//
class _DoctorHome extends StatelessWidget {
  const _DoctorHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome, Doctor!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _DashboardCard(
                    title: "Today's Appointments",
                    icon: Icons.schedule,
                    color: Colors.blueAccent),
                _DashboardCard(
                    title: "Patient Records",
                    icon: Icons.folder_open,
                    color: Colors.green),
                _DashboardCard(
                    title: "AI Diagnostics",
                    icon: Icons.psychology,
                    color: Colors.purple),
                _DashboardCard(
                    title: "Teleconsultations",
                    icon: Icons.video_call,
                    color: Colors.orangeAccent),
                _DashboardCard(
                    title: "Prescriptions",
                    icon: Icons.receipt_long,
                    color: Colors.teal),
                _DashboardCard(
                    title: "Reports",
                    icon: Icons.bar_chart,
                    color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentsPage extends StatelessWidget {
  const _AppointmentsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Doctor's upcoming appointments will appear here.",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Doctor Profile Section Coming Soon",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _DashboardCard(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
