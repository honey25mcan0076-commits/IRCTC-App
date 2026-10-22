import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late AnimationController _trainController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

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
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    _trainController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();

    super.dispose();
  }

  // ============================================================
  // REGISTER LOGIC
  // ============================================================

  Future<void> registerUser() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage(
        'Passwords do not match.',
        isError: true,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'user_name',
      nameController.text.trim(),
    );

    await prefs.setString(
      'user_mobile',
      mobileController.text.trim(),
    );

    await prefs.setString(
      'user_email',
      emailController.text.trim(),
    );

    await prefs.setString(
      'user_password',
      passwordController.text,
    );

    await prefs.setBool(
      'is_registered',
      true,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showSuccessDialog();
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF0B111B),
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
                // Animated success icon
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale =
                        0.96 +
                        (_pulseController.value * 0.08);

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withValues(
                            alpha: 0.12,
                          ),
                          border: Border.all(
                            color: Colors.greenAccent
                                .withValues(
                              alpha: 0.35,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green
                                  .withValues(
                                alpha: 0.18,
                              ),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.greenAccent,
                          size: 45,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Journey Ready!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your IRCTC account has been created successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 22),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.05,
                    ),
                    borderRadius:
                        BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.09,
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.train_rounded,
                        color: Color(0xFF8BB8FF),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your railway journey starts here.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 19,
                        ),
                      ],
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

  // ============================================================
  // PASSWORD STRENGTH
  // ============================================================

  int passwordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      score++;
    }

    return score;
  }

  Widget passwordStrengthWidget() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final password =
            passwordController.text;

        final strength =
            passwordStrength(password);

        if (password.isEmpty) {
          return const SizedBox.shrink();
        }

        String label;

        if (strength <= 1) {
          label = 'Weak password';
        } else if (strength <= 3) {
          label = 'Medium password';
        } else {
          label = 'Strong password';
        }

        return Padding(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 13,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(
                        5,
                        (index) {
                          final active =
                              index < strength;

                          return Expanded(
                            child: AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds: 250,
                              ),
                              height: 4,
                              margin:
                                  const EdgeInsets.only(
                                right: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                                color: active
                                    ? const Color(
                                        0xFF4D91FF,
                                      )
                                    : Colors.white12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: strength >= 4
                      ? Colors.greenAccent
                      : Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? onVisibilityPressed,
    String? Function(String?)? validator,
    VoidCallback? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        cursorColor: const Color(0xFF5D9BFF),
        validator: validator,
        onChanged: (_) {
          setState(() {});
          onChanged?.call();
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          hintStyle: const TextStyle(
            color: Colors.white30,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF8BB8FF),
          ),
          suffixIcon:
              onVisibilityPressed == null
                  ? null
                  : IconButton(
                      onPressed:
                          onVisibilityPressed,
                      icon: Icon(
                        obscureText
                            ? Icons
                                .visibility_off_rounded
                            : Icons
                                .visibility_rounded,
                        color: Colors.white70,
                      ),
                    ),
          filled: true,
          fillColor: Colors.white.withValues(
            alpha: 0.065,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: BorderSide(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Color(0xFF4D91FF),
              width: 1.4,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          focusedErrorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD MATCH INDICATOR
  // ============================================================

  Widget passwordMatchIndicator() {
    if (confirmPasswordController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final matched =
        confirmPasswordController.text ==
            passwordController.text;

    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 10,
      ),
      child: Row(
        children: [
          Icon(
            matched
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: matched
                ? Colors.greenAccent
                : Colors.redAccent,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            matched
                ? 'Passwords match'
                : 'Passwords do not match',
            style: TextStyle(
              color: matched
                  ? Colors.greenAccent
                  : Colors.redAccent,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
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
            // RAILWAY BACKGROUND
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
                      painter:
                          RegisterRailwayPainter(
                        progress:
                            _trainController.value,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // ATMOSPHERIC BLUE GLOW
            // ==================================================

            Positioned(
              top: 40 + fingerY,
              left: -80 + fingerX,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF2475EE,
                      ).withValues(
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
                          alpha: 0.18,
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
            // MAIN CONTENT
            // ==================================================

            SafeArea(
              child: FadeTransition(
                opacity: _fadeController,
                child: Column(
                  children: [
                    // HEADER
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        18,
                        8,
                        18,
                        0,
                      ),
                      child: Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),
                              onTap: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const Padding(
                                padding:
                                    EdgeInsets.all(10),
                                child: Icon(
                                  Icons
                                      .arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Text(
                              'Create Account',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 40),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.fromLTRB(
                          22,
                          8,
                          22,
                          35,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),

                              // --------------------------------
                              // PROFILE ICON
                              // --------------------------------

                              AnimatedBuilder(
                                animation:
                                    _pulseController,
                                builder:
                                    (context, child) {
                                  return Container(
                                    width: 76,
                                    height: 76,
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape.circle,
                                      color: Colors.white
                                          .withValues(
                                        alpha: 0.06,
                                      ),
                                      border:
                                          Border.all(
                                        color:
                                            const Color(
                                          0xFF5D9BFF,
                                        ).withValues(
                                          alpha: 0.22 +
                                              _pulseController
                                                      .value *
                                                  0.12,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color(
                                            0xFF2475EE,
                                          ).withValues(
                                            alpha: 0.08 +
                                                _pulseController
                                                        .value *
                                                    0.10,
                                          ),
                                          blurRadius: 30,
                                        ),
                                      ],
                                    ),
                                    child:
                                        const Icon(
                                      Icons
                                          .person_add_alt_1_rounded,
                                      color:
                                          Color(
                                        0xFFB8D4FF,
                                      ),
                                      size: 34,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 14),

                              const Text(
                                'Join IRCTC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 29,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Create your account and start your journey',
                                textAlign:
                                    TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(
                                height: 25,
                              ),

                              // --------------------------------
                              // NAME
                              // --------------------------------

                              inputField(
                                controller:
                                    nameController,
                                label: 'Full Name',
                                hint:
                                    'Enter your full name',
                                icon: Icons
                                    .person_outline_rounded,
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value.trim()
                                          .isEmpty) {
                                    return 'Please enter your name';
                                  }

                                  if (value
                                          .trim()
                                          .length <
                                      3) {
                                    return 'Name must be at least 3 characters';
                                  }

                                  return null;
                                },
                              ),

                              // --------------------------------
                              // MOBILE
                              // --------------------------------

                              inputField(
                                controller:
                                    mobileController,
                                label: 'Mobile Number',
                                hint:
                                    '10-digit mobile number',
                                icon: Icons
                                    .phone_android_rounded,
                                keyboardType:
                                    TextInputType.phone,
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value.trim()
                                          .isEmpty) {
                                    return 'Please enter mobile number';
                                  }

                                  if (!RegExp(
                                    r'^[6-9][0-9]{9}$',
                                  ).hasMatch(
                                    value.trim(),
                                  )) {
                                    return 'Enter a valid 10-digit mobile number';
                                  }

                                  return null;
                                },
                              ),

                              // --------------------------------
                              // EMAIL
                              // --------------------------------

                              inputField(
                                controller:
                                    emailController,
                                label: 'Email Address',
                                hint:
                                    'example@email.com',
                                icon: Icons
                                    .email_outlined,
                                keyboardType:
                                    TextInputType
                                        .emailAddress,
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value.trim()
                                          .isEmpty) {
                                    return 'Please enter email address';
                                  }

                                  if (!RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  ).hasMatch(
                                    value.trim(),
                                  )) {
                                    return 'Enter a valid email address';
                                  }

                                  return null;
                                },
                              ),

                              // --------------------------------
                              // PASSWORD
                              // --------------------------------

                              inputField(
                                controller:
                                    passwordController,
                                label: 'Password',
                                hint:
                                    'Create a strong password',
                                icon: Icons
                                    .lock_outline_rounded,
                                obscureText:
                                    obscurePassword,
                                onVisibilityPressed:
                                    () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value.isEmpty) {
                                    return 'Please create a password';
                                  }

                                  if (value.length <
                                      6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },
                              ),

                              passwordStrengthWidget(),

                              // --------------------------------
                              // CONFIRM PASSWORD
                              // --------------------------------

                              inputField(
                                controller:
                                    confirmPasswordController,
                                label:
                                    'Confirm Password',
                                hint:
                                    'Re-enter your password',
                                icon: Icons
                                    .lock_reset_rounded,
                                obscureText:
                                    obscureConfirmPassword,
                                onVisibilityPressed:
                                    () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                },
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value.isEmpty) {
                                    return 'Please confirm your password';
                                  }

                                  if (value !=
                                      passwordController
                                          .text) {
                                    return 'Passwords do not match';
                                  }

                                  return null;
                                },
                              ),

                              passwordMatchIndicator(),

                              const SizedBox(height: 3),

                              // --------------------------------
                              // SECURITY INFO
                              // --------------------------------

                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 13,
                                  vertical: 11,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.035,
                                  ),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    13,
                                  ),
                                  border: Border.all(
                                    color: Colors.white
                                        .withValues(
                                      alpha: 0.07,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .shield_rounded,
                                      size: 17,
                                      color: Color(
                                        0xFF8BB8FF,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Your account information is securely stored on this device.',
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white
                                              .withValues(
                                            alpha: 0.58,
                                          ),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 22,
                              ),

                              // --------------------------------
                              // CREATE ACCOUNT BUTTON
                              // --------------------------------

                              AnimatedBuilder(
                                animation:
                                    _pulseController,
                                builder:
                                    (context, child) {
                                  return Container(
                                    width:
                                        double.infinity,
                                    height: 57,
                                    decoration:
                                        BoxDecoration(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        17,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color(
                                            0xFF2475EE,
                                          ).withValues(
                                            alpha: 0.08 +
                                                _pulseController
                                                        .value *
                                                    0.10,
                                          ),
                                          blurRadius: 25,
                                        ),
                                      ],
                                    ),
                                    child:
                                        ElevatedButton(
                                      onPressed:
                                          isLoading
                                              ? null
                                              : registerUser,
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        backgroundColor:
                                            const Color(
                                          0xFF2475EE,
                                        ),
                                        foregroundColor:
                                            Colors.white,
                                        disabledBackgroundColor:
                                            const Color(
                                          0xFF31598F,
                                        ),
                                        elevation: 0,
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            17,
                                          ),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              children: [
                                                SizedBox(
                                                  width: 23,
                                                  height: 23,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth:
                                                        2.4,
                                                    color: Colors
                                                        .white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  'Creating your journey...',
                                                  style:
                                                      TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .train_rounded,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Create Account',
                                                  style:
                                                      TextStyle(
                                                    fontSize:
                                                        16,
                                                    fontWeight:
                                                        FontWeight
                                                            .bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_rounded,
                                                ),
                                              ],
                                            ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 19,
                              ),

                              // --------------------------------
                              // LOGIN
                              // --------------------------------

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color:
                                          Colors.white60,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Material(
                                    color: Colors
                                        .transparent,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                      onTap: () {
                                        Navigator
                                            .pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets
                                                .symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          'Login',
                                          style:
                                              TextStyle(
                                            color:
                                                Color(
                                              0xFF8BB8FF,
                                            ),
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    Icons
                                        .verified_user_rounded,
                                    size: 14,
                                    color: Colors.white
                                        .withValues(
                                      alpha: 0.45,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'Secure account creation',
                                    style: TextStyle(
                                      color: Colors.white
                                          .withValues(
                                        alpha: 0.45,
                                      ),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // LOADING OVERLAY
            // ==================================================

            if (isLoading)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.18,
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
// RAILWAY BACKGROUND PAINTER
// ================================================================

class RegisterRailwayPainter
    extends CustomPainter {
  final double progress;

  RegisterRailwayPainter({
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

    // Atmospheric blue glow
    final gradient = RadialGradient(
      colors: [
        const Color(0xFF164E9A)
            .withValues(alpha: 0.30),
        Colors.transparent,
      ],
    );

    final glowPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.30,
            size.height * 0.18,
          ),
          radius: 180,
        ),
      );

    canvas.drawCircle(
      Offset(
        size.width * 0.30,
        size.height * 0.18,
      ),
      180,
      glowPaint,
    );

    // Stars
    for (int i = 0; i < 42; i++) {
      final x =
          (i * 73.0) % size.width;

      final y =
          (i * 109.0) %
              (size.height * 0.43);

      final twinkle =
          0.55 +
          0.45 *
              math.sin(
                progress *
                        math.pi *
                        2 +
                    i,
              );

      paint.color =
          Colors.white.withValues(
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
        -230 +
            (size.width + 460) *
                progress;

    paint.color =
        const Color(0xFF162238);

    final trainRect = Rect.fromLTWH(
      trainX,
      size.height * 0.49,
      210,
      65,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        trainRect,
        const Radius.circular(11),
      ),
      paint,
    );

    // Blue stripe
    paint.color =
        const Color(0xFF2475EE);

    canvas.drawRect(
      Rect.fromLTWH(
        trainX,
        size.height * 0.56,
        210,
        6,
      ),
      paint,
    );

    // Windows
    paint.color =
        const Color(0xFFB8D4FF)
            .withValues(alpha: 0.72);

    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            trainX +
                15 +
                (i * 44),
            size.height * 0.515,
            29,
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
        trainX + 197,
        size.height * 0.575,
      ),
      7,
      paint,
    );

    // Track
    paint.color =
        const Color(0xFF303B4A);

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
    paint.color =
        const Color(0xFF252D38);

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

    // Route line
    final routePaint = Paint()
      ..color = const Color(
        0xFF2475EE,
      ).withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final route = Path();

    route.moveTo(
      0,
      size.height * 0.30,
    );

    route.cubicTo(
      size.width * 0.20,
      size.height * 0.15,
      size.width * 0.38,
      size.height * 0.42,
      size.width * 0.55,
      size.height * 0.25,
    );

    route.cubicTo(
      size.width * 0.73,
      size.height * 0.08,
      size.width * 0.85,
      size.height * 0.33,
      size.width,
      size.height * 0.18,
    );

    canvas.drawPath(
      route,
      routePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant RegisterRailwayPainter
        oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}