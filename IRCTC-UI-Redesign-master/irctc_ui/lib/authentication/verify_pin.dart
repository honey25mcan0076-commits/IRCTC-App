import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:irctc_ui/homescreen/homepage.dart';

class VerifyPinScreen extends StatefulWidget {
  const VerifyPinScreen({super.key});

  @override
  State<VerifyPinScreen> createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen>
    with TickerProviderStateMixin {
  final TextEditingController pinController = TextEditingController();

  late AnimationController trainController;
  late AnimationController fadeController;
  late AnimationController pulseController;

  String enteredPin = '';
  bool isCreatingPin = true;
  bool isLoading = false;
  bool isWrong = false;

  @override
  void initState() {
    super.initState();

    trainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    checkExistingPin();
  }

  Future<void> checkExistingPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('user_pin');

    if (!mounted) return;

    setState(() {
      isCreatingPin = savedPin == null || savedPin.isEmpty;
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    trainController.dispose();
    fadeController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD DIGIT
  // ============================================================

  Future<void> addDigit(String digit) async {
    if (isLoading || enteredPin.length >= 4) {
      return;
    }

    setState(() {
      enteredPin += digit;
      pinController.text = enteredPin;
      isWrong = false;
    });

    // ==========================================================
    // 4 DIGITS COMPLETED
    // ==========================================================

    if (enteredPin.length == 4) {
      final firstPin = enteredPin;

      // Small delay so last PIN dot is visible
      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      if (isCreatingPin) {
        // IMPORTANT:
        // Open confirmation PIN screen
        await confirmNewPin(firstPin);
      } else {
        await verifyPin();
      }
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  void deleteDigit() {
    if (isLoading || enteredPin.isEmpty) {
      return;
    }

    setState(() {
      enteredPin =
          enteredPin.substring(0, enteredPin.length - 1);

      pinController.text = enteredPin;
      isWrong = false;
    });
  }

  // ============================================================
  // CREATE + CONFIRM PIN
  // ============================================================

  Future<void> confirmNewPin(String firstPin) async {
    if (!mounted) return;

    // Clear main PIN screen
    setState(() {
      enteredPin = '';
      pinController.clear();
      isLoading = false;
    });

    String confirmPin = '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // ==================================================
            // ADD CONFIRMATION DIGIT
            // ==================================================

            Future<void> addConfirmDigit(String digit) async {
              if (confirmPin.length >= 4) {
                return;
              }

              setSheetState(() {
                confirmPin += digit;
              });

              if (confirmPin.length != 4) {
                return;
              }

              await Future.delayed(
                const Duration(milliseconds: 250),
              );

              if (!context.mounted) return;

              // =================================================
              // PIN MATCH
              // =================================================

              if (confirmPin == firstPin) {
                final prefs =
                    await SharedPreferences.getInstance();

                await prefs.setString(
                  'user_pin',
                  firstPin,
                );

                if (!context.mounted) return;

                Navigator.pop(sheetContext);

                // Show success message after sheet closes
                await Future.delayed(
                  const Duration(milliseconds: 150),
                );

                if (!mounted) return;

                showSuccess();
              }

              // =================================================
              // PIN DOES NOT MATCH
              // =================================================

              else {
                setSheetState(() {
                  confirmPin = '';
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'PIN does not match. Please try again.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }

            // ==================================================
            // DELETE CONFIRMATION DIGIT
            // ==================================================

            void deleteConfirmDigit() {
              if (confirmPin.isEmpty) {
                return;
              }

              setSheetState(() {
                confirmPin = confirmPin.substring(
                  0,
                  confirmPin.length - 1,
                );
              });
            }

            // ==================================================
            // CONFIRMATION UI
            // ==================================================

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  14,
                  22,
                  22,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D121A),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF2475EE),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius:
                            BorderRadius.circular(5),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Icon
                    const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF63A0FF),
                      size: 34,
                    ),

                    const SizedBox(height: 10),

                    // Title
                    const Text(
                      'Confirm your PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Subtitle
                    const Text(
                      'Enter the same 4 digits once more',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PIN DOTS
                    buildPinDots(confirmPin),

                    const SizedBox(height: 22),

                    // KEYPAD
                    buildKeypad(
                      onDigit: addConfirmDigit,
                      onDelete: deleteConfirmDigit,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // VERIFY EXISTING PIN
  // ============================================================

  Future<void> verifyPin() async {
    final prefs =
        await SharedPreferences.getInstance();

    final savedPin =
        prefs.getString('user_pin');

    if (savedPin == enteredPin) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(
        const Duration(milliseconds: 650),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        enteredPin = '';
        pinController.clear();
        isWrong = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect PIN. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  void showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF101721),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              22,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent
                        .withValues(alpha: .10),
                    border: Border.all(
                      color: Colors.greenAccent
                          .withValues(alpha: .35),
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.greenAccent,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'PIN Created Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your account is now protected with a secure 4-digit PIN.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2475EE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Continue to Home',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PIN DOTS
  // ============================================================

  Widget buildPinDots(String pin) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) {
          final filled =
              index < pin.length;

          return AnimatedContainer(
            duration:
                const Duration(milliseconds: 160),
            margin:
                const EdgeInsets.symmetric(
              horizontal: 7,
            ),
            width: filled ? 18 : 15,
            height: filled ? 18 : 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? const Color(0xFF63A0FF)
                  : Colors.white12,
              border: Border.all(
                color: filled
                    ? const Color(0xFF63A0FF)
                    : Colors.white24,
              ),
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: const Color(
                          0xFF2475EE,
                        ).withValues(alpha: .45),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // KEYPAD
  // ============================================================

  Widget buildKeypad({
    required Future<void> Function(String)
        onDigit,
    required VoidCallback onDelete,
  }) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '•',
      '0',
      '⌫',
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      physics:
          const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (_, index) {
        final key = keys[index];

        if (key == '•') {
          return const SizedBox();
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: key == '⌫'
                ? onDelete
                : () => onDigit(key),
            borderRadius:
                BorderRadius.circular(17),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: .055),
                borderRadius:
                    BorderRadius.circular(17),
                border: Border.all(
                  color: Colors.white
                      .withValues(alpha: .09),
                ),
              ),
              child: Center(
                child: Text(
                  key,
                  style: TextStyle(
                    color: key == '⌫'
                        ? Colors.white60
                        : Colors.white,
                    fontSize:
                        key == '⌫' ? 22 : 23,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // MAIN UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF030509),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: trainController,
              builder: (_, __) {
                return CustomPaint(
                  painter: RailwayPainter(
                    progress:
                        trainController.value,
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black
                        .withValues(alpha: .30),
                    const Color(0xFF030509)
                        .withValues(alpha: .94),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: fadeController,
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(
                  24,
                  30,
                  24,
                  22,
                ),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: pulseController,
                      builder: (_, __) {
                        return Container(
                          padding:
                              const EdgeInsets.all(
                            15,
                          ),
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color: const Color(
                              0xFF2475EE,
                            ).withValues(
                              alpha: .08 +
                                  pulseController
                                          .value *
                                      .04,
                            ),
                            border: Border.all(
                              color: const Color(
                                0xFF4C92FF,
                              ).withValues(
                                alpha: .28,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2475EE,
                                ).withValues(
                                  alpha: .10 +
                                      pulseController
                                              .value *
                                          .08,
                                ),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            color:
                                Color(0xFF63A0FF),
                            size: 31,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 17),

                    Text(
                      isCreatingPin
                          ? 'Create Your PIN'
                          : 'Welcome Back',
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      isCreatingPin
                          ? 'Create a secure PIN for faster login'
                          : 'Enter your 4-digit security PIN',
                      style:
                          const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 19,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: .035,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                        border: Border.all(
                          color: Colors.white
                              .withValues(
                            alpha: .07,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          buildPinDots(
                            enteredPin,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            isWrong
                                ? 'Incorrect PIN — try again'
                                : isCreatingPin
                                    ? 'Enter 4 digits'
                                    : 'Your PIN is private & secure',
                            style: TextStyle(
                              color: isWrong
                                  ? Colors.redAccent
                                  : Colors.white38,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    buildKeypad(
                      onDigit: addDigit,
                      onDelete: deleteDigit,
                    ),

                    const SizedBox(height: 18),

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color:
                              Colors.greenAccent,
                          size: 15,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Secure railway account access',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black
                    .withValues(alpha: .72),
                child: const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        Color(0xFF63A0FF),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// RAILWAY BACKGROUND
// ============================================================

class RailwayPainter extends CustomPainter {
  final double progress;

  RailwayPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final bg = Paint()
      ..color =
          const Color(0xFF050A12);

    canvas.drawRect(
      Offset.zero & size,
      bg,
    );

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2475EE)
              .withValues(alpha: .18),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * .55,
            size.height * .25,
          ),
          radius: size.width * .75,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * .55,
        size.height * .25,
      ),
      size.width * .75,
      glow,
    );

    final stars = Paint()
      ..color =
          Colors.white.withValues(alpha: .35);

    for (int i = 0; i < 38; i++) {
      final x =
          (i * 83.0) % size.width;
      final y =
          (i * 47.0) %
              (size.height * .55);

      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 1.2 : .7,
        stars,
      );
    }

    final track = Paint()
      ..color = const Color(0xFF2475EE)
          .withValues(alpha: .18)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(
        0,
        size.height * .78,
      ),
      Offset(
        size.width,
        size.height * .64,
      ),
      track,
    );

    canvas.drawLine(
      Offset(
        0,
        size.height * .86,
      ),
      Offset(
        size.width,
        size.height * .72,
      ),
      track,
    );

    final trainX =
        -150 +
            (size.width + 300) *
                progress;

    final trainY =
        size.height * .72 -
            progress *
                size.height *
                .08;

    final train = Paint()
      ..color =
          const Color(0xFF182A45);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          trainX,
          trainY,
          125,
          38,
        ),
        const Radius.circular(8),
      ),
      train,
    );

    final window = Paint()
      ..color = const Color(0xFF63A0FF)
          .withValues(alpha: .75);

    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            trainX +
                13 +
                i * 26,
            trainY + 8,
            17,
            11,
          ),
          const Radius.circular(2),
        ),
        window,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant RailwayPainter oldDelegate,
  ) {
    return oldDelegate.progress !=
        progress;
  }
}