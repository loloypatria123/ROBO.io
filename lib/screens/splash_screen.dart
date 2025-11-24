import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robofinal/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _gridController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _waveProgress;
  late Animation<double> _gridFlicker;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    // Wave scan animation (0-1.2s) - bottom to top
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _waveProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Grid flicker animation (1.2-1.8s)
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _gridFlicker = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _gridController, curve: Curves.easeInOut),
    );

    // Logo fade and slide animation (1.8-2.7s)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    // Text fade animation (2.5-3.2s)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Start animations in sequence
    _waveController.forward();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _gridController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) _textController.forward();
    });

    // Navigate to welcome screen after 4.5 seconds with fade transition
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const WelcomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Fade transition
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _gridController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _waveController,
          _gridController,
          _logoController,
          _textController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF020617),
                  Color(0xFF0F172A),
                  Color(0xFF020617),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Wave Scan Effect (bottom to top)
                if (_waveProgress.value < 1.0)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WaveScanPainter(progress: _waveProgress.value),
                    ),
                  ),

                // Grid Flicker Effect
                if (_gridFlicker.value > 0 && _gridFlicker.value < 1.0)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GridFlickerPainter(opacity: _gridFlicker.value),
                    ),
                  ),

                // Main Content
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with fade and slide animation
                        SlideTransition(
                          position: _logoSlide,
                          child: FadeTransition(
                            opacity: _logoFade,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF22C55E),
                                    Color(0xFF0EA5E9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF22C55E,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // App Title with fade animation
                        FadeTransition(
                          opacity: _textFade,
                          child: Text(
                            'RoboCleaner',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subtitle with fade animation
                        FadeTransition(
                          opacity: _textFade,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Intelligent Classroom Cleaning',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Wave Scan Painter - creates a luminous line moving from bottom to top
class _WaveScanPainter extends CustomPainter {
  final double progress;

  _WaveScanPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate wave position from bottom to top
    final waveY = size.height * (1 - progress);

    // Create gradient for the wave line
    final wavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF22C55E).withValues(alpha: 0),
          const Color(0xFF22C55E).withValues(alpha: 0.8),
          const Color(0xFF0EA5E9).withValues(alpha: 0.6),
          const Color(0xFF22C55E).withValues(alpha: 0),
        ],
        stops: const [0.0, 0.4, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, waveY - 40, size.width, 80));

    // Draw the wave line with glow effect
    canvas.drawRect(
      Rect.fromLTWH(0, waveY - 2, size.width, 4),
      Paint()
        ..color = const Color(0xFF22C55E).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Draw the main wave line
    canvas.drawRect(
      Rect.fromLTWH(0, waveY - 1, size.width, 2),
      Paint()..color = const Color(0xFF22C55E),
    );

    // Draw the gradient wave effect
    canvas.drawRect(Rect.fromLTWH(0, waveY - 40, size.width, 80), wavePaint);
  }

  @override
  bool shouldRepaint(_WaveScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Grid Flicker Painter - creates a subtle data stream grid effect
class _GridFlickerPainter extends CustomPainter {
  final double opacity;

  _GridFlickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF0EA5E9).withValues(alpha: opacity * 0.15)
      ..strokeWidth = 1;

    final gridSize = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw random flickering dots for data stream effect
    final dotPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: opacity * 0.3);

    // Create a pseudo-random pattern based on opacity for flicker effect
    final seed = (opacity * 100).toInt();
    for (int i = 0; i < 15; i++) {
      final x = ((seed * (i + 1)) % size.width.toInt()).toDouble();
      final y = ((seed * (i + 7)) % size.height.toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_GridFlickerPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}
