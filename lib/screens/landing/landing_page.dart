// lib/screens/landing/landing_page.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../auth/universal_login.dart';
import '../auth/universal_register.dart';
import '../appointments/appointment_page.dart';

/// -----------------------------
/// Color & style constants
/// -----------------------------
const Color kPrimaryBlue = Color(0xFF0077B6); // deep healthcare blue
const Color kAccentCyan = Color(0xFF00B4D8); // aqua cyan
const Color kSoftBg = Color(0xFFCAF0F8); // soft background
const double kCardRadius = 14.0;

/// Simple hover helper for web/desktop - safe to be added (non-destructive)
class HoverWidget extends StatefulWidget {
  final Widget Function(bool hovered) builder;
  const HoverWidget({required this.builder, Key? key}) : super(key: key);

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(_hovered),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Scroll notifier for section animations
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollNotifier = ValueNotifier(0);

  // Feature row auto-scroll
  final ScrollController _featureScrollController = ScrollController();
  Timer? _featureAutoScrollTimer;

  // Testimonials page controller & auto-slide
  final PageController _testiPageController =
      PageController(viewportFraction: 0.5);
  Timer? _testiAutoSlideTimer;

  @override
  void initState() {
    super.initState();

    // listen for scrollOffset to drive AnimatedSection visibility
    _scrollController.addListener(() {
      _scrollNotifier.value = _scrollController.offset;
    });

    // Start auto-scrolling features horizontally every 0.5s
    _featureAutoScrollTimer = Timer.periodic(
        const Duration(milliseconds: 500), (_) => _autoScrollFeatures());

    // Start testimonial auto slide every 3 seconds
    _testiAutoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final nextPage = (_testiPageController.page ?? 0) + 1;
      if (_testiPageController.hasClients) {
        _testiPageController.animateToPage(
          (nextPage.toInt()) % _testimonials.length,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollNotifier.dispose();
    _featureAutoScrollTimer?.cancel();
    _featureScrollController.dispose();
    _testiAutoSlideTimer?.cancel();
    _testiPageController.dispose();
    super.dispose();
  }

  // small step auto-scroll
  void _autoScrollFeatures() {
    if (!_featureScrollController.hasClients) return;

    // compute next offset (looping)
    final maxScroll = _featureScrollController.position.maxScrollExtent;
    double next = _featureScrollController.offset + 120; // step
    if (next >= maxScroll) {
      // jump back to start smoothly
      _featureScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
      );
    } else {
      _featureScrollController.animateTo(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
  }

  // Testimonials data (kept local)
  final List<Map<String, String>> _testimonials = const [
    {
      "quote":
          "SmartKare helped me connect with a specialist in minutes. The AI symptom checker is amazing!",
      "author": "Aarav, Patient"
    },
    {
      "quote":
          "Managing hospital operations is now effortless with SmartKare’s blockchain and AI features.",
      "author": "Dr. Meera, Cardiologist"
    },
    {
      "quote":
          "The virtual consultations are smooth and reliable. Highly recommended platform!",
      "author": "Rohit, Patient"
    },
    {
      "quote":
          "Booking and follow-ups are seamless. Doctors are prompt and supportive.",
      "author": "Sana, Patient"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 800;

    return Scaffold(
      backgroundColor: Colors.white,
      // Use a transparent appbar area (we draw our own nav row)
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: true,
        child: ValueListenableBuilder<double>(
          valueListenable: _scrollNotifier,
          builder: (context, scrollOffset, _) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // ----- NAV BAR -----
                  _TopNavBar(
                    onLogin: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const UniversalLoginPage()),
                    ),
                    onRegister: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const UniversalRegisterPage()),
                    ),
                  ),

                  // ----- HERO -----
                  _AnimatedSection(
                    visible: scrollOffset < 150,
                    child: _HeroSection(
                      height: isSmall ? 520 : 680,
                      onBook: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AppointmentPage()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ----- ABOUT (expanded) -----
                  _AnimatedSection(
                    visible: scrollOffset > 120,
                    child: _AboutSection(),
                  ),

                  const SizedBox(height: 6),

                  // ----- KEY FEATURES (horizontal, auto-scroll) -----
                  _AnimatedSection(
                    visible: scrollOffset > 260,
                    child: Container(
                      color: kSoftBg,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          const SectionTitle(title: "Key Features"),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              controller: _featureScrollController,
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _features.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final f = _features[index];
                                return _FeatureChip(
                                  icon: f.icon,
                                  label: f.label,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ----- TESTIMONIALS (2 per view, auto-slide) -----
                  _AnimatedSection(
                    visible: scrollOffset > 420,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          const SectionTitle(title: "What Our Users Say"),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 220,
                            // PageView with viewportFraction 0.5 -> shows 2 per screen horizontally
                            child: PageView.builder(
                              controller: _testiPageController,
                              itemCount: _testimonials.length,
                              itemBuilder: (context, index) {
                                final t = _testimonials[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: _TestimonialCard(
                                    quote: t['quote']!,
                                    author: t['author']!,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ----- CONTACT + FOOTER combined -----
                  _AnimatedSection(
                    visible: scrollOffset > 700,
                    child: _ContactFooterSection(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // local list of features
  final List<_Feature> _features = const [
    _Feature(icon: Icons.calendar_month, label: "Online OP Booking"),
    _Feature(icon: Icons.local_hospital, label: "Hospital Management"),
    _Feature(icon: Icons.video_call, label: "Telemedicine"),
    _Feature(icon: Icons.shield, label: "Blockchain Security"),
    _Feature(icon: Icons.science, label: "AI Diagnosis"),
    _Feature(icon: Icons.analytics, label: "Predictive Analytics"),
    _Feature(icon: Icons.medication, label: "Pharmacy Management"),
    _Feature(icon: Icons.monitor_heart, label: "Remote Monitoring"),
  ];
}

// ----------------------------- NAVBAR -----------------------------
class _TopNavBar extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const _TopNavBar({required this.onLogin, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryBlue, kAccentCyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            // Logo (left)
            Row(
              children: [
                // Replace 'assets/images/logo.png' with your logo file
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, __) {
                        // fallback simple icon if asset missing
                        return const Icon(Icons.local_hospital,
                            color: kPrimaryBlue);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "SmartKare",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ],
            ),

            // Spacer center (nav links)
            Expanded(
              child: Center(
                child: isSmall
                    // on small screens show a minimal menu
                    ? PopupMenuButton<int>(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 0, child: Text("Home")),
                          const PopupMenuItem(value: 1, child: Text("About")),
                          const PopupMenuItem(
                              value: 2, child: Text("Specialists")),
                          const PopupMenuItem(
                              value: 3, child: Text("Contact Us")),
                        ],
                        onSelected: (v) {
                          // noop: you can add scroll/navigate behaviour
                        },
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavLink(label: "Home"),
                          const SizedBox(width: 18),
                          _NavLink(label: "About"),
                          const SizedBox(width: 18),
                          _NavLink(label: "Specialists"),
                          const SizedBox(width: 18),
                          _NavLink(label: "Contact Us"),
                        ],
                      ),
              ),
            ),

            // Right side - Login/Register
            Row(
              children: [
                TextButton(
                  onPressed: onLogin,
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 8),
                HoverWidget(builder: (hovered) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    transform: hovered
                        ? (Matrix4.identity()..scale(1.03))
                        : Matrix4.identity(),
                    child: ElevatedButton(
                      onPressed: onRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimaryBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Register"),
                    ),
                  );
                }),
              ],
            ),
          ],
        );
      }),
    );
  }
}

// ------------------------------------------------------------
// 🔹 Animated Section Wrapper (Smooth slide + fade)
// ------------------------------------------------------------
class _AnimatedSection extends StatelessWidget {
  final Widget child;
  final bool visible;

  const _AnimatedSection({
    required this.child,
    required this.visible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 0.06),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        child: child,
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  const _NavLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return HoverWidget(builder: (hovered) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: hovered ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: hovered ? Colors.white : Colors.white70,
            fontWeight: hovered ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      );
    });
  }
}

// ----------------------------- HERO -----------------------------
class _HeroSection extends StatelessWidget {
  final double height;
  final VoidCallback onBook;
  const _HeroSection({required this.height, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryBlue, kAccentCyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Left column: title + CTA
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Healthcare, Reimagined.",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  "SmartKare combines AI diagnostics, secure data with blockchain, and intuitive OP booking to deliver faster, smarter care.",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    HoverWidget(builder: (hovered) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        transform: hovered
                            ? (Matrix4.identity()..scale(1.04))
                            : Matrix4.identity(),
                        child: ElevatedButton.icon(
                          onPressed: onBook,
                          icon: const Icon(Icons.calendar_month),
                          label: const Text("Book Appointment"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.white,
                            foregroundColor: kPrimaryBlue,
                            elevation: hovered ? 10 : 3,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const UniversalRegisterPage()),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Get Started"),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // small secondary cards
                Row(
                  children: [
                    _StatPill(
                      icon: Icons.verified_user,
                      label: "Secure",
                    ),
                    const SizedBox(width: 10),
                    _StatPill(
                      icon: Icons.speed,
                      label: "Fast",
                    ),
                    const SizedBox(width: 10),
                    _StatPill(
                      icon: Icons.support_agent,
                      label: "24/7",
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right column: Lottie or illustration
          Expanded(
            flex: 5,
            child: Center(
              child: SizedBox(
                width: isSmall ? 260 : 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lottie placeholder; add your lottie at assets/animations/hero_health.json
                    if (!kIsWeb)
                      Lottie.asset(
                        'assets/animations/hero_health.json',
                        height: isSmall ? 200 : 300,
                        fit: BoxFit.contain,
                        // if asset missing, show fallback icon via errorBuilder
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.health_and_safety,
                              size: 120, color: Colors.white70);
                        },
                      )
                    else
                      // web / fallback
                      const Icon(Icons.health_and_safety,
                          size: 140, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// ----------------------------- ABOUT -----------------------------
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "About SmartKare"),
            const SizedBox(height: 12),
            Text(
              "SmartKare is a next-generation digital healthcare ecosystem designed to put patients first. "
              "We combine AI-driven symptom analysis, secure and transparent records using blockchain, telemedicine, and a smart OP booking engine so patients find the right care quickly. "
              "Our platform supports both virtual and in-person consultations and focuses on speed, security, and accessibility.",
              style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  color: Colors.black87,
                  height: 1.5),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _AboutBadge(icon: Icons.security, title: "Data Security"),
                _AboutBadge(icon: Icons.access_time, title: "Faster Bookings"),
                _AboutBadge(icon: Icons.support_agent, title: "24/7 Support"),
                _AboutBadge(
                    icon: Icons.leaderboard, title: "Analytics & Insights"),
              ],
            ),
            const SizedBox(height: 18),
            // secondary paragraph with more details
            Text(
              "Built for hospitals and patients alike, SmartKare scales from small clinics to large hospital networks. We emphasize interoperability, privacy-by-design, and a smooth patient journey — from discovery to follow-up.",
              style: TextStyle(
                  fontSize: isSmall ? 13 : 15,
                  color: Colors.black54,
                  height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  const _AboutBadge({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, kSoftBg.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimaryBlue),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ----------------------------- FEATURES -----------------------------
class _Feature {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return HoverWidget(builder: (hovered) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hovered ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(kCardRadius),
          boxShadow: [
            BoxShadow(
                color: hovered ? kAccentCyan.withOpacity(0.16) : Colors.black12,
                blurRadius: hovered ? 14 : 8,
                offset: const Offset(0, 6))
          ],
          border: Border.all(color: kPrimaryBlue.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: kAccentCyan.withOpacity(0.12),
                child: Icon(icon, color: kPrimaryBlue)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black87))),
          ],
        ),
      );
    });
  }
}

// ----------------------------- TESTIMONIALS -----------------------------
class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  const _TestimonialCard({required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return HoverWidget(builder: (hovered) {
      return Card(
        elevation: hovered ? 12 : 6,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.format_quote,
                  color: kPrimaryBlue.withOpacity(0.14), size: 30),
              const SizedBox(height: 8),
              Text(
                quote,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14, color: Colors.black87.withOpacity(0.95)),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text("- $author",
                    style: TextStyle(
                        color: kPrimaryBlue, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      );
    });
  }
}

// ----------------------------- CONTACT + FOOTER -----------------------------
class _ContactFooterSection extends StatelessWidget {
  const _ContactFooterSection();

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryBlue, kAccentCyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: isSmall ? _mobileContact() : _desktopContact(),
      ),
    );
  }

  Widget _desktopContact() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // left: brand + brief
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("SmartKare",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  "Delivering smarter, faster healthcare with AI and secure systems. Contact us for demos and integrations.",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),

        // center: contact
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 4),
              Text("Contact",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("📧 support@smartkare.com",
                  style: TextStyle(color: Colors.white70)),
              Text("📞 +91 98765 43210",
                  style: TextStyle(color: Colors.white70)),
              Text("🏢 Hyderabad, Andhra Pradesh, India",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),

        // right: small links
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Quick Links",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Home", style: TextStyle(color: Colors.white70)),
              Text("About", style: TextStyle(color: Colors.white70)),
              Text("Specialists", style: TextStyle(color: Colors.white70)),
              Text("Privacy", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mobileContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("SmartKare",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("📧 support@smartkare.com",
            style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text("📞 +91 98765 43210", style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text("🏢 Hyderabad, Andhra Pradesh, India",
            style: TextStyle(color: Colors.white70)),
        SizedBox(height: 12),
        Text("© 2025 SmartKare | Designed by Teja Kotcherla",
            style: TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}

// ----------------------------- UTIL -----------------------------
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: kPrimaryBlue),
        ),
        const SizedBox(width: 8),
        // glowing dot
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [kAccentCyan, kPrimaryBlue]),
            boxShadow: [
              BoxShadow(color: kAccentCyan.withOpacity(0.5), blurRadius: 8)
            ],
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }
}
