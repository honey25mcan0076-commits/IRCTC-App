import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String enteredPin = '';
  bool isChecking = false;

  Future<void> verifyPin() async {
    if (enteredPin.length != 4 || isChecking) return;

    setState(() {
      isChecking = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('user_pin') ?? '';

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (!mounted) return;

    if (savedPin.isEmpty) {
      setState(() {
        isChecking = false;
      });

      showMessage(
        'No PIN found. Please create a PIN first.',
        isError: true,
      );
      return;
    }

    if (enteredPin == savedPin) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    setState(() {
      enteredPin = '';
      isChecking = false;
    });

    showMessage(
      'Incorrect PIN. Try again.',
      isError: true,
    );
  }

  void addDigit(String digit) {
    if (enteredPin.length >= 4 || isChecking) return;

    setState(() {
      enteredPin += digit;
    });

    if (enteredPin.length == 4) {
      verifyPin();
    }
  }

  void deleteDigit() {
    if (enteredPin.isEmpty || isChecking) return;

    setState(() {
      enteredPin =
          enteredPin.substring(0, enteredPin.length - 1);
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
      ),
    );
  }

  Widget keypadButton(String digit) {
    return GestureDetector(
      onTap: () {
        if (digit == '⌫') {
          deleteDigit();
        } else {
          addDigit(digit);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'App Locked',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter your 4-digit PIN to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 9,
                        ),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index < enteredPin.length
                              ? Colors.white
                              : Colors.white24,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  height: 330,
                  child: GridView.count(
                    crossAxisCount: 3,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    children: [
                      keypadButton('1'),
                      keypadButton('2'),
                      keypadButton('3'),
                      keypadButton('4'),
                      keypadButton('5'),
                      keypadButton('6'),
                      keypadButton('7'),
                      keypadButton('8'),
                      keypadButton('9'),
                      const SizedBox(),
                      keypadButton('0'),
                      keypadButton('⌫'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (isChecking)
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}