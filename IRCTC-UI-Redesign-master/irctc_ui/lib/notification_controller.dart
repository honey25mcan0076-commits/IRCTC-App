import 'package:flutter/material.dart';

class AppNotification {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color color;
  bool isRead;

  AppNotification({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.color,
    this.isRead = false,
  });
}

class NotificationController extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      icon: Icons.train_rounded,
      title: "Train Running On Time",
      message:
          "12956 Jaipur Superfast is running as scheduled.",
      time: "2 min ago",
      color: const Color(0xFF2475EE),
    ),

    AppNotification(
      icon: Icons.confirmation_number_rounded,
      title: "Booking Confirmed",
      message:
          "Your railway ticket has been confirmed successfully.",
      time: "15 min ago",
      color: Colors.green,
    ),

    AppNotification(
      icon: Icons.restaurant_rounded,
      title: "Food Available",
      message:
          "Order delicious food directly to your seat.",
      time: "1 hour ago",
      color: Colors.orange,
    ),

    AppNotification(
      icon: Icons.hotel_rounded,
      title: "Stay Near Your Station",
      message:
          "Discover comfortable rooms for your journey.",
      time: "3 hours ago",
      color: Colors.purple,
    ),
  ];

  // ============================================================
  // GET ALL NOTIFICATIONS
  // ============================================================

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  // ============================================================
  // UNREAD COUNT
  // ============================================================

  int get unreadCount {
    return _notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  // ============================================================
  // ADD NOTIFICATION
  // ============================================================

  void addNotification({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required Color color,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        icon: icon,
        title: title,
        message: message,
        time: time,
        color: color,
      ),
    );

    notifyListeners();
  }

  // ============================================================
  // MARK ONE AS READ
  // ============================================================

  void markAsRead(int index) {
    if (index < 0 || index >= _notifications.length) {
      return;
    }

    _notifications[index].isRead = true;

    notifyListeners();
  }

  // ============================================================
  // MARK ONE AS UNREAD
  // ============================================================

  void markAsUnread(int index) {
    if (index < 0 || index >= _notifications.length) {
      return;
    }

    _notifications[index].isRead = false;

    notifyListeners();
  }

  // ============================================================
  // TOGGLE READ / UNREAD
  // ============================================================

  void toggleReadStatus(int index) {
    if (index < 0 || index >= _notifications.length) {
      return;
    }

    _notifications[index].isRead =
        !_notifications[index].isRead;

    notifyListeners();
  }

  // ============================================================
  // MARK ALL AS READ
  // ============================================================

  void markAllAsRead() {
    for (final notification in _notifications) {
      notification.isRead = true;
    }

    notifyListeners();
  }

  // ============================================================
  // CLEAR ALL NOTIFICATIONS
  // ============================================================

  void clearNotifications() {
    _notifications.clear();

    notifyListeners();
  }

  // ============================================================
  // REMOVE ONE NOTIFICATION
  // ============================================================

  void removeNotification(int index) {
    if (index < 0 || index >= _notifications.length) {
      return;
    }

    _notifications.removeAt(index);

    notifyListeners();
  }

  // ============================================================
  // CLEAR READ NOTIFICATIONS
  // ============================================================

  void clearReadNotifications() {
    _notifications.removeWhere(
      (notification) => notification.isRead,
    );

    notifyListeners();
  }
}

// ============================================================
// GLOBAL NOTIFICATION CONTROLLER
// ============================================================

final NotificationController appNotificationController =
    NotificationController();