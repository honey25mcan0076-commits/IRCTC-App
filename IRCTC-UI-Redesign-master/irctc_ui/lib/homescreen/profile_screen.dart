import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_bookings.dart';
import '../authentication/app_lock_settings.dart';
import '../authentication/forgot_pin.dart';
import '../authentication/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "IRCTC User";
  String userMobile = "";
  String userEmail = "";
  bool appLockEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      userName = prefs.getString('user_name') ?? "IRCTC User";
      userMobile = prefs.getString('user_mobile') ?? "";
      userEmail = prefs.getString('user_email') ?? "";
      appLockEnabled = prefs.getBool('app_lock_enabled') ?? false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('is_logged_in', false);

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _openMyBookings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyBookingsScreen(),
      ),
    );
  }

  void _openForgotPin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ForgotPinScreen(),
      ),
    );
  }

  void _openAppLock() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AppLockSettingsScreen(),
      ),
    ).then((_) {
      _loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF151515),
                          const Color(0xFF242424),
                        ]
                      : [
                          Colors.grey.shade100,
                          Colors.white,
                        ],
                ),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF2475EE),
                    child: Text(
                      userName.isNotEmpty
                          ? userName[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  if (userMobile.isNotEmpty)
                    Text(
                      userMobile,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),

                  if (userEmail.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Account & Security",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // APP LOCK
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "App Lock",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  appLockEnabled
                      ? "App Lock is enabled"
                      : "Protect your app with PIN",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: _openAppLock,
              ),
            ),

            // CHANGE PIN
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.password_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Change PIN",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "Reset or change your security PIN",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: _openForgotPin,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "My Account",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // MY BOOKINGS
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "My Bookings",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "View and manage your train bookings",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: _openMyBookings,
              ),
            ),

            // HELP
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "Get help with your journey",
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Help & Support coming soon",
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // LOGOUT
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}