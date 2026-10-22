import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:irctc_ui/authentication/register_screen.dart';
import 'package:irctc_ui/authentication/verify_pin.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late AnimationController _trainController;
  late AnimationController _routeController;
  late AnimationController _glowController;
  late AnimationController _particleController;

  Offset _fingerOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    _trainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _trainController.dispose();
    _routeController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _updateFinger(Offset position, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final dx = ((position.dx - center.dx) / center.dx)
        .clamp(-1.0, 1.0)
        .toDouble();

    final dy = ((position.dy - center.dy) / center.dy)
        .clamp(-1.0, 1.0)
        .toDouble();

    setState(() {
      _fingerOffset = Offset(dx, dy);
    });
  }

  void _resetFinger() {
    setState(() {
      _fingerOffset = Offset.zero;
    });
  }

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VerifyPinScreen(),
      ),
    );
  }

  void _openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          _updateFinger(details.localPosition, size);
        },
        onPanEnd: (_) => _resetFinger(),
        onPanCancel: _resetFinger,
        child: Stack(
          children: [
            // ============================================================
            // BACKGROUND
            // ============================================================
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _trainController,
                  _glowController,
                ]),
                builder: (context, child) {
                  final moveX = _fingerOffset.dx * 10;
                  final moveY = _fingerOffset.dy * 8;

                  return Transform.translate(
                    offset: Offset(moveX, moveY),
                    child: Transform.scale(
                      scale: 1.04,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF071829),
                              Color(0xFF04101D),
                              Color(0xFF02070D),
                              Color(0xFF010305),
                            ],
                          ),
                        ),
                        child: CustomPaint(
                          painter: BackgroundTrainPainter(
                            progress: _trainController.value,
                            fingerOffset: _fingerOffset,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ============================================================
            // DARK GRADIENT
            // ============================================================
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.32),
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.82),
                      Colors.black.withValues(alpha: 0.98),
                    ],
                    stops: const [
                      0.0,
                      0.28,
                      0.48,
                      0.76,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),

            // ============================================================
            // BLUE LIGHT EFFECT
            // ============================================================
            Positioned(
              left: -100 + (_fingerOffset.dx * 20),
              bottom: -70 + (_fingerOffset.dy * 15),
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  final opacity =
                      0.18 + (_glowController.value * 0.12);

                  return Container(
                    width: 330,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(
                            alpha: opacity,
                          ),
                          blurRadius: 90,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ============================================================
            // MAIN CONTENT
            // ============================================================
            SafeArea(
              child: Column(
                children: [
                  // ======================================================
                  // TOP LOGO
                  // ======================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      22,
                      18,
                      22,
                      0,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'sf/img/irctc_w.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.train,
                              color: Colors.white,
                              size: 38,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ======================================================
                  // FLEXIBLE CONTENT
                  // ======================================================
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 55),

                            // ==================================================
                            // ROUTE
                            // ==================================================
                            SizedBox(
                              height: 88,
                              child: AnimatedBuilder(
                                animation: _routeController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: RoutePainter(
                                      progress: _routeController.value,
                                      fingerOffset: _fingerOffset,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _locationPoint(
                                          icon: Icons.location_on,
                                          title: 'From',
                                          place: '',
                                        ),
                                        const SizedBox(width: 100),
                                        _locationPoint(
                                          icon: Icons.location_on,
                                          title: 'To',
                                          place: '',
                                          alignRight: true,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // TITLE
                            // ==================================================
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Your journey\nstarts ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      height: 1.05,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'here.',
                                    style: TextStyle(
                                      color: Color(0xFF129BFF),
                                      fontSize: 40,
                                      height: 1.05,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Next Generation eTicketing System',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ==================================================
                            // BOOK / TRAVEL / EXPLORE
                            // ==================================================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                _featureCard(
                                  icon: Icons.confirmation_num_outlined,
                                  title: 'BOOK',
                                ),
                                _featureCard(
                                  icon: Icons.train_outlined,
                                  title: 'TRAVEL',
                                ),
                                _featureCard(
                                  icon: Icons.explore_outlined,
                                  title: 'EXPLORE',
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // ==================================================
                            // LOGIN BUTTON
                            // ==================================================
                            AnimatedBuilder(
                              animation: _glowController,
                              builder: (context, child) {
                                final glow =
                                    0.25 + (_glowController.value * 0.20);

                                return Container(
                                  width: double.infinity,
                                  height: 66,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(34),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent
                                            .withValues(alpha: glow),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(34),
                                      onTap: _openLogin,
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(34),
                                          gradient:
                                              const LinearGradient(
                                            colors: [
                                              Color(0xFF178BFF),
                                              Color(0xFF0967FF),
                                              Color(0xFF168DFF),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: Colors.lightBlueAccent
                                                .withValues(alpha: 0.7),
                                            width: 1.3,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Colors.white24,
                                              child: Icon(
                                                Icons.login,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ),
                                            SizedBox(width: 14),
                                            Text(
                                              'Login with IRCTC account',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // ==================================================
                            // REGISTER OPTION
                            // ==================================================
                            GestureDetector(
                              onTap: _openRegister,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Don't have an account yet? ",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Register Now',
                                        style: TextStyle(
                                          color: Color(0xFF36A9FF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor:
                                              Color(0xFF36A9FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ==================================================
                            // SECURITY
                            // ==================================================
                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  color: Colors.white70,
                                  size: 19,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Secure & protected login',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ==================================================
                            // QUICK ACTIONS
                            // ==================================================
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _quickAction(
                                  Icons.search,
                                  'PNR\nStatus',
                                ),
                                _quickAction(
                                  Icons.access_time,
                                  'Train\nSchedule',
                                ),
                                _quickAction(
                                  Icons.radar,
                                  'Live\nTracking',
                                ),
                                _quickAction(
                                  Icons.train,
                                  'Platform\nInfo',
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Swipe up for more',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // FLOATING PARTICLES
            // ============================================================
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ParticlePainter(
                        progress: _particleController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // LOCATION WIDGET
  // ======================================================================

  Widget _locationPoint({
    required IconData icon,
    required String title,
    required String place,
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF139BFF),
          size: 44,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF32AEFF),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          place,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  // ======================================================================
  // FEATURE CARD
  // ======================================================================

  Widget _featureCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      width: 105,
      height: 112,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.blueAccent.withValues(alpha: 0.28),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withValues(alpha: 0.12),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF55B8FF),
            size: 38,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  // QUICK ACTION
  // ======================================================================

  Widget _quickAction(
    IconData icon,
    String title,
  ) {
    return SizedBox(
      width: 78,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.45),
              border: Border.all(
                color: Colors.blueAccent.withValues(alpha: 0.5),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.18),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: const Color(0xFF35AFFF),
              size: 28,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// BACKGROUND TRAIN PAINTER
// ==========================================================================

class BackgroundTrainPainter extends CustomPainter {
  final double progress;
  final Offset fingerOffset;

  BackgroundTrainPainter({
    required this.progress,
    required this.fingerOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Horizon glow
    final horizonPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Color(0x44228CFF),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * 0.42,
          size.width,
          size.height * 0.25,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * 0.40,
        size.width,
        size.height * 0.28,
      ),
      horizonPaint,
    );

    // Railway tracks
    final trackPaint = Paint()
      ..color = const Color(0x553DAAFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;

    final leftTrack = Path()
      ..moveTo(centerX - 25, size.height)
      ..lineTo(centerX - 4, size.height * 0.56);

    final rightTrack = Path()
      ..moveTo(centerX + 25, size.height)
      ..lineTo(centerX + 4, size.height * 0.56);

    canvas.drawPath(leftTrack, trackPaint);
    canvas.drawPath(rightTrack, trackPaint);

    // Sleepers
    final sleeperPaint = Paint()
      ..color = const Color(0x443C91D8)
      ..strokeWidth = 2;

    for (int i = 0; i < 11; i++) {
      final t = i / 10;

      final y =
          size.height * 0.58 +
          (math.pow(t, 1.7) * size.height * 0.42);

      final width =
          15 + (t * size.width * 0.22);

      canvas.drawLine(
        Offset(centerX - width, y),
        Offset(centerX + width, y),
        sleeperPaint,
      );
    }

    // Distant train
    final trainX =
        centerX +
        math.sin(progress * math.pi * 2) * 10 +
        fingerOffset.dx * 8;

    final trainY = size.height * 0.50;

    // Train glow
    final glowPaint = Paint()
      ..color = const Color(0x55219CFF)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        35,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(trainX, trainY + 20),
        width: 150,
        height: 65,
      ),
      glowPaint,
    );

    // Train body
    final bodyPaint = Paint()
      ..color = const Color(0xFF102D48);

    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(trainX, trainY),
        width: 125,
        height: 60,
      ),
      const Radius.circular(12),
    );

    canvas.drawRRect(body, bodyPaint);

    // Front glass
    final glassPaint = Paint()
      ..color = const Color(0xFF4BA9DE).withValues(alpha: 0.65);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(trainX, trainY - 7),
          width: 72,
          height: 24,
        ),
        const Radius.circular(5),
      ),
      glassPaint,
    );

    // Headlights
    final lightPaint = Paint()
      ..color = const Color(0xFFBDEBFF)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        5,
      );

    canvas.drawCircle(
      Offset(trainX - 40, trainY + 17),
      6,
      lightPaint,
    );

    canvas.drawCircle(
      Offset(trainX + 40, trainY + 17),
      6,
      lightPaint,
    );

    // City lights
    final cityPaint = Paint()
      ..color = const Color(0x332EA7FF);

    for (int i = 0; i < 18; i++) {
      final x =
          (i * 83.0) % size.width;

      final double h =
    20.0 + ((i * 17) % 75).toDouble();

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * 0.48 - h,
          20,
          h,
        ),
        cityPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundTrainPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fingerOffset != fingerOffset;
  }
}

// ==========================================================================
// ROUTE PAINTER
// ==========================================================================

class RoutePainter extends CustomPainter {
  final double progress;
  final Offset fingerOffset;

  RoutePainter({
    required this.progress,
    required this.fingerOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const start = Offset(30, 48);
    final end = Offset(size.width - 30, 48);

    final path = Path();

    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(
      size.width / 2,
      15,
      end.dx,
      end.dy,
    );

    final linePaint = Paint()
      ..color = const Color(0xFF0AA8FF).withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    // Start glow
    canvas.drawCircle(
      start,
      7,
      Paint()
        ..color = const Color(0xFF00B7FF)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          7,
        ),
    );

    // End glow
    canvas.drawCircle(
      end,
      7,
      Paint()
        ..color = const Color(0xFF00B7FF)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          7,
        ),
    );

    // Animated train position
    final t = progress;

    final x = start.dx + ((end.dx - start.dx) * t);

    final curveY =
        start.dy - (math.sin(t * math.pi) * 32);

    final trainCenter = Offset(
      x,
      curveY + (fingerOffset.dy * 2),
    );

    // Train glow
    canvas.drawOval(
      Rect.fromCenter(
        center: trainCenter,
        width: 66,
        height: 25,
      ),
      Paint()
        ..color = Colors.lightBlueAccent.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          9,
        ),
    );

    // Train body
    final trainPaint = Paint()
      ..color = const Color(0xFF36AFFF)
      ..style = PaintingStyle.fill;

    final trainRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: trainCenter,
        width: 48,
        height: 17,
      ),
      const Radius.circular(5),
    );

    canvas.drawRRect(
      trainRect,
      trainPaint,
    );

    // Train windows
    final windowPaint = Paint()
      ..color = const Color(0xFFBEEBFF);

    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(
              trainCenter.dx + i * 11,
              trainCenter.dy - 2,
            ),
            width: 7,
            height: 5,
          ),
          const Radius.circular(1),
        ),
        windowPaint,
      );
    }

    // Train wheels
    final wheelPaint = Paint()
      ..color = Colors.white70;

    canvas.drawCircle(
      Offset(
        trainCenter.dx - 13,
        trainCenter.dy + 8,
      ),
      3,
      wheelPaint,
    );

    canvas.drawCircle(
      Offset(
        trainCenter.dx + 13,
        trainCenter.dy + 8,
      ),
      3,
      wheelPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fingerOffset != fingerOffset;
  }
}

// ==========================================================================
// PARTICLE PAINTER
// ==========================================================================

class ParticlePainter extends CustomPainter {
  final double progress;

  ParticlePainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final random = math.Random(42);

    for (int i = 0; i < 24; i++) {
      final baseX =
          random.nextDouble() * size.width;

      final baseY =
          random.nextDouble() * size.height;

      final movement =
          math.sin(
            (progress * math.pi * 2) + i,
          ) *
          10;

      final x = baseX + movement;

      final y =
          baseY - (progress * 20);

      paint.color =
          Colors.lightBlueAccent.withValues(
        alpha:
            0.15 +
            (random.nextDouble() * 0.35),
      );

      canvas.drawCircle(
        Offset(
          x,
          y % size.height,
        ),
        1.2 +
            random.nextDouble() * 1.8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant ParticlePainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}