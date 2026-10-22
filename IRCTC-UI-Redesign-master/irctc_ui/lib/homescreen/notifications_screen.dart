import 'package:flutter/material.dart';

import '../notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appNotificationController,
      builder: (context, _) {
        final notifications =
            appNotificationController.notifications;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              if (notifications.isNotEmpty)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "read") {
                      appNotificationController
                          .markAllAsRead();

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "All notifications marked as read",
                          ),
                        ),
                      );
                    }

                    if (value == "clear") {
                      _clearAllNotifications();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "read",
                      child: Row(
                        children: [
                          Icon(
                            Icons.done_all_rounded,
                          ),
                          SizedBox(width: 10),
                          Text("Mark all as read"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "clear",
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text("Clear all"),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          body: notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationCard(
                      notifications[index],
                      index,
                    );
                  },
                ),
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _buildNotificationCard(
    AppNotification notification,
    int index,
  ) {
    return Dismissible(
      key: ValueKey(
        "${notification.title}_${notification.time}_$index",
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        appNotificationController
            .removeNotification(index);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: notification.isRead ? 1 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            appNotificationController
                .toggleReadStatus(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                // ICON
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: notification.color
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                // CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    notification.isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                              ),
                            ),
                          ),

                          if (!notification.isRead)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color:
                                    notification.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color:
                                Colors.grey.shade500,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
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
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              Icons.notifications_off_outlined,
              size: 85,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "You're all caught up!",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  Future<void> _clearAllNotifications() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Clear Notifications?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "All notifications will be removed.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    appNotificationController
        .clearNotifications();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "All notifications cleared",
        ),
      ),
    );
  }
}