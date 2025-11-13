// landing_page.dart
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/universal_login.dart';
import '../auth/universal_register.dart';
import '../appointments/appointment_page.dart';

/// -----------------------------
/// THEME CONSTANTS
/// -----------------------------
const Color kPrimaryBlue = Color(0xFF0077B6);
const Color kAccentCyan = Color(0xFF00B4D8);
const Color kSoftBg = Color(0xFFCAF0F8);

/// -----------------------------
/// FadeInUp animation helper
/// -----------------------------
class FadeInUp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double offsetY;

  const FadeInUp({
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
    this.offsetY = 24.0,
    Key? key,
  }) : super(key: key);

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final t = _anim.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offsetY),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// -----------------------------
/// HoverCard - reusable hoverable container (web)
/// -----------------------------
class HoverCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const HoverCard({
    required this.child,
    this.width = 220,
    this.height = 220,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final scale = (_hover && isDesktop) ? 1.04 : 1.0;
    final boxShadow = (_hover && isDesktop)
        ? [BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 8))]
        : [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))];

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.identity()..scale(scale),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: boxShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// -----------------------------
/// LandingPage
/// -----------------------------
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final PageController _testiController = PageController(viewportFraction: 0.6);
  Timer? _testiTimer;

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey doctorsKey = GlobalKey();
  final GlobalKey testimonialsKey = GlobalKey();
  final GlobalKey healthTipsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  String _activeSection = "Home";

  // typed lists - avoid Map<String, Object> problems
  final List<Map<String, String>> _testimonials = [
    {"quote": "SmartKare helped me connect with a specialist in minutes.", "author": "Aarav, Patient"},
    {"quote": "Managing hospital operations is now effortless.", "author": "Dr. Meera, Cardiologist"},
    {"quote": "The virtual consultations are smooth and reliable.", "author": "Rohit, Patient"},
    {"quote": "Doctors are prompt and supportive.", "author": "Sana, Patient"},
    {"quote": "Loved the booking flow — so intuitive!", "author": "Nikhil, Patient"},
    {"quote": "AI reports are helpful for early diagnosis.", "author": "Dr. Ananya, Oncologist"},
  ];

  final List<Map<String, String>> _services = [
    {"title": "24/7 Monitoring", "desc": "AI-powered continuous patient monitoring and alerts.", "icon": "monitor_heart"},
    {"title": "Smart OP Booking", "desc": "Fast appointment scheduling and reminders.", "icon": "medical_services"},
    {"title": "Virtual Consultations", "desc": "Secure video calls with specialists.", "icon": "videocam"},
    {"title": "Blockchain Records", "desc": "Immutable and secure patient records.", "icon": "security"},
    {"title": "AI Diagnostics", "desc": "AI-driven insights to support clinical decisions.", "icon": "analytics"},
    {"title": "Pharmacy Management", "desc": "End-to-end pharma inventory & delivery.", "icon": "local_pharmacy"},
  ];

  final List<Map<String, String>> _doctors = [
    {"name": "Dr. Meera Iyer", "role": "Cardiologist", "exp": "12+ yrs", "edu": "MD (Cardiology), AIIMS"},
    {"name": "Dr. Aarav Sharma", "role": "Neurologist", "exp": "10+ yrs", "edu": "DM (Neurology), NIMHANS"},
    {"name": "Dr. Rohit Verma", "role": "Pediatrician", "exp": "8+ yrs", "edu": "MD (Pediatrics), JIPMER"},
    {"name": "Dr. Ananya Rao", "role": "Oncologist", "exp": "9+ yrs", "edu": "DM (Oncology), Tata Memorial"},
    {"name": "Dr. Priya Nair", "role": "Dermatologist", "exp": "7+ yrs", "edu": "MD (Dermatology), Manipal"},
  ];

  // tips contain IconData so use Map<String, Object> but cast when used
  final List<Map<String, Object>> _tips = [
    {"icon": Icons.fitness_center, "emoji": "🏃", "title": "Exercise Regularly", "desc": "Keep your heart and mind fit."},
    {"icon": Icons.local_drink, "emoji": "💧", "title": "Stay Hydrated", "desc": "Water is essential for every cell."},
    {"icon": Icons.bedtime, "emoji": "😴", "title": "Sleep Well", "desc": "Quality sleep improves recovery."},
    {"icon": Icons.restaurant, "emoji": "🥗", "title": "Eat Balanced Meals", "desc": "Nutrition fuels health."},
    {"icon": Icons.sentiment_satisfied_alt, "emoji": "😊", "title": "Stay Positive", "desc": "Mental health matters."},
    {"icon": Icons.health_and_safety, "emoji": "🩺", "title": "Regular Checkups", "desc": "Prevention is better than cure."},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _testiTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_testiController.hasClients) return;
      int next = (_testiController.page?.round() ?? 0) + 1;
      if (next >= _testimonials.length) next = 0;
      _testiController.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    setState(() {
      if (offset < 400) _activeSection = "Home";
      else if (offset < 1000) _activeSection = "About";
      else if (offset < 1600) _activeSection = "Services";
      else if (offset < 2300) _activeSection = "Doctors";
      else if (offset < 3000) _activeSection = "Testimonials";
      else if (offset < 3700) _activeSection = "HealthTips";
      else _activeSection = "Contact";
    });
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext == null) return;
    Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _testiTimer?.cancel();
    _testiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    double progress = 0;
    if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
      progress = (_scrollController.offset / _scrollController.position.maxScrollExtent).clamp(0.0, 1.0);
    }

    return Scaffold(
      endDrawer: _MobileDrawer(
        onNavigate: _scrollTo,
        homeKey: homeKey,
        aboutKey: aboutKey,
        servicesKey: servicesKey,
        doctorsKey: doctorsKey,
        testimonialsKey: testimonialsKey,
        healthTipsKey: healthTipsKey,
        contactKey: contactKey,
      ),
      body: Row(
        children: [
          if (!isMobile)
            SlideInLeft(
              child: _SideBar(
                active: _activeSection,
                homeKey: homeKey,
                aboutKey: aboutKey,
                servicesKey: servicesKey,
                doctorsKey: doctorsKey,
                testimonialsKey: testimonialsKey,
                contactKey: contactKey,
                onNavigate: _scrollTo,
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    setState(() {});
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _HeroSection(key: homeKey),
                        _AboutSection(key: aboutKey),
                        _ServicesSection(key: servicesKey, services: _services),
                        _DoctorsSection(key: doctorsKey, doctors: _doctors),
                        _TestimonialsSection(key: testimonialsKey, controller: _testiController, testimonials: _testimonials),
                        _HealthTipsSection(key: healthTipsKey, tips: _tips),
                        const SizedBox(height: 24),
                        _FooterSection(
                          key: contactKey,
                          homeKey: homeKey,
                          aboutKey: aboutKey,
                          servicesKey: servicesKey,
                          doctorsKey: doctorsKey,
                          contactKey: contactKey,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator(value: progress, backgroundColor: Colors.transparent, color: kAccentCyan, minHeight: 3)),
                Positioned(
                  top: 12,
                  left: isMobile ? 12 : 24,
                  right: 24,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _scrollController.hasClients && _scrollController.offset > 50 ? [const BoxShadow(color: Colors.black26, blurRadius: 10)] : [],
                    ),
                    child: _TopNavBar(
                      active: _activeSection,
                      onNavigate: _scrollTo,
                      homeKey: homeKey,
                      aboutKey: aboutKey,
                      servicesKey: servicesKey,
                      doctorsKey: doctorsKey,
                      testimonialsKey: testimonialsKey,
                      healthTipsKey: healthTipsKey,
                      contactKey: contactKey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------
/// SlideInLeft wrapper
/// -----------------------------
class SlideInLeft extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double from;

  const SlideInLeft({required this.child, this.duration = const Duration(milliseconds: 700), this.delay = Duration.zero, this.from = 80, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(delay: delay, duration: duration, offsetY: from, child: child);
  }
}

/// -----------------------------
/// Sidebar
/// -----------------------------
class _SideBar extends StatelessWidget {
  final String active;
  final void Function(GlobalKey) onNavigate;
  final GlobalKey homeKey, aboutKey, servicesKey, doctorsKey, testimonialsKey, contactKey;

  const _SideBar({
    required this.active,
    required this.onNavigate,
    required this.homeKey,
    required this.aboutKey,
    required this.servicesKey,
    required this.doctorsKey,
    required this.testimonialsKey,
    required this.contactKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [kPrimaryBlue, kAccentCyan], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.local_hospital, color: Colors.white, size: 28),
          Column(
            children: [
              Tooltip(message: 'Home', child: _SidebarIcon(icon: Icons.home, active: active == "Home", onTap: () => onNavigate(homeKey))),
              Tooltip(message: 'About', child: _SidebarIcon(icon: Icons.info_outline, active: active == "About", onTap: () => onNavigate(aboutKey))),
              Tooltip(message: 'Services', child: _SidebarIcon(icon: Icons.medical_services, active: active == "Services", onTap: () => onNavigate(servicesKey))),
              Tooltip(message: 'Doctors', child: _SidebarIcon(icon: Icons.people_alt, active: active == "Doctors", onTap: () => onNavigate(doctorsKey))),
              Tooltip(message: 'Testimonials', child: _SidebarIcon(icon: Icons.reviews, active: active == "Testimonials", onTap: () => onNavigate(testimonialsKey))),
              Tooltip(message: 'Contact', child: _SidebarIcon(icon: Icons.contact_mail, active: active == "Contact", onTap: () => onNavigate(contactKey))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: const [
                FaIcon(FontAwesomeIcons.facebookF, size: 14, color: Colors.white70),
                SizedBox(height: 10),
                FaIcon(FontAwesomeIcons.linkedinIn, size: 14, color: Colors.white70),
                SizedBox(height: 10),
                FaIcon(FontAwesomeIcons.instagram, size: 14, color: Colors.white70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _SidebarIcon({required this.icon, required this.active, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(shape: BoxShape.circle, color: active ? Colors.white.withOpacity(0.25) : Colors.transparent),
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

/// -----------------------------
/// Top Navigation
/// -----------------------------
class _NavButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.active, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: GoogleFonts.poppins(fontWeight: active ? FontWeight.bold : FontWeight.w500, color: active ? kPrimaryBlue : Colors.black87)),
            const SizedBox(height: 4),
            if (active)
              Container(height: 3, width: 20, decoration: BoxDecoration(color: kAccentCyan, borderRadius: BorderRadius.circular(3)))
            else
              const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  final String active;
  final void Function(GlobalKey) onNavigate;
  final GlobalKey homeKey, aboutKey, servicesKey, doctorsKey, testimonialsKey, healthTipsKey, contactKey;

  const _TopNavBar({
    required this.active,
    required this.onNavigate,
    required this.homeKey,
    required this.aboutKey,
    required this.servicesKey,
    required this.doctorsKey,
    required this.testimonialsKey,
    required this.healthTipsKey,
    required this.contactKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(onTap: () => onNavigate(homeKey), child: const Text("SmartKare", style: TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 20))),
          const SizedBox(width: 18),
          if (!isMobile)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _NavButton(label: "Home", active: active == "Home", onTap: () => onNavigate(homeKey)),
                  _NavButton(label: "About", active: active == "About", onTap: () => onNavigate(aboutKey)),
                  _NavButton(label: "Services", active: active == "Services", onTap: () => onNavigate(servicesKey)),
                  _NavButton(label: "Doctors", active: active == "Doctors", onTap: () => onNavigate(doctorsKey)),
                  _NavButton(label: "Testimonials", active: active == "Testimonials", onTap: () => onNavigate(testimonialsKey)),
                  _NavButton(label: "Health Tips", active: active == "HealthTips", onTap: () => onNavigate(healthTipsKey)),
                  _NavButton(label: "Contact", active: active == "Contact", onTap: () => onNavigate(contactKey)),
                ],
              ),
            )
          else
            const Spacer(),
          if (!isMobile)
            Row(
              children: [
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversalLoginPage())), child: const Text("Login", style: TextStyle(color: kPrimaryBlue))),
                const SizedBox(width: 6),
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversalRegisterPage())), style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text("Register", style: TextStyle(color: Colors.white))),
              ],
            )
          else
            Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu, color: kPrimaryBlue, size: 28), onPressed: () => Scaffold.of(context).openEndDrawer())),
        ],
      ),
    );
  }
}

/// -----------------------------
/// Mobile Drawer
/// -----------------------------
class _MobileDrawer extends StatelessWidget {
  final void Function(GlobalKey) onNavigate;
  final GlobalKey homeKey, aboutKey, servicesKey, doctorsKey, testimonialsKey, healthTipsKey, contactKey;

  const _MobileDrawer({required this.onNavigate, required this.homeKey, required this.aboutKey, required this.servicesKey, required this.doctorsKey, required this.testimonialsKey, required this.healthTipsKey, required this.contactKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20), children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("SmartKare", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryBlue)),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 20),
        _drawerItem(context, "Home", () => onNavigate(homeKey)),
        _drawerItem(context, "About", () => onNavigate(aboutKey)),
        _drawerItem(context, "Services", () => onNavigate(servicesKey)),
        _drawerItem(context, "Doctors", () => onNavigate(doctorsKey)),
        _drawerItem(context, "Testimonials", () => onNavigate(testimonialsKey)),
        _drawerItem(context, "Health Tips", () => onNavigate(healthTipsKey)),
        _drawerItem(context, "Contact", () => onNavigate(contactKey)),
        const Divider(height: 30, color: Colors.black26),
        ListTile(title: const Text("Login", style: TextStyle(color: kPrimaryBlue)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversalLoginPage()))),
        ListTile(title: const Text("Register", style: TextStyle(color: kPrimaryBlue)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversalRegisterPage()))),
      ]),
    );
  }

  Widget _drawerItem(BuildContext context, String label, VoidCallback onTap) {
    return ListTile(title: Text(label, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)), onTap: () {
      Navigator.pop(context);
      onTap();
    });
  }
}

/// -----------------------------
/// Hero Section
/// -----------------------------
class _HeroSection extends StatelessWidget {
  const _HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      height: isMobile ? 880 : 680,
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/medical_team.jpg'), fit: BoxFit.cover, alignment: Alignment.center)),
      child: Container(
        color: const Color.fromARGB(255, 59, 53, 53).withOpacity(0.2),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: isMobile ? 36 : 40),
        child: Center(
          child: FadeInUp(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                // Logo + Brand (same line on web)
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: isMobile ? 84 : 120, fit: BoxFit.contain),
                    SizedBox(width: isMobile ? 0 : 16, height: isMobile ? 12 : 0),
                    Column(crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
                      Text("SmartKare", style: GoogleFonts.poppins(fontSize: isMobile ? 32 : 42, fontWeight: FontWeight.bold, color: Colors.white, height: 1.05)),
                      Text("Healthcare, Reimagined.", style: GoogleFonts.poppins(fontSize: isMobile ? 15 : 18, color: Colors.white70)),
                    ]),
                  ],
                ),
                const SizedBox(height: 36),

                // Quotation centered under logo block
                Center(
                  child: Column(children: [
                    Text("“The greatest wealth is health.”", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text("— Virgil (Ancient Rome)", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isMobile ? 13 : 15, fontStyle: FontStyle.italic, color: Colors.white70)),
                  ]),
                ),
                const SizedBox(height: 24),

                // Description
                FadeInUp(delay: const Duration(milliseconds: 250), child: Text("SmartKare brings AI diagnostics, secure blockchain data, and fast OP bookings together for a new era of healthcare innovation.", textAlign: isMobile ? TextAlign.center : TextAlign.start, style: GoogleFonts.poppins(fontSize: isMobile ? 15 : 16, color: Colors.white70, height: 1.6))),
                const SizedBox(height: 28),

                // Buttons
                Wrap(spacing: 12, alignment: isMobile ? WrapAlignment.center : WrapAlignment.start, children: [
                  ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentPage())), icon: const Icon(Icons.calendar_month), label: const Text("Book Appointment"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kPrimaryBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversalRegisterPage())), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white70), foregroundColor: Colors.white), child: const Text("Get Started")),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------
/// About Section
/// -----------------------------
class _AboutSection extends StatelessWidget {
  const _AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle(title: "About SmartKare"),
      const SizedBox(height: 14),
      FadeInUp(delay: const Duration(milliseconds: 200), child: Text("SmartKare is a next-generation healthcare ecosystem designed to make care simpler, faster, and more secure. We combine AI-driven symptom analysis, telemedicine, blockchain-based records, and real-time appointment management so that patients receive accurate, efficient healthcare anywhere.", style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87, height: 1.6))),
    ]));
  }
}

/// -----------------------------
/// Services Section
/// -----------------------------
class _ServicesSection extends StatelessWidget {
  final List<Map<String, String>> services;
  const _ServicesSection({super.key, required this.services});

  IconData _iconFromString(String key) {
    switch (key) {
      case 'monitor_heart':
        return Icons.monitor_heart;
      case 'medical_services':
        return Icons.medical_services;
      case 'videocam':
        return Icons.videocam;
      case 'security':
        return Icons.security;
      case 'analytics':
        return Icons.analytics;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(width: double.infinity, color: kSoftBg, padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 60), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SectionTitle(title: "Our Services"),
      const SizedBox(height: 24),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Center(child: Wrap(alignment: WrapAlignment.center, spacing: 24, runSpacing: 24, children: List.generate(services.length, (i) {
        final s = services[i];
        final iconKey = s['icon'] ?? '';
        return FadeInUp(delay: Duration(milliseconds: 120 * i), child: HoverCard(width: isMobile ? 260 : 260, height: 160, child: Padding(padding: const EdgeInsets.all(18), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(_iconFromString(iconKey), color: kPrimaryBlue, size: 36),
          const SizedBox(height: 10),
          Text(s['title'] ?? '', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(s['desc'] ?? '', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
        ]))));
      }))))]),
    );
  }
}

/// -----------------------------
/// Doctors / Specialists Section
/// -----------------------------
class _DoctorsSection extends StatelessWidget {
  final List<Map<String, String>> doctors;
  const _DoctorsSection({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;
    final isMobile = MediaQuery.of(context).size.width < 900;
    final cardWidth = isMobile ? 260.0 : (isWide ? 260.0 : 240.0);

    return Container(width: double.infinity, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/doctors-shaking-hands.jpg'), fit: BoxFit.cover)), child: Container(color: Colors.white.withOpacity(0.85), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SectionTitle(title: "Meet Our Specialists"),
      const SizedBox(height: 30),
      Center(child: Wrap(alignment: WrapAlignment.center, spacing: 28, runSpacing: 28, children: List.generate(doctors.length, (i) {
        final d = doctors[i];
        return FadeInUp(delay: Duration(milliseconds: 180 * i), child: HoverCard(width: cardWidth, height: 300, child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          const CircleAvatar(radius: 44, backgroundImage: AssetImage('assets/images/doctor_placeholder.jpg')),
          const SizedBox(height: 12),
          Text(d['name'] ?? '', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: kPrimaryBlue)),
          const SizedBox(height: 6),
          Text(d['role'] ?? '', style: GoogleFonts.poppins(color: Colors.black87)),
          const SizedBox(height: 10),
          Text(d['exp'] ?? '', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 6),
          Text(d['edu'] ?? '', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
          const Spacer(),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10)), child: const Text("View Profile")),
        ]))));
      }))),
    ])));
  }
}

/// -----------------------------
/// Testimonials Section (typed)
/// -----------------------------
class _TestimonialsSection extends StatefulWidget {
  final PageController controller;
  final List<Map<String, String>> testimonials;

  const _TestimonialsSection({super.key, required this.controller, required this.testimonials});

  @override
  State<_TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<_TestimonialsSection> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_pageListener);
  }

  void _pageListener() {
    final p = widget.controller.page ?? 0.0;
    setState(() => _current = p.round());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = widget.testimonials;
    return Container(
      height: 380,
      margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: AssetImage('assets/images/clipboard.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white70, BlendMode.modulate),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.white.withOpacity(0.85),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SectionTitle(title: "What Our Users Say"),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView.builder(
                    controller: widget.controller,
                    itemCount: testimonials.length,
                    itemBuilder: (context, i) {
                      final Map<String, String> t = testimonials[i];
                      return Center(
                        child: SizedBox(
                          width: 460,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.format_quote, size: 36, color: kAccentCyan),
                                  const SizedBox(height: 10),
                                  Text(t['quote'] ?? '', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)),
                                  const SizedBox(height: 12),
                                  Text("- ${t['author'] ?? ''}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: kPrimaryBlue)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(testimonials.length, (idx) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: _current == idx ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(color: _current == idx ? kPrimaryBlue : Colors.black26, borderRadius: BorderRadius.circular(8)),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------
/// Health Tips Section (tips typed as Map<String, Object>)
/// -----------------------------
class _HealthTipsSection extends StatelessWidget {
  final List<Map<String, Object>> tips;
  const _HealthTipsSection({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [kSoftBg, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SectionTitle(title: "Daily Health Tips"),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Colors.white, Color(0xFFE8FBFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: List.generate(tips.length, (i) {
                  final Map<String, Object> t = tips[i];
                  final iconData = t['icon'] as IconData;
                  final title = t['title'] as String;
                  final desc = t['desc'] as String;
                  final emoji = t['emoji'] as String;
                  return FadeInUp(
                    delay: Duration(milliseconds: 160 * i),
                    child: HoverCard(
                      width: isMobile ? 180 : 200,
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, val, ch) {
                                final bounce = (val * 8);
                                return Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(color: kAccentCyan.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: bounce / 2),
                                    child: Icon(iconData, size: 34, color: kPrimaryBlue),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(desc, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// -----------------------------
/// Footer (receives keys)
/// -----------------------------
class _FooterSection extends StatelessWidget {
  final GlobalKey homeKey, aboutKey, servicesKey, doctorsKey, contactKey;

  const _FooterSection({super.key, required this.homeKey, required this.aboutKey, required this.servicesKey, required this.doctorsKey, required this.contactKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    Widget footerLink(String label, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Text(label, style: GoogleFonts.poppins(color: Colors.white70)));

    return Container(
      color: kPrimaryBlue,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 36),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [Image.asset('assets/images/logo.png', height: 28), const SizedBox(width: 8), Text("SmartKare", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 8),
                Text("Delivering smarter, faster healthcare with AI and secure systems.", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                Text("Contact Us", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text("📧 support@smartkare.com", style: GoogleFonts.poppins(color: Colors.white70)),
                Text("📞 +91 98765 43210", style: GoogleFonts.poppins(color: Colors.white70)),
                const SizedBox(height: 18),
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                Text("Quick Links", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(spacing: 12, runSpacing: 8, children: [
                  footerLink("Home", () => Scrollable.ensureVisible(homeKey.currentContext!, duration: const Duration(milliseconds: 600))),
                  footerLink("About", () => Scrollable.ensureVisible(aboutKey.currentContext!, duration: const Duration(milliseconds: 600))),
                  footerLink("Services", () => Scrollable.ensureVisible(servicesKey.currentContext!, duration: const Duration(milliseconds: 600))),
                  footerLink("Doctors", () => Scrollable.ensureVisible(doctorsKey.currentContext!, duration: const Duration(milliseconds: 600))),
                  footerLink("Contact", () => Scrollable.ensureVisible(contactKey.currentContext!, duration: const Duration(milliseconds: 600))),
                ]),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("© 2025 SmartKare | Designed by Python_HMS", style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                  Row(children: [IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.facebookF, size: 14, color: Colors.white70)), IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 14, color: Colors.white70)), IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.instagram, size: 14, color: Colors.white70))]),
                ])
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Image.asset('assets/images/logo.png', height: 28), const SizedBox(width: 8), Text("SmartKare", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 8),
                  SizedBox(width: 300, child: Text("Delivering smarter, faster healthcare with AI and secure systems.", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13))),
                  const SizedBox(height: 12),
                  Row(children: [IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.facebookF, size: 14, color: Colors.white70)), IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 14, color: Colors.white70)), IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.instagram, size: 14, color: Colors.white70))]),
                ]),

                // Center
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Contact Us", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("📧 support@smartkare.com", style: GoogleFonts.poppins(color: Colors.white70)),
                  Text("📞 +91 98765 43210", style: GoogleFonts.poppins(color: Colors.white70)),
                  const SizedBox(height: 10),
                  TextButton(onPressed: () => Scrollable.ensureVisible(homeKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Row(children: [const Icon(Icons.arrow_upward, color: Colors.white70, size: 18), const SizedBox(width: 6), Text("Back to top", style: GoogleFonts.poppins(color: Colors.white70))])),
                ]),

                // Right
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Quick Links", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  GestureDetector(onTap: () => Scrollable.ensureVisible(homeKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Text("Home", style: GoogleFonts.poppins(color: Colors.white70))),
                  const SizedBox(height: 6),
                  GestureDetector(onTap: () => Scrollable.ensureVisible(aboutKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Text("About", style: GoogleFonts.poppins(color: Colors.white70))),
                  const SizedBox(height: 6),
                  GestureDetector(onTap: () => Scrollable.ensureVisible(servicesKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Text("Services", style: GoogleFonts.poppins(color: Colors.white70))),
                  const SizedBox(height: 6),
                  GestureDetector(onTap: () => Scrollable.ensureVisible(doctorsKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Text("Doctors", style: GoogleFonts.poppins(color: Colors.white70))),
                  const SizedBox(height: 6),
                  GestureDetector(onTap: () => Scrollable.ensureVisible(contactKey.currentContext!, duration: const Duration(milliseconds: 600)), child: Text("Contact", style: GoogleFonts.poppins(color: Colors.white70))),
                  const SizedBox(height: 18),
                  Text("© 2025 SmartKare | Designed by Python_HMS", style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                ]),
              ],
            ),
    );
  }
}

/// -----------------------------
/// Section Title
/// -----------------------------
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(title, style: GoogleFonts.poppins(color: kPrimaryBlue, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(width: 8),
      Container(width: 10, height: 10, decoration: const BoxDecoration(color: kAccentCyan, shape: BoxShape.circle)),
    ]);
  }
}