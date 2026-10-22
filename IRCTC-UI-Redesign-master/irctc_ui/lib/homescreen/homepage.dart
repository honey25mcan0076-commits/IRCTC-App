// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:irctc_ui/ai_assistant/ai_travel_assistant.dart';
import 'package:irctc_ui/homescreen/components/bottom_navigatoin_bar.dart';
import 'package:irctc_ui/homescreen/components/other_service_card.dart';
import 'package:irctc_ui/homescreen/components/train_service_card.dart';
import 'package:irctc_ui/homescreen/food_screen.dart';
import 'package:irctc_ui/homescreen/live_train_status.dart';
import 'package:irctc_ui/homescreen/rooms_screen.dart';
import 'package:irctc_ui/homescreen/search_train.dart';
import 'package:irctc_ui/notification_controller.dart';
import 'package:irctc_ui/theme_controller.dart';
import 'package:irctc_ui/homescreen/profile_screen.dart';
import 'package:irctc_ui/homescreen/notifications_screen.dart';
import 'package:irctc_ui/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController liveController;
  late Timer clockTimer;

  String currentTime = "";

  // Interactive hero animation
  Offset _touchOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    liveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    updateTime();

    clockTimer = Timer.periodic(
      Duration(seconds: 1),
      (_) => updateTime(),
    );
  }

  void updateTime() {
    if (!mounted) return;

    final now = DateTime.now();

    setState(() {
      currentTime =
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
    });
  }

  @override
  void dispose() {
    liveController.dispose();
    clockTimer.cancel();
    super.dispose();
  }

  // ============================================================
  // HERO TOUCH INTERACTION
  // ============================================================

  void _updateHeroTouch(Offset position, Size size) {
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
      _touchOffset = Offset(dx, dy);
    });
  }

  void _resetHeroTouch() {
    setState(() {
      _touchOffset = Offset.zero;
    });
  }

  // ============================================================
  // THEME HELPERS
  // ============================================================

  bool get isDark => appThemeController.isDark;

  Color get pageBackground =>
      isDark ? Color(0xFF050608) : Color(0xFFF5F7FA);

  Color get cardBackground =>
      isDark ? Color(0xFF101318) : Colors.white;

  Color get secondaryCardBackground =>
      isDark ? Color(0xFF15171C) : Color(0xFFF0F3F7);

  Color get primaryText =>
      isDark ? Colors.white : Color(0xFF111318);

  Color get secondaryText =>
      isDark ? Colors.white54 : Color(0xFF666B73);

  Color get mutedText =>
      isDark ? Colors.white38 : Color(0xFF8A9099);

  Color get borderColor =>
      isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.07);

  // ============================================================
  // QUICK MESSAGE
  // ============================================================

  void showQuickMessage(
    String title,
    String message,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            22,
            22,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2475EE),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Got it",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION TILE
  // ============================================================

  Widget _notificationTile({
    required int index,
    required AppNotification notification,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          appNotificationController
              .markAsRead(index);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 11),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? secondaryCardBackground
                : Color(0xFF2475EE).withValues(
                    alpha: isDark ? 0.08 : 0.06,
                  ),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: notification.isRead
                  ? borderColor
                  : Color(0xFF2475EE).withValues(
                      alpha: 0.18,
                    ),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: notification.color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  notification.icon,
                  color: notification.color,
                  size: 21,
                ),
              ),

              SizedBox(width: 12),

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
                              color: primaryText,
                              fontSize: 13,
                              fontWeight:
                                  notification.isRead
                                      ? FontWeight.w600
                                      : FontWeight.w800,
                            ),
                          ),
                        ),

                        if (!notification.isRead)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Text(
                      notification.message,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      notification.time,
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN NOTIFICATIONS
  // ============================================================

  void openNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedBuilder(
          animation: appNotificationController,
          builder: (context, child) {
            final notifications =
                appNotificationController.notifications;

            return Container(
              height:
                  MediaQuery.of(context).size.height *
                      0.68,
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12),

                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: secondaryText.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 18),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Notifications",
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        Spacer(),

                        if (appNotificationController
                                .unreadCount >
                            0)
                          Container(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF2475EE)
                                  .withValues(
                                alpha: 0.12,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Text(
                              "${appNotificationController.unreadCount} NEW",
                              style: TextStyle(
                                color:
                                    Color(0xFF4C92FF),
                                fontSize: 9,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  Expanded(
                    child: notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .notifications_none_rounded,
                                  color: mutedText,
                                  size: 48,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No notifications",
                                  style: TextStyle(
                                    color:
                                        primaryText,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "You're all caught up.",
                                  style: TextStyle(
                                    color:
                                        secondaryText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            physics:
                                BouncingScrollPhysics(),
                            itemCount:
                                notifications.length,
                            itemBuilder:
                                (context, index) {
                              return _notificationTile(
                                index: index,
                                notification:
                                    notifications[index],
                              );
                            },
                          ),
                  ),

                  if (notifications.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        22,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                appNotificationController
                                    .markAllAsRead();
                              },
                              style:
                                  OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color:
                                      Color(0xFF2475EE)
                                          .withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    13,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Mark all as read",
                                style: TextStyle(
                                  color:
                                      Color(0xFF4C92FF),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                appNotificationController
                                    .clearNotifications();
                              },
                              child: Text(
                                "Clear all",
                                style: TextStyle(
                                  color:
                                      Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w700,
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

  // ============================================================
  // QUICK ACTION
  // ============================================================

  Widget quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(17),
          splashColor:
              Color(0xFF2475EE).withValues(
            alpha: 0.15,
          ),
          highlightColor:
              Color(0xFF2475EE).withValues(
            alpha: 0.08,
          ),
          child: Ink(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color:
                  secondaryCardBackground,
              borderRadius:
                  BorderRadius.circular(17),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(0xFF2475EE)
                        .withValues(
                      alpha: 0.13,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color:
                        Color(0xFF4C92FF),
                    size: 21,
                  ),
                ),

                SizedBox(height: 11),

                Text(
                  title,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 10,
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
  // DESTINATION CHIP
  // ============================================================

  Widget destinationChip(
    String city,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: secondaryCardBackground,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            color:
                Color(0xFF4C92FF),
            size: 16,
          ),

          SizedBox(width: 6),

          Text(
            city,
            style: TextStyle(
              color: primaryText,
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS ITEM
  // ============================================================

  Widget _statusItem(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: mutedText,
              fontSize: 9,
            ),
          ),

          SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryText,
              fontSize: 11,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS LINE
  // ============================================================

  Widget _statusLine() {
    return Container(
      width: 22,
      height: 1,
      color: isDark
          ? Colors.white12
          : Colors.black12,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          appThemeController,
      builder:
          (context, child) {
        return Scaffold(
          backgroundColor:
              pageBackground,

          extendBodyBehindAppBar:
              true,

          // ====================================================
          // APP BAR
          // ====================================================

          appBar: AppBar(
            backgroundColor:
                Colors.transparent,
            elevation: 0,

            actions: [
              // ==================================================
              // PROFILE BUTTON
              // ==================================================

              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.35)
                            : Colors.white.withValues(alpha: 0.90),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.10)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: primaryText,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // THEME BUTTON
              // ==================================================

              Padding(
                padding:
                    EdgeInsets.only(
                  right: 8,
                ),
                child: Material(
                  color:
                      Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(
                      50,
                    ),
                    onTap: () {
                      appThemeController
                          .toggleTheme();
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration:
                          BoxDecoration(
                        color: isDark
                            ? Colors.black
                                .withValues(
                                alpha: 0.35,
                              )
                            : Colors.white
                                .withValues(
                                alpha: 0.90,
                              ),
                        shape:
                            BoxShape.circle,
                        border:
                            Border.all(
                          color: isDark
                              ? Colors.white
                                  .withValues(
                                  alpha:
                                      0.10,
                                )
                              : Colors.black
                                  .withValues(
                                  alpha:
                                      0.08,
                                ),
                        ),
                      ),
                      child:
                          AnimatedSwitcher(
                        duration:
                            Duration(
                          milliseconds:
                              250,
                        ),
                        child: Icon(
                          isDark
                              ? Icons
                                  .light_mode_rounded
                              : Icons
                                  .dark_mode_rounded,
                          key: ValueKey(
                            isDark,
                          ),
                          color: isDark
                              ? Colors.amber
                              : Color(
                                  0xFF2475EE,
                                ),
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // NOTIFICATION BUTTON
              // ==================================================

              Padding(
                padding:
                    EdgeInsets.only(
                  right: 14,
                ),
                child: AnimatedBuilder(
                  animation:
                      appNotificationController,
                  builder:
                      (context, child) {
                    final unread =
                        appNotificationController
                            .unreadCount;

                    return Material(
                      color:
                          Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          50,
                        ),
                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const NotificationsScreen(),
    ),
  );
},
                        child: Stack(
                          clipBehavior:
                              Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  BoxDecoration(
                                color: isDark
                                    ? Colors
                                        .black
                                        .withValues(
                                        alpha:
                                            0.35,
                                      )
                                    : Colors
                                        .white
                                        .withValues(
                                        alpha:
                                            0.90,
                                      ),
                                shape:
                                    BoxShape
                                        .circle,
                                border:
                                    Border.all(
                                  color: isDark
                                      ? Colors
                                          .white
                                          .withValues(
                                          alpha:
                                              0.10,
                                        )
                                      : Colors
                                          .black
                                          .withValues(
                                          alpha:
                                              0.08,
                                        ),
                                ),
                              ),
                              child: Icon(
                                Icons
                                    .notifications_none_rounded,
                                color:
                                    primaryText,
                                size: 22,
                              ),
                            ),

                            if (unread > 0)
                              Positioned(
                                right: -5,
                                top: -5,
                                child:
                                    Container(
                                  constraints:
                                      BoxConstraints(
                                    minWidth:
                                        16,
                                    minHeight:
                                        16,
                                  ),
                                  padding:
                                      EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        4,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        Colors
                                            .redAccent,
                                    shape:
                                        BoxShape
                                            .circle,
                                    border:
                                        Border.all(
                                      color:
                                          pageBackground,
                                      width:
                                          2,
                                    ),
                                  ),
                                  child:
                                      Center(
                                    child:
                                        Text(
                                      unread >
                                              9
                                          ? "9+"
                                          : "$unread",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,
                                        fontSize:
                                            7,
                                        fontWeight:
                                            FontWeight
                                                .w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ====================================================
          // BODY
          // ====================================================

          body: SafeArea(
            child:
                SingleChildScrollView(
              physics:
                  BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  // =================================================
                  // HERO SECTION - INTERACTIVE
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(
                      setWidth(18),
                      12,
                      setWidth(18),
                      0,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final heroSize = Size(
                          constraints.maxWidth,
                          245,
                        );

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanUpdate: (details) {
                            _updateHeroTouch(
                              details.localPosition,
                              heroSize,
                            );
                          },
                          onPanEnd: (_) {
                            _resetHeroTouch();
                          },
                          onPanCancel: _resetHeroTouch,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Stack(
                              children: [
                                // Moving background
                                Positioned.fill(
                                  child: Transform.translate(
                                    offset: Offset(
                                      _touchOffset.dx * 9,
                                      _touchOffset.dy * 6,
                                    ),
                                    child: Transform.scale(
                                      scale: 1.04,
                                      child: Image.asset(
                                        "sf/img/home_bg.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                // Dark overlay
                                Positioned.fill(
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
                                            alpha: 0.88,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Interactive blue glow
                                Positioned(
                                  left: constraints.maxWidth * 0.32 +
                                      (_touchOffset.dx * 65),
                                  top: 70 +
                                      (_touchOffset.dy * 45),
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF2475EE)
                                                .withValues(alpha: 0.18),
                                            blurRadius: 70,
                                            spreadRadius: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Hero content
                                Container(
                                  height: 245,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(21),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2475EE),
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                            ),
                                            child: Text(
                                              "IRCTC TRAVEL",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            currentTime,
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 13),

                                      Text(
                                        "Your Journey.\nYour India.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          height: 1.05,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "Travel smarter with your complete railway companion.",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  // =================================================
                  // LIVE TRAIN STATUS
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child:
                        AnimatedBuilder(
                      animation:
                          liveController,
                      builder:
                          (context,
                              child) {
                        return Container(
                          padding:
                              EdgeInsets
                                  .all(
                            16,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                cardBackground,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              21,
                            ),
                            border:
                                Border.all(
                              color:
                                  borderColor,
                            ),
                          ),
                          child:
                              Column(
                            children: [
                              Row(
                                children: [
                                  FadeTransition(
                                    opacity:
                                        Tween<double>(
                                      begin:
                                          0.35,
                                      end:
                                          1,
                                    ).animate(
                                      liveController,
                                    ),
                                    child:
                                        Container(
                                      width:
                                          9,
                                      height:
                                          9,
                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors
                                                .redAccent,
                                        shape:
                                            BoxShape
                                                .circle,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 7,
                                  ),

                                  Text(
                                    "LIVE TRAIN STATUS",
                                    style:
                                        TextStyle(
                                      color:
                                          primaryText,
                                      fontSize:
                                          12,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      letterSpacing:
                                          0.7,
                                    ),
                                  ),

                                  Spacer(),

                                  Container(
                                    padding:
                                        EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          8,
                                      vertical:
                                          5,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .green
                                          .withValues(
                                        alpha:
                                            0.12,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                    ),
                                    child:
                                        Text(
                                      "ON TIME",
                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .greenAccent,
                                        fontSize:
                                            9,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 14,
                              ),

                              Row(
                                children: [
                                  Container(
                                    width:
                                        42,
                                    height:
                                        42,
                                    decoration:
                                        BoxDecoration(
                                      color: Color(
                                        0xFF2475EE,
                                      ).withValues(
                                        alpha:
                                            0.13,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),
                                    child:
                                        Icon(
                                      Icons
                                          .train_rounded,
                                      color:
                                          Color(
                                        0xFF4C92FF,
                                      ),
                                      size:
                                          23,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          "12956 Jaipur Superfast",
                                          style:
                                              TextStyle(
                                            color:
                                                primaryText,
                                            fontSize:
                                                14,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          "Jaipur → Mumbai Central",
                                          style:
                                              TextStyle(
                                            color:
                                                secondaryText,
                                            fontSize:
                                                11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Icon(
                                    Icons
                                        .arrow_forward_ios,
                                    color:
                                        mutedText,
                                    size:
                                        14,
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 14,
                              ),

                              Row(
                                children: [
                                  _statusItem(
                                    "Current",
                                    "Jaipur Jn",
                                  ),
                                  _statusLine(),
                                  _statusItem(
                                    "Next",
                                    "Ajmer Jn",
                                  ),
                                  _statusLine(),
                                  _statusItem(
                                    "Platform",
                                    "2",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // =================================================
                  // QUICK ACTIONS
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(21),
                    ),
                    child: Text(
                      "Quick actions",
                      style:
                          TextStyle(
                        color:
                            isDark
                                ? Color(
                                    0xFFA5A5A5,
                                  )
                                : Color(
                                    0xFF4F555D,
                                  ),
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child: Row(
                      children: [
                        quickAction(
                          icon: Icons
                              .confirmation_number_outlined,
                          title:
                              "PNR Status",
                          subtitle:
                              "Check ticket",
                          onTap: () {
                            showQuickMessage(
                              "PNR Status",
                              "Enter your 10-digit PNR to check booking status.",
                            );
                          },
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        quickAction(
                          icon: Icons
                              .location_searching,
                          title:
                              "Live Train",
                          subtitle:
                              "Track journey",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const LiveTrainStatusScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        quickAction(
                          icon: Icons
                              .receipt_long_outlined,
                          title:
                              "Bookings",
                          subtitle:
                              "Your tickets",
                          onTap: () {
                            showQuickMessage(
                              "My Bookings",
                              "Your confirmed and upcoming journeys will appear here.",
                            );
                          },
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        quickAction(
                          icon: Icons
                              .cancel_outlined,
                          title:
                              "Cancel",
                          subtitle:
                              "Cancel ticket",
                          onTap: () {
                            showQuickMessage(
                              "Cancel Ticket",
                              "Select a booking to start the cancellation process.",
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 28,
                  ),

                  // =================================================
                  // TRAVEL SERVICES
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(21),
                    ),
                    child: Text(
                      "Travel services",
                      style:
                          TextStyle(
                        color:
                            isDark
                                ? Color(
                                    0xFFA5A5A5,
                                  )
                                : Color(
                                    0xFF4F555D,
                                  ),
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 13,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          SearchTrainScreen(),
                                ),
                              );
                            },
                            child:
                                TrainServiceCardWidget(
                              imgPath:
                                  "sf/img/train.png",
                              imgColor:
                                  Color(
                                0xFF3C87F6,
                              ),
                              title:
                                  "Train",
                              description:
                                  "Book your next train",
                              cardColor:
                                  Color(
                                0xFF2475EE,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width:
                              setWidth(
                            14,
                          ),
                        ),

                        Expanded(
                          child:
                              InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          FoodScreen(),
                                ),
                              );
                            },
                            child:
                                TrainServiceCardWidget(
                              imgPath:
                                  "sf/img/food.png",
                              imgColor:
                                  Color(
                                0xFF292A2F,
                              ),
                              title:
                                  "Food",
                              description:
                                  "Order food at your seat",
                              cardColor:
                                  Color(
                                0xFF1D1F24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 14,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          AITravelAssistant(),
                                ),
                              );
                            },
                            child:
                                TrainServiceCardWidget(
                              imgPath:
                                  "sf/img/ask_disha.png",
                              imgColor:
                                  Color(
                                0xFF292A2F,
                              ),
                              title:
                                  "Ask Disha",
                              description:
                                  "AI Travel Assistant",
                              cardColor:
                                  Color(
                                0xFF1D1F24,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width:
                              setWidth(
                            14,
                          ),
                        ),

                        Expanded(
                          child:
                              InkWell(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          RoomsScreen(),
                                ),
                              );
                            },
                            child:
                                TrainServiceCardWidget(
                              imgPath:
                                  "sf/img/rooms.png",
                              imgColor:
                                  Color(
                                0xFF292A2F,
                              ),
                              title:
                                  "Rooms",
                              description:
                                  "Book rooms at stations",
                              cardColor:
                                  Color(
                                0xFF1D1F24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 28,
                  ),

                  // =================================================
                  // POPULAR DESTINATIONS
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(21),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Popular destinations",
                          style:
                              TextStyle(
                            color:
                                isDark
                                    ? Color(
                                        0xFFA5A5A5,
                                      )
                                    : Color(
                                        0xFF4F555D,
                                      ),
                            fontSize:
                                20,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        Spacer(),

                        Icon(
                          Icons
                              .explore_outlined,
                          color:
                              Color(
                            0xFF3C87F6,
                          ),
                          size: 21,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  SizedBox(
                    height: 43,
                    child:
                        ListView(
                      padding:
                          EdgeInsets
                              .symmetric(
                        horizontal:
                            setWidth(
                          18,
                        ),
                      ),
                      scrollDirection:
                          Axis.horizontal,
                      children: [
                        destinationChip(
                          "Jaipur",
                        ),
                        destinationChip(
                          "New Delhi",
                        ),
                        destinationChip(
                          "Mumbai",
                        ),
                        destinationChip(
                          "Agra",
                        ),
                        destinationChip(
                          "Goa",
                        ),
                        destinationChip(
                          "Ahmedabad",
                        ),
                        destinationChip(
                          "Amritsar",
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 28,
                  ),

                  // =================================================
                  // OTHER SERVICES
                  // =================================================

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(21),
                    ),
                    child: Text(
                      "Other services",
                      style:
                          TextStyle(
                        color:
                            isDark
                                ? Color(
                                    0xFFA5A5A5,
                                  )
                                : Color(
                                    0xFF4F555D,
                                  ),
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 13,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              OtherServiceCardWidget(
                            title:
                                "Flight",
                            description:
                                "Book your next flight",
                          ),
                        ),

                        SizedBox(
                          width: 14,
                        ),

                        Expanded(
                          child:
                              OtherServiceCardWidget(
                            title:
                                "Hotel",
                            description:
                                "Book your next stay",
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 14,
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal:
                          setWidth(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              OtherServiceCardWidget(
                            title:
                                "Bus",
                            description:
                                "Book your next bus",
                          ),
                        ),

                        SizedBox(
                          width: 14,
                        ),

                        Expanded(
                          child:
                              OtherServiceCardWidget(
                            title:
                                "Tourism",
                            description:
                                "Explore tour options",
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ),

          // ========================================================
          // BOTTOM NAVIGATION
          // ========================================================

          bottomNavigationBar:
              BottomNavigationBarWidget(),
        );
      },
    );
  }
}