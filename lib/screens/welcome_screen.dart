import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robofinal/screens/login_screen.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF0EA5E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _Slide1Welcome(animation: _animationController),
                    _Slide2SmartCleaning(animation: _animationController),
                    _Slide3RealTimeUpdates(animation: _animationController),
                    _Slide4Permissions(animation: _animationController),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final bool isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF22C55E)
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width < 500 ? size.width : 420,
                  ),
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            _currentPage == 3 ? 'GET STARTED' : 'NEXT',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Slide 1: Welcome - Friendly robot entering classroom
class _Slide1Welcome extends StatelessWidget {
  final AnimationController animation;

  const _Slide1Welcome({required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final isSmallScreen = maxWidth < 400 || maxHeight < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: maxWidth * 0.08,
                vertical: maxHeight * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: maxHeight * 0.02),
                  // Custom Robot Illustration
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          math.sin(animation.value * 2 * math.pi) * 10,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxWidth * 0.8,
                            maxHeight: maxHeight * 0.4,
                          ),
                          child: _RobotIllustration(
                            waveAnimation: animation.value,
                            size: isSmallScreen ? 200 : 280,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  Text(
                    'Welcome to RoboCleaner',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                    child: Text(
                      'Your intelligent classroom cleaning assistant with autonomous navigation and smart waste disposal',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 13 : 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Slide 2: Smart Cleaning Automation
class _Slide2SmartCleaning extends StatelessWidget {
  final AnimationController animation;

  const _Slide2SmartCleaning({required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final isSmallScreen = maxWidth < 400 || maxHeight < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: maxWidth * 0.08,
                vertical: maxHeight * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: maxHeight * 0.02),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth * 0.85,
                          maxHeight: maxHeight * 0.4,
                        ),
                        child: _CleaningIllustration(
                          progress: animation.value,
                          size: isSmallScreen ? 240 : 300,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  Text(
                    'Smart Cleaning Automation',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                    child: Text(
                      'Follows optimized paths, collects waste efficiently, and adapts to classroom layouts with intelligent sensors',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 13 : 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Slide 3: Real-Time Updates
class _Slide3RealTimeUpdates extends StatelessWidget {
  final AnimationController animation;

  const _Slide3RealTimeUpdates({required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final isSmallScreen = maxWidth < 400 || maxHeight < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: maxWidth * 0.08,
                vertical: maxHeight * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: maxHeight * 0.02),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth * 0.85,
                          maxHeight: maxHeight * 0.45,
                        ),
                        child: _NotificationIllustration(
                          pulse: animation.value,
                          size: isSmallScreen ? 240 : 300,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  Text(
                    'Real-Time Updates',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                    child: Text(
                      'Get instant notifications about cleaning status, trash levels, battery life, and maintenance alerts',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 13 : 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Slide 4: Enable Permissions
class _Slide4Permissions extends StatelessWidget {
  final AnimationController animation;

  const _Slide4Permissions({required this.animation});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final isSmallScreen = maxWidth < 400 || maxHeight < 600;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: maxWidth * 0.08,
                vertical: maxHeight * 0.04,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: maxHeight * 0.02),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth * 0.85,
                          maxHeight: maxHeight * 0.45,
                        ),
                        child: _PermissionsIllustration(
                          glow: animation.value,
                          size: isSmallScreen ? 240 : 300,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  Text(
                    'Enable Permissions',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                    child: Text(
                      'Allow WiFi, Bluetooth, and notifications to seamlessly control your RoboCleaner and receive updates',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 13 : 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Robot Illustration with waving gesture
class _RobotIllustration extends StatelessWidget {
  final double waveAnimation;
  final double size;

  const _RobotIllustration({required this.waveAnimation, this.size = 280});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = size / 280;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Classroom background
          Positioned(
            bottom: 0,
            child: Container(
              width: 260 * scaleFactor,
              height: 120 * scaleFactor,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16 * scaleFactor),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ClassroomItem(Icons.chair_outlined, 0.4, scaleFactor),
                  _ClassroomItem(Icons.desk_outlined, 0.5, scaleFactor),
                  _ClassroomItem(Icons.chair_outlined, 0.3, scaleFactor),
                ],
              ),
            ),
          ),
          // Robot body
          Positioned(
            bottom: 90 * scaleFactor,
            child: Column(
              children: [
                // Waving arm
                Transform.rotate(
                  angle: math.sin(waveAnimation * 2 * math.pi) * 0.3,
                  child: Container(
                    width: 8 * scaleFactor,
                    height: 40 * scaleFactor,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
                      ),
                      borderRadius: BorderRadius.circular(4 * scaleFactor),
                    ),
                  ),
                ),
                SizedBox(height: 4 * scaleFactor),
                // Head
                Container(
                  width: 70 * scaleFactor,
                  height: 70 * scaleFactor,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16 * scaleFactor),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.5),
                        blurRadius: 20 * scaleFactor,
                        spreadRadius: 5 * scaleFactor,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 40 * scaleFactor,
                  ),
                ),
                SizedBox(height: 8 * scaleFactor),
                // Body
                Container(
                  width: 80 * scaleFactor,
                  height: 60 * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(height: 4 * scaleFactor),
                // Wheels
                Row(
                  children: [
                    _Wheel(scaleFactor),
                    SizedBox(width: 40 * scaleFactor),
                    _Wheel(scaleFactor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Cleaning Illustration with motion trails
class _CleaningIllustration extends StatelessWidget {
  final double progress;
  final double size;

  const _CleaningIllustration({required this.progress, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.93,
      child: Stack(
        children: [
          // Floor with cleaning path
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(painter: _PathPainter(progress: progress)),
            ),
          ),
          // Moving robot
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: 20 + (progress * 200),
            bottom: 100,
            child: _MiniRobot(),
          ),
          // Trash collection
          Positioned(
            right: 40,
            bottom: 140,
            child: _TrashIndicator(filled: progress > 0.7),
          ),
          // Sensor waves
          Positioned(
            left: 40 + (progress * 200),
            bottom: 140,
            child: _SensorWaves(progress: progress),
          ),
        ],
      ),
    );
  }
}

// Notification Illustration
class _NotificationIllustration extends StatelessWidget {
  final double pulse;
  final double size;

  const _NotificationIllustration({required this.pulse, this.size = 300});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = size / 300;
    final phoneWidth = 160.0 * scaleFactor;
    final phoneHeight = (size * 0.85).clamp(200.0, 280.0);

    return SizedBox(
      width: size,
      height: size * 0.93,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone mockup with flexible height
          Positioned(
            top: 10 * scaleFactor,
            child: Container(
              width: phoneWidth,
              height: phoneHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24 * scaleFactor),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12 * scaleFactor),
                  Container(
                    width: 50 * scaleFactor,
                    height: 4 * scaleFactor,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _NotificationCard(
                            icon: Icons.check_circle_outline,
                            title: 'Cleaning Complete',
                            subtitle: 'Classroom A',
                            pulse: pulse,
                            scale: scaleFactor,
                          ),
                          SizedBox(height: 8 * scaleFactor),
                          _NotificationCard(
                            icon: Icons.delete_outline,
                            title: 'Trash Full',
                            subtitle: '85% capacity',
                            pulse: pulse * 0.8,
                            scale: scaleFactor,
                          ),
                          SizedBox(height: 8 * scaleFactor),
                          _NotificationCard(
                            icon: Icons.battery_charging_full,
                            title: 'Battery Status',
                            subtitle: '92% charged',
                            pulse: pulse * 0.6,
                            scale: scaleFactor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Robot with signal waves
          Positioned(
            bottom: 5,
            left: 15 * scaleFactor,
            child: Column(
              children: [
                _SignalWaves(pulse: pulse, scale: scaleFactor),
                SizedBox(height: 5 * scaleFactor),
                _MiniRobot(scaleFactor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Permissions Illustration
class _PermissionsIllustration extends StatelessWidget {
  final double glow;
  final double size;

  const _PermissionsIllustration({required this.glow, this.size = 300});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = size / 300;
    final glowIntensity = (math.sin(glow * 2 * math.pi) + 1) / 2;
    final phoneWidth = 160.0 * scaleFactor;
    final phoneHeight = (size * 0.85).clamp(200.0, 280.0);

    return SizedBox(
      width: size,
      height: size * 0.93,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone with flexible height
          Positioned(
            top: 10 * scaleFactor,
            child: Container(
              width: phoneWidth,
              height: phoneHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24 * scaleFactor),
                border: Border.all(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PermissionIcon(
                    icon: Icons.wifi,
                    label: 'WiFi',
                    glow: glowIntensity,
                    scale: scaleFactor,
                  ),
                  SizedBox(height: 18 * scaleFactor),
                  _PermissionIcon(
                    icon: Icons.bluetooth,
                    label: 'Bluetooth',
                    glow: glowIntensity * 0.8,
                    scale: scaleFactor,
                  ),
                  SizedBox(height: 18 * scaleFactor),
                  _PermissionIcon(
                    icon: Icons.notifications_active,
                    label: 'Notifications',
                    glow: glowIntensity * 0.6,
                    scale: scaleFactor,
                  ),
                ],
              ),
            ),
          ),
          // Robot giving thumbs up
          Positioned(
            bottom: 5,
            right: 20 * scaleFactor,
            child: Column(
              children: [
                Container(
                  width: 50 * scaleFactor,
                  height: 50 * scaleFactor,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
                    ),
                    borderRadius: BorderRadius.circular(10 * scaleFactor),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.4),
                        blurRadius: 12 * scaleFactor,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.thumb_up_outlined,
                    color: Colors.white,
                    size: 28 * scaleFactor,
                  ),
                ),
                SizedBox(height: 6 * scaleFactor),
                Container(
                  width: 50 * scaleFactor,
                  height: 35 * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6 * scaleFactor),
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

// Helper Widgets
class _Wheel extends StatelessWidget {
  final double scale;

  const _Wheel([this.scale = 1.0]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16 * scale,
      height: 16 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0EA5E9),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
      ),
    );
  }
}

class _ClassroomItem extends StatelessWidget {
  final IconData icon;
  final double opacity;
  final double scale;

  const _ClassroomItem(this.icon, this.opacity, [this.scale = 1.0]);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white.withValues(alpha: opacity),
      size: 32 * scale,
    );
  }
}

class _MiniRobot extends StatelessWidget {
  final double scale;

  const _MiniRobot([this.scale = 1.0]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
    );
  }
}

class _PathPainter extends CustomPainter {
  final double progress;

  _PathPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(10, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PathPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _TrashIndicator extends StatelessWidget {
  final bool filled;

  const _TrashIndicator({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: filled
            ? const Color(0xFF22C55E).withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: filled
              ? const Color(0xFF22C55E)
              : Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.delete_outline,
        color: filled ? const Color(0xFF22C55E) : Colors.white.withValues(alpha: 0.5),
        size: 24,
      ),
    );
  }
}

class _SensorWaves extends StatelessWidget {
  final double progress;

  const _SensorWaves({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            Opacity(
              opacity: 1 - (i * 0.3),
              child: Container(
                width: 20.0 + (i * 15 * progress),
                height: 20.0 + (i * 15 * progress),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF38BDF8), width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double pulse;
  final double scale;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.pulse,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7 + (math.sin(pulse * 2 * math.pi) * 0.3),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10 * scale),
        padding: EdgeInsets.all(10 * scale),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(
            color: const Color(0xFF22C55E).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6 * scale),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6 * scale),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF22C55E),
                size: 18 * scale,
              ),
            ),
            SizedBox(width: 10 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 9 * scale,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalWaves extends StatelessWidget {
  final double pulse;
  final double scale;

  const _SignalWaves({required this.pulse, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60 * scale,
      height: 60 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < 3; i++)
            Opacity(
              opacity:
                  (1 - (i * 0.3)) *
                  (0.5 + math.sin(pulse * 2 * math.pi + i) * 0.5),
              child: Container(
                width: (20.0 + (i * 15)) * scale,
                height: (20.0 + (i * 15)) * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0EA5E9), width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PermissionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final double glow;
  final double scale;

  const _PermissionIcon({
    required this.icon,
    required this.label,
    required this.glow,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50 * scale,
          height: 50 * scale,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF22C55E)],
            ),
            borderRadius: BorderRadius.circular(12 * scale),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withValues(alpha: 0.3 + glow * 0.4),
                blurRadius: (12 + glow * 8) * scale,
                spreadRadius: 2 * scale,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 26 * scale),
        ),
        SizedBox(height: 6 * scale),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 10 * scale,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
