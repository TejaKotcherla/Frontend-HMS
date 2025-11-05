import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _AdminHome(),
    const _ManageUsersPage(),
    const _ReportsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartKare - Admin Dashboard"),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF512DA8), Color(0xFF9575CD)],
                ),
              ),
              accountName: const Text("Super Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              accountEmail: const Text("admin@smartkare.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings,
                    size: 40, color: Colors.deepPurpleAccent),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Manage Users"),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Reports"),
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
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Reports"),
        ],
      ),
    );
  }
}

class _AdminHome extends StatelessWidget {
  const _AdminHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              "Welcome, Administrator!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                _DashboardCard(
                    title: "Manage Doctors",
                    icon: Icons.medical_services,
                    color: Colors.purple),
                _DashboardCard(
                    title: "Manage Patients",
                    icon: Icons.people,
                    color: Colors.blueAccent),
                _DashboardCard(
                    title: "System Analytics",
                    icon: Icons.bar_chart,
                    color: Colors.green),
                _DashboardCard(
                    title: "Security & Roles",
                    icon: Icons.security,
                    color: Colors.orangeAccent),
                _DashboardCard(
                    title: "Billing Overview",
                    icon: Icons.attach_money,
                    color: Colors.teal),
                _DashboardCard(
                    title: "Support Tickets",
                    icon: Icons.support_agent,
                    color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ManageUsersPage extends StatelessWidget {
  const _ManageUsersPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("User management section coming soon.",
          style: TextStyle(fontSize: 18)),
    );
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Reports and analytics dashboard under development.",
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
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
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
