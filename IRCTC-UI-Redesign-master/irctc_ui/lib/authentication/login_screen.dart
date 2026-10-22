import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:irctc_ui/authentication/forgot_pin.dart';
import 'package:irctc_ui/authentication/register_screen.dart';
import 'package:irctc_ui/authentication/verify_pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  late AnimationController _trainController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  bool isMobileLogin = true;
  bool otpSent = false;
  bool isLoading = false;

  int resendSeconds = 30;
  Timer? resendTimer;

  final String demoOtp = '123456';

  double fingerX = 0;
  double fingerY = 0;

  @override
  void initState() {
    super.initState();

    _trainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    otpController.dispose();

    _trainController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();

    resendTimer?.cancel();

    super.dispose();
  }

  // ============================================================
  // LOGIN LOGIC
  // ============================================================

  Future<bool> checkRegisteredAccount() async {
    final prefs = await SharedPreferences.getInstance();

    final isRegistered =
        prefs.getBool('is_registered') ?? false;

    if (!isRegistered) {
      return false;
    }

    final savedMobile =
        prefs.getString('user_mobile') ?? '';

    final savedEmail =
        prefs.getString('user_email') ?? '';

    if (isMobileLogin) {
      return savedMobile ==
          mobileController.text.trim();
    }

    return savedEmail.toLowerCase() ==
        emailController.text.trim().toLowerCase();
  }

  Future<void> sendOtp() async {
    if (isMobileLogin) {
      final mobile = mobileController.text.trim();

      if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(mobile)) {
        showMessage(
          'Please enter a valid 10-digit mobile number.',
          isError: true,
        );
        return;
      }
    } else {
      final email = emailController.text.trim();

      if (!RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(email)) {
        showMessage(
          'Please enter a valid email address.',
          isError: true,
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    final accountExists =
        await checkRegisteredAccount();

    if (!mounted) return;

    if (!accountExists) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Account not found. Please register first.',
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

    startResendTimer();

    showMessage(
      'Demo OTP sent successfully: 123456',
    );
  }

  void startResendTimer() {
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

    startResendTimer();

    showMessage(
      'New demo OTP: 123456',
    );
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      showMessage(
        'Please enter the 6-digit OTP.',
        isError: true,
      );
      return;
    }

    if (otp != demoOtp) {
      showMessage(
        'Incorrect OTP. Please try again.',
        isError: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const VerifyPinScreen(),
      ),
    );
  }

  void changeLoginMethod() {
    setState(() {
      otpSent = false;
      otpController.clear();
      mobileController.clear();
      emailController.clear();

      resendTimer?.cancel();
      resendSeconds = 30;
    });
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void openRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  void openForgotPin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ForgotPinScreen(),
      ),
    );
  }

  // ============================================================
  // INTERACTIVE LOGIN METHOD
  // ============================================================

  Widget loginMethodButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: otpSent ? null : onTap,
          borderRadius: BorderRadius.circular(13),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.055),
              borderRadius: BorderRadius.circular(13),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(
                          alpha: 0.10,
                        ),
                        blurRadius: 15,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget inputBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      cursorColor: const Color(0xFF5D9BFF),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF8BB8FF),
        ),
        filled: true,
        fillColor: Colors.white.withValues(
          alpha: 0.065,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: Colors.white.withValues(
              alpha: 0.10,
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Color(0xFF4D91FF),
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OTP BOX
  // ============================================================

  Widget otpBox() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glow =
            0.08 + _pulseController.value * 0.10;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2475EE).withValues(
                  alpha: glow,
                ),
                blurRadius: 22,
              ),
            ],
          ),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            cursorColor: const Color(0xFF5D9BFF),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 9,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••••',
              hintStyle: const TextStyle(
                color: Colors.white24,
                letterSpacing: 9,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF8BB8FF),
              ),
              filled: true,
              fillColor: Colors.white.withValues(
                alpha: 0.07,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.white.withValues(
                    alpha: 0.12,
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Color(0xFF4D91FF),
                  width: 1.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02050A),

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,

        onPanUpdate: (details) {
          setState(() {
            fingerX += details.delta.dx * 0.16;
            fingerY += details.delta.dy * 0.12;

            fingerX = fingerX.clamp(-15.0, 15.0);
            fingerY = fingerY.clamp(-10.0, 10.0);
          });
        },

        onPanEnd: (_) {
          setState(() {
            fingerX = 0;
            fingerY = 0;
          });
        },

        child: Stack(
          children: [
            // ==================================================
            // ANIMATED RAILWAY BACKGROUND
            // ==================================================

            Positioned.fill(
              child: AnimatedBuilder(
                animation: _trainController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      fingerX,
                      fingerY,
                    ),
                    child: CustomPaint(
                      painter: LoginRailwayPainter(
                        progress: _trainController.value,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // BLUE ATMOSPHERIC GLOW
            // ==================================================

            Positioned(
              top: 80 + fingerY,
              right: -70 + fingerX,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2475EE).withValues(
                        alpha: 0.15,
                      ),
                      blurRadius: 100,
                      spreadRadius: 15,
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // DARK OVERLAY
            // ==================================================

            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: 0.20,
                        ),
                        Colors.black.withValues(
                          alpha: 0.72,
                        ),
                        const Color(0xFF02050A),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            SafeArea(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    12,
                    22,
                    30,
                  ),
                  child: Column(
                    children: [
                      // ------------------------------------------
                      // HEADER
                      // ------------------------------------------

                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(30),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------
                      // TRAIN ICON
                      // ------------------------------------------

                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(
                                alpha: 0.07,
                              ),
                              border: Border.all(
                                color: const Color(0xFF5D9BFF)
                                    .withValues(
                                  alpha: 0.25 +
                                      _pulseController.value *
                                          0.15,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2475EE)
                                      .withValues(
                                    alpha: 0.10 +
                                        _pulseController.value *
                                            0.12,
                                  ),
                                  blurRadius: 28,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.train_rounded,
                              color: Color(0xFFB8D4FF),
                              size: 32,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Continue your railway journey',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ------------------------------------------
                      // MOBILE / EMAIL
                      // ------------------------------------------

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.055,
                          ),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.09,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            loginMethodButton(
                              title: 'Mobile',
                              icon:
                                  Icons.phone_android_rounded,
                              selected: isMobileLogin,
                              onTap: () {
                                setState(() {
                                  isMobileLogin = true;
                                });
                              },
                            ),

                            const SizedBox(width: 6),

                            loginMethodButton(
                              title: 'Email',
                              icon: Icons.email_outlined,
                              selected: !isMobileLogin,
                              onTap: () {
                                setState(() {
                                  isMobileLogin = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ------------------------------------------
                      // LOGIN INPUT
                      // ------------------------------------------

                      if (!otpSent) ...[
                        inputBox(
                          controller: isMobileLogin
                              ? mobileController
                              : emailController,
                          hint: isMobileLogin
                              ? 'Registered mobile number'
                              : 'Registered email address',
                          icon: isMobileLogin
                              ? Icons.phone_android_rounded
                              : Icons.email_outlined,
                          keyboardType: isMobileLogin
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: openForgotPin,
                            child: const Text(
                              'Forgot PIN?',
                              style: TextStyle(
                                color: Color(0xFF8BB8FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ----------------------------------------
                        // SEND OTP
                        // ----------------------------------------

                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(17),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2475EE)
                                        .withValues(
                                      alpha: 0.10 +
                                          _pulseController.value *
                                              0.10,
                                    ),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 57,
                                child: ElevatedButton(
                                  onPressed:
                                      isLoading ? null : sendOtp,
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF2475EE),
                                    foregroundColor:
                                        Colors.white,
                                    disabledBackgroundColor:
                                        const Color(0xFF31598F),
                                    elevation: 0,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              17),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .arrow_forward_rounded,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Continue',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ]

                      // ------------------------------------------
                      // OTP SECTION
                      // ------------------------------------------

                      else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(
                              alpha: 0.07,
                            ),
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.green.withValues(
                                alpha: 0.22,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified_rounded,
                                color: Colors.greenAccent,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isMobileLogin
                                      ? 'OTP sent to ${mobileController.text}'
                                      : 'OTP sent to ${emailController.text}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        otpBox(),

                        const SizedBox(height: 10),

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
                          height: 57,
                          child: ElevatedButton(
                            onPressed:
                                isLoading ? null : verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF2475EE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons
                                            .verified_rounded,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Verify & Continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
                              TextButton(
                                onPressed: resendOtp,
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: Color(0xFF8BB8FF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        TextButton(
                          onPressed: changeLoginMethod,
                          child: const Text(
                            'Change Mobile / Email',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      // ------------------------------------------
                      // REGISTER CARD
                      // ------------------------------------------

                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF5D9BFF)
                                .withValues(alpha: 0.18),
                          ),
                          color: Colors.white.withValues(
                            alpha: 0.045,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: openRegister,
                            borderRadius:
                                BorderRadius.circular(18),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF2475EE)
                                          .withValues(
                                        alpha: 0.15,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons
                                          .person_add_alt_1_rounded,
                                      color:
                                          Color(0xFF8BB8FF),
                                    ),
                                  ),

                                  const SizedBox(width: 13),

                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'New to IRCTC?',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Start your railway journey',
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(
                                    Icons
                                        .arrow_forward_ios_rounded,
                                    color: Colors.white54,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ------------------------------------------
                      // SECURITY
                      // ------------------------------------------

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
                            'Secure OTP authentication',
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

            // ==================================================
            // LOADING OVERLAY
            // ==================================================

            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.18,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101722),
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white12,
                        ),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.train_rounded,
                            color: Color(0xFF6EA6FF),
                            size: 30,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Connecting to journey...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: 120,
                            child:
                                LinearProgressIndicator(
                              minHeight: 3,
                              color: Color(0xFF2475EE),
                              backgroundColor:
                                  Colors.white12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// RAILWAY BACKGROUND
// ================================================================

class LoginRailwayPainter extends CustomPainter {
  final double progress;

  LoginRailwayPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint();

    // Background
    paint.color = const Color(0xFF030710);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );

    // Blue atmospheric area
    final gradient = RadialGradient(
      colors: [
        const Color(0xFF164E9A).withValues(alpha: 0.35),
        Colors.transparent,
      ],
    );

    final glowPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.75,
            size.height * 0.20,
          ),
          radius: 170,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.75,
        size.height * 0.20,
      ),
      170,
      glowPaint,
    );

    // Stars
    paint.color = Colors.white.withValues(
      alpha: 0.65,
    );

    for (int i = 0; i < 38; i++) {
      final x = (i * 71.0) % size.width;
      final y =
          (i * 113.0) % (size.height * 0.43);

      final twinkle =
          0.6 +
          0.4 *
              math.sin(
                progress * math.pi * 2 +
                    i,
              );

      paint.color = Colors.white.withValues(
        alpha: 0.35 * twinkle,
      );

      canvas.drawCircle(
        Offset(x, y),
        1.1,
        paint,
      );
    }

    // Moving train
    final trainX =
        -220 +
            (size.width + 440) * progress;

    paint.color = const Color(0xFF162238);

    final trainRect = Rect.fromLTWH(
      trainX,
      size.height * 0.49,
      200,
      64,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        trainRect,
        const Radius.circular(11),
      ),
      paint,
    );

    // Train blue stripe
    paint.color = const Color(0xFF2475EE);

    canvas.drawRect(
      Rect.fromLTWH(
        trainX,
        size.height * 0.56,
        200,
        6,
      ),
      paint,
    );

    // Windows
    paint.color = const Color(0xFFB8D4FF)
        .withValues(alpha: 0.75);

    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            trainX + 15 + (i * 42),
            size.height * 0.515,
            28,
            17,
          ),
          const Radius.circular(3),
        ),
        paint,
      );
    }

    // Headlight
    paint.color = Colors.white;

    canvas.drawCircle(
      Offset(
        trainX + 187,
        size.height * 0.575,
      ),
      7,
      paint,
    );

    // Railway track
    paint.color = const Color(0xFF303B4A);

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        size.height * 0.65,
        size.width,
        5,
      ),
      paint,
    );

    // Sleepers
    paint.color = const Color(0xFF252D38);

    for (int i = -1; i < 20; i++) {
      final x = i * 52.0;

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * 0.69,
          35,
          8,
        ),
        paint,
      );
    }

    // Neon route line
    final routePaint = Paint()
      ..color = const Color(0xFF2475EE)
          .withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final route = Path();

    route.moveTo(
      0,
      size.height * 0.37,
    );

    route.cubicTo(
      size.width * 0.22,
      size.height * 0.20,
      size.width * 0.40,
      size.height * 0.45,
      size.width * 0.58,
      size.height * 0.28,
    );

    route.cubicTo(
      size.width * 0.74,
      size.height * 0.12,
      size.width * 0.86,
      size.height * 0.36,
      size.width,
      size.height * 0.22,
    );

    canvas.drawPath(
      route,
      routePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant LoginRailwayPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}