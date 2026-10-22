import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLockSettingsScreen extends StatefulWidget {
  const AppLockSettingsScreen({super.key});

  @override
  State<AppLockSettingsScreen> createState() =>
      _AppLockSettingsScreenState();
}

class _AppLockSettingsScreenState
    extends State<AppLockSettingsScreen> {
  bool appLockEnabled = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  Future<void> loadSetting() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      appLockEnabled =
          prefs.getBool('app_lock_enabled') ?? false;
      isLoading = false;
    });
  }

  Future<void> toggleAppLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    final savedPin = prefs.getString('user_pin') ?? '';

    if (value && savedPin.isEmpty) {
      showMessage(
        'Please create your PIN first from Login > Forgot PIN.',
        isError: true,
      );
      return;
    }

    await prefs.setBool('app_lock_enabled', value);

    if (!mounted) return;

    setState(() {
      appLockEnabled = value;
    });

    showMessage(
      value
          ? 'App Lock enabled successfully.'
          : 'App Lock disabled.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08090C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF08090C),
        foregroundColor: Colors.white,
        title: const Text(
          'App Lock',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15171C),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Protect your IRCTC account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Use your 4-digit PIN every time the app is opened.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF15171C),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SwitchListTile(
                    value: appLockEnabled,
                    onChanged: toggleAppLock,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF2475EE),
                    inactiveThumbColor: Colors.white70,
                    inactiveTrackColor: Colors.white12,
                    title: const Text(
                      'App Lock',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      appLockEnabled
                          ? 'PIN protection is enabled'
                          : 'PIN protection is disabled',
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                    secondary: Icon(
                      appLockEnabled
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white60,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'App Lock uses the 4-digit PIN saved on this device. '
                          'If you forget it, use Forgot PIN from the login screen.',
                          style: TextStyle(
                            color: Colors.white60,
                            height: 1.5,
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