import 'dart:async';

import 'package:flutter/material.dart';
import 'package:irctc_ui/authentication/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen>
    with TickerProviderStateMixin {
  final TextEditingController identityController =
      TextEditingController();

  final TextEditingController otpController =
      TextEditingController();

  late AnimationController _trainController;
  late AnimationController _fadeController;

  bool isLoading = false;
  bool otpSent = false;
  bool isMobile = true;

  int resendSeconds = 30;
  Timer? resendTimer;

  final String demoOtp = '123456';

  @override
  void initState() {
    super.initState();

    _trainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    identityController.dispose();
    otpController.dispose();

    _trainController.dispose();
    _fadeController.dispose();
    resendTimer?.cancel();

    super.dispose();
  }

  Future<bool> checkAccount() async {
    final prefs = await SharedPreferences.getInstance();

    final registered =
        prefs.getBool('is_registered') ?? false;

    if (!registered) {
      return false;
    }

    final savedMobile =
        prefs.getString('user_mobile') ?? '';

    final savedEmail =
        prefs.getString('user_email') ?? '';

    final entered =
        identityController.text.trim();

    if (isMobile) {
      return savedMobile == entered;
    }

    return savedEmail.toLowerCase() ==
        entered.toLowerCase();
  }

  Future<void> sendOtp() async {
    final value = identityController.text.trim();

    if (isMobile) {
      if (!RegExp(
        r'^[6-9][0-9]{9}$',
      ).hasMatch(value)) {
        showMessage(
          'Enter a valid 10-digit mobile number.',
          isError: true,
        );
        return;
      }
    } else {
      if (!RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(value)) {
        showMessage(
          'Enter a valid email address.',
          isError: true,
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    final accountExists = await checkAccount();

    if (!mounted) return;

    if (!accountExists) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Account not found. Please check your details.',
        isError: true,
      );

      return;
    }

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      otpSent = true;
      resendSeconds = 30;
    });

    startTimer();

    showMessage(
      'Demo OTP sent successfully: 123456',
    );
  }

  void startTimer() {
    resendTimer?.cancel();

    resendTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (resendSeconds <= 1) {
          timer.cancel();

          setState(() {
            resendSeconds = 0;
          });
        } else {
          setState(() {
            resendSeconds--;
          });
        }
      },
    );
  }

  void resendOtp() {
    if (resendSeconds != 0) return;

    setState(() {
      resendSeconds = 30;
    });

    startTimer();

    showMessage(
      'New demo OTP: 123456',
    );
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim() != demoOtp) {
      showMessage(
        'Incorrect OTP.',
        isError: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    _showNewPinDialog();
  }

  Future<void> _showNewPinDialog() async {
    String newPin = '';
    String confirmPin = '';
    bool confirmStage = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String currentPin =
                confirmStage ? confirmPin : newPin;

            void addDigit(String digit) {
              if (currentPin.length >= 4) return;

              setDialogState(() {
                if (confirmStage) {
                  confirmPin += digit;
                } else {
                  newPin += digit;
                }
              });
            }

            void deleteDigit() {
              if (currentPin.isEmpty) return;

              setDialogState(() {
                if (confirmStage) {
                  confirmPin =
                      confirmPin.substring(
                    0,
                    confirmPin.length - 1,
                  );
                } else {
                  newPin =
                      newPin.substring(
                    0,
                    newPin.length - 1,
                  );
                }
              });
            }

            Future<void> completePin() async {
              if (currentPin.length != 4) return;

              if (!confirmStage) {
                setDialogState(() {
                  confirmStage = true;
                });
                return;
              }

              if (newPin != confirmPin) {
                setDialogState(() {
                  confirmPin = '';
                });

                showMessage(
                  'PIN does not match.',
                  isError: true,
                );

                return;
              }

              final prefs =
                  await SharedPreferences.getInstance();

              await prefs.setString(
                'user_pin',
                newPin,
              );

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);

              _showSuccess();
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF111111),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: Text(
                confirmStage
                    ? 'Confirm New PIN'
                    : 'Create New PIN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    confirmStage
                        ? 'Enter your new PIN again'
                        : 'Create a new 4-digit PIN',
                    style: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < currentPin.length
                              ? Colors.white
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 270,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      children: [
                        for (final digit in [
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '',
                          '0',
                          '⌫',
                        ])
                          GestureDetector(
                            onTap: digit.isEmpty
                                ? null
                                : () async {
                                    if (digit == '⌫') {
                                      deleteDigit();
                                    } else {
                                      addDigit(digit);
                                    }

                                    final updatedPin =
                                        confirmStage
                                            ? confirmPin
                                            : newPin;

                                    if (updatedPin.length ==
                                        4) {
                                      await Future.delayed(
                                        const Duration(
                                          milliseconds: 200,
                                        ),
                                      );

                                      if (dialogContext
                                          .mounted) {
                                        await completePin();
                                      }
                                    }
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: digit.isEmpty
                                    ? Colors.transparent
                                    : Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                borderRadius:
                                    BorderRadius.circular(15),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  digit,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 68,
              ),
              SizedBox(height: 14),
              Text(
                'PIN Updated',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your new PIN has been saved successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget methodButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: otpSent ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.black
                    : Colors.white70,
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.black
                      : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _trainController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ForgotPinRailwayPainter(
                    progress: _trainController.value,
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
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  22,
                  18,
                  22,
                  30,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Forgot PIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(
                          alpha: 0.08,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.18,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 17),

                    const Text(
                      'Reset Your PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Verify your account to create a new PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: 0.06,
                        ),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          methodButton(
                            title: 'Mobile',
                            icon:
                                Icons.phone_android_rounded,
                            selected: isMobile,
                            onTap: () {
                              setState(() {
                                isMobile = true;
                                identityController.clear();
                              });
                            },
                          ),
                          const SizedBox(width: 6),
                          methodButton(
                            title: 'Email',
                            icon: Icons.email_outlined,
                            selected: !isMobile,
                            onTap: () {
                              setState(() {
                                isMobile = false;
                                identityController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: identityController,
                      enabled: !otpSent,
                      keyboardType: isMobile
                          ? TextInputType.phone
                          : TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: isMobile
                            ? 'Registered mobile number'
                            : 'Registered email address',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                        ),
                        prefixIcon: Icon(
                          isMobile
                              ? Icons.phone_android_rounded
                              : Icons.email_outlined,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(
                          alpha: 0.07,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    if (!otpSent)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),

                    if (otpSent) ...[
                      Container(
                        width: double.infinity,
                        margin:
                            const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius:
                              BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.green.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'OTP verification required',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextField(
                        controller: otpController,
                        keyboardType:
                            TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••••',
                          hintStyle: const TextStyle(
                            color: Colors.white24,
                            letterSpacing: 8,
                          ),
                          filled: true,
                          fillColor:
                              Colors.white.withValues(
                            alpha: 0.07,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Demo OTP: 123456',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Verify & Reset PIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            resendSeconds == 0
                                ? 'Didn\'t receive OTP?'
                                : 'Resend in $resendSeconds s',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                          if (resendSeconds == 0) ...[
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: resendOtp,
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 15,
                          color: Colors.white.withValues(
                            alpha: 0.55,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Secure PIN recovery',
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: 0.55,
                            ),
                            fontSize: 11.5,
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
                color: Colors.black.withValues(
                  alpha: 0.15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ForgotPinRailwayPainter extends CustomPainter {
  final double progress;

  ForgotPinRailwayPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = const Color(0xFF05070D);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );

    paint.color = const Color(0xFF202938);

    canvas.drawCircle(
      Offset(
        size.width * 0.82,
        size.height * 0.12,
      ),
      43,
      paint,
    );

    paint.color = Colors.white.withValues(
      alpha: 0.7,
    );

    for (int i = 0; i < 32; i++) {
      final x = (i * 73.0) % size.width;
      final y = (i * 119.0) % (size.height * 0.44);

      canvas.drawCircle(
        Offset(x, y),
        1.1,
        paint,
      );
    }

    final trainX =
        -190 + (size.width + 380) * progress;

    paint.color = const Color(0xFF151515);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          trainX,
          size.height * 0.54,
          180,
          58,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    paint.color = Colors.white.withValues(
      alpha: 0.60,
    );

    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            trainX + 14 + (i * 38),
            size.height * 0.565,
            24,
            15,
          ),
          const Radius.circular(3),
        ),
        paint,
      );
    }

    paint.color = Colors.white.withValues(
      alpha: 0.90,
    );

    canvas.drawCircle(
      Offset(
        trainX + 166,
        size.height * 0.61,
      ),
      7,
      paint,
    );

    paint.color = const Color(0xFF292929);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * 0.67,
        size.width,
        6,
      ),
      paint,
    );

    paint.color = const Color(0xFF343434);

    for (int i = -1; i < 18; i++) {
      final x = i * 52.0;

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * 0.71,
          34,
          7,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant ForgotPinRailwayPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}