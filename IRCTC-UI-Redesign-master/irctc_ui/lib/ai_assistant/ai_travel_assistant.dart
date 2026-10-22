import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/search_train.dart';
import 'package:irctc_ui/homescreen/journey_planner.dart';

class AITravelAssistant extends StatefulWidget {
  const AITravelAssistant({super.key});

  @override
  State<AITravelAssistant> createState() => _AITravelAssistantState();
}

class _AITravelAssistantState extends State<AITravelAssistant> {
  final TextEditingController messageController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  bool isTyping = false;

  final List<Map<String, String>> messages = [
    {
      "sender": "ai",
      "message":
          "Hello! 👋 I'm Ask Disha, your IRCTC AI Travel Assistant.\n\n"
          "You can say things like:\n"
          "🚆 Jaipur se Delhi jana hai\n"
          "🚆 Find a train\n"
          "📍 Plan my journey\n"
          "🪑 How do I select a seat?\n"
          "🎫 PNR help\n\n"
          "How can I help you?"
    }
  ];

  void addMessage(String sender, String message) {
    if (!mounted) return;

    setState(() {
      messages.add({
        "sender": sender,
        "message": message,
      });
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  // ============================================================
  // OPEN SEARCH WITH AI DETECTED ROUTE
  // ============================================================

  void openSearchWithRoute({
    String? fromCode,
    String? fromName,
    String? toCode,
    String? toName,
    DateTime? journeyDate,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchTrainScreen(
          initialFromCode: fromCode,
          initialFromName: fromName,
          initialToCode: toCode,
          initialToName: toName,
          initialDepartureDate: journeyDate,
        ),
      ),
    );
  }

  void openJourneyPlanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JourneyPlannerScreen(),
      ),
    );
  }

  // ============================================================
  // DATE DETECTION
  // ============================================================

  DateTime? detectDate(String text) {
    final now = DateTime.now();

    if (text.contains("today") ||
        text.contains("aaj")) {
      return DateTime(
        now.year,
        now.month,
        now.day,
      );
    }

    if (text.contains("tomorrow") ||
        text.contains("kal")) {
      return DateTime(
        now.year,
        now.month,
        now.day + 1,
      );
    }

    if (text.contains("day after tomorrow") ||
        text.contains("parso")) {
      return DateTime(
        now.year,
        now.month,
        now.day + 2,
      );
    }

    return null;
  }

  // ============================================================
  // ROUTE DETECTION
  // ============================================================

  Map<String, String>? detectRoute(String text) {
    final routes = [
      {
        "fromCode": "JP",
        "fromName": "Jaipur",
        "toCode": "NDLS",
        "toName": "New Delhi",
        "fromWords": "jaipur,jp",
        "toWords": "delhi,new delhi,ndls",
      },
      {
        "fromCode": "NDLS",
        "fromName": "New Delhi",
        "toCode": "JP",
        "toName": "Jaipur",
        "fromWords": "delhi,new delhi,ndls",
        "toWords": "jaipur,jp",
      },
      {
        "fromCode": "KYN",
        "fromName": "Kalyan Jn",
        "toCode": "DR",
        "toName": "Dadar",
        "fromWords": "kalyan,kyn,kalyan jn",
        "toWords": "dadar,dr",
      },
      {
        "fromCode": "DR",
        "fromName": "Dadar",
        "toCode": "KYN",
        "toName": "Kalyan Jn",
        "fromWords": "dadar,dr",
        "toWords": "kalyan,kyn,kalyan jn",
      },
      {
        "fromCode": "ADI",
        "fromName": "Ahmedabad Jn",
        "toCode": "JP",
        "toName": "Jaipur",
        "fromWords": "ahmedabad,adi",
        "toWords": "jaipur,jp",
      },
      {
        "fromCode": "JP",
        "fromName": "Jaipur",
        "toCode": "ADI",
        "toName": "Ahmedabad Jn",
        "fromWords": "jaipur,jp",
        "toWords": "ahmedabad,adi",
      },
    ];

    for (final route in routes) {
      final fromFound = route["fromWords"]!
          .split(",")
          .any(text.contains);

      final toFound = route["toWords"]!
          .split(",")
          .any(text.contains);

      if (fromFound && toFound) {
        return {
          "fromCode": route["fromCode"]!,
          "fromName": route["fromName"]!,
          "toCode": route["toCode"]!,
          "toName": route["toName"]!,
        };
      }
    }

    return null;
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void sendMessage() {
    final message = messageController.text.trim();

    if (message.isEmpty || isTyping) return;

    addMessage("user", message);
    messageController.clear();

    setState(() {
      isTyping = true;
    });

    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        if (!mounted) return;

        final response = processMessage(message);

        setState(() {
          isTyping = false;
        });

        addMessage("ai", response);
      },
    );
  }

  // ============================================================
  // PROCESS MESSAGE
  // ============================================================

  String processMessage(String message) {
    final text = message.toLowerCase().trim();

    // ----------------------------------------------------------
    // ROUTE DETECTION FIRST
    // ----------------------------------------------------------

    final route = detectRoute(text);

    if (route != null) {
      final detectedDate = detectDate(text);

      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (!mounted) return;

          openSearchWithRoute(
            fromCode: route["fromCode"],
            fromName: route["fromName"],
            toCode: route["toCode"],
            toName: route["toName"],
            journeyDate: detectedDate,
          );
        },
      );

      if (detectedDate != null) {
        return "🚆 Journey detected!\n\n"
            "${route["fromName"]} (${route["fromCode"]}) → "
            "${route["toName"]} (${route["toCode"]})\n\n"
            "📅 Date detected automatically.\n\n"
            "I'm opening Train Search for you.";
      }

      return "🚆 I detected your journey:\n\n"
          "${route["fromName"]} (${route["fromCode"]}) → "
          "${route["toName"]} (${route["toCode"]})\n\n"
          "Please select your journey date.\n\n"
          "I'm opening Train Search for you.";
    }

    // ----------------------------------------------------------
    // JOURNEY PLANNER
    // ----------------------------------------------------------

    if (text.contains("journey planner") ||
        text.contains("journey plan") ||
        text.contains("plan my journey") ||
        text.contains("plan my trip") ||
        text.contains("route")) {
      Future.delayed(
        const Duration(milliseconds: 400),
        () {
          if (mounted) {
            openJourneyPlanner();
          }
        },
      );

      return "📍 Sure! I'm opening Journey Planner for you.";
    }

    // ----------------------------------------------------------
    // TRAIN
    // ----------------------------------------------------------

    if (text.contains("train") ||
        text.contains("railway") ||
        text.contains("express") ||
        text.contains("find train") ||
        text.contains("search train")) {
      Future.delayed(
        const Duration(milliseconds: 400),
        () {
          if (mounted) {
            openSearchWithRoute();
          }
        },
      );

      return "🚆 Sure! I'm opening Train Search for you.";
    }

    // ----------------------------------------------------------
    // BOOKING
    // ----------------------------------------------------------

    if (text.contains("booking") ||
        text.contains("book ticket") ||
        text.contains("book a ticket") ||
        text.contains("ticket book")) {
      return "🎫 Booking flow:\n\n"
          "1️⃣ Search your train\n"
          "2️⃣ Select a train\n"
          "3️⃣ Select coach and seat\n"
          "4️⃣ Add passenger details\n"
          "5️⃣ Continue booking\n\n"
          "Tap Find Train to start.";
    }

    // ----------------------------------------------------------
    // SEAT
    // ----------------------------------------------------------

    if (text.contains("seat") ||
        text.contains("coach") ||
        text.contains("berth")) {
      return "🪑 Seat Selection\n\n"
          "⚪ White = Available\n"
          "🔴 Red = Booked\n"
          "🟢 Green = Selected\n\n"
          "You can select multiple seats and switch between "
          "S1, S2, S3, S4, B1, B2 and A1.";
    }

    // ----------------------------------------------------------
    // PNR
    // ----------------------------------------------------------

    if (text.contains("pnr") ||
        text.contains("ticket status")) {
      return "🎫 PNR Help\n\n"
          "PNR is normally a 10-digit number associated "
          "with your railway booking.\n\n"
          "Live PNR checking will require railway API integration.";
    }

    // ----------------------------------------------------------
    // TATKAL
    // ----------------------------------------------------------

    if (text.contains("tatkal")) {
      return "⚡ Tatkal Help\n\n"
          "Tatkal is a special railway booking quota.\n\n"
          "You can select Tatkal from the Quota option "
          "during train search.";
    }

    // ----------------------------------------------------------
    // CANCELLATION
    // ----------------------------------------------------------

    if (text.contains("cancel") ||
        text.contains("refund")) {
      return "❌ Cancellation & Refund\n\n"
          "Refund depends on ticket type, booking status, "
          "class and cancellation time.\n\n"
          "Live refund calculation will require backend integration.";
    }

    // ----------------------------------------------------------
    // TRAVEL TIPS
    // ----------------------------------------------------------

    if (text.contains("travel tip") ||
        text.contains("tips") ||
        text.contains("advice")) {
      return "💡 Travel Tips\n\n"
          "✅ Carry valid ID proof\n"
          "✅ Keep ticket details accessible\n"
          "✅ Reach the station early\n"
          "✅ Check coach/platform information\n"
          "✅ Keep your belongings safe\n\n"
          "Have a safe journey! 🚆";
    }

    // ----------------------------------------------------------
    // HELP
    // ----------------------------------------------------------

    if (text.contains("help") ||
        text.contains("what can you do") ||
        text.contains("features")) {
      return "🤖 I can help with:\n\n"
          "🚆 Train Search\n"
          "🎫 Booking\n"
          "🪑 Seat Selection\n"
          "📍 Journey Planner\n"
          "🎫 PNR\n"
          "⚡ Tatkal\n"
          "❌ Cancellation\n"
          "💡 Travel Tips";
    }

    // ----------------------------------------------------------
    // GREETING
    // ----------------------------------------------------------

    if (text == "hi" ||
        text == "hello" ||
        text == "hey") {
      return "Hello! 👋\n\n"
          "I'm Ask Disha. Tell me your journey, for example:\n\n"
          "\"Jaipur se Delhi jana hai kal\"";
    }

    return "🤖 I can help you with trains, booking, seats, "
        "journey planning, PNR and travel tips.\n\n"
        "Try:\n"
        "\"Jaipur se Delhi jana hai kal\"";
  }

  // ============================================================
  // QUICK BUTTON
  // ============================================================

  Widget quickButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: const Color(0xFF4D91FF),
        size: 18,
      ),
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF15171C),
        side: const BorderSide(
          color: Color(0xFF2475EE),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
      ),
    );
  }

  void clearChat() {
    setState(() {
      messages.clear();

      messages.add({
        "sender": "ai",
        "message":
            "Chat cleared. 👋\n\nHow can I help you today?"
      });
    });

    scrollToBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A0D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF17181D),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                color: Color(0xFF2475EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ask Disha",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "AI Travel Assistant",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: clearChat,
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 62,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                15,
                10,
                15,
                5,
              ),
              children: [
                quickButton(
                  title: "Find Train",
                  icon: Icons.train_rounded,
                  onTap: () {
                    openSearchWithRoute();
                  },
                ),
                const SizedBox(width: 8),
                quickButton(
                  title: "Journey",
                  icon: Icons.route_rounded,
                  onTap: openJourneyPlanner,
                ),
                const SizedBox(width: 8),
                quickButton(
                  title: "Seat Help",
                  icon: Icons.event_seat_outlined,
                  onTap: () {
                    messageController.text =
                        "How does seat selection work?";
                    sendMessage();
                  },
                ),
                const SizedBox(width: 8),
                quickButton(
                  title: "PNR",
                  icon: Icons.receipt_long_outlined,
                  onTap: () {
                    messageController.text =
                        "How can I check PNR status?";
                    sendMessage();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                15,
              ),
              itemCount:
                  messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping &&
                    index == messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202126),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Disha is typing...",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                }

                final message = messages[index];
                final isUser =
                    message["sender"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width *
                              0.84,
                    ),
                    margin:
                        const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF2475EE)
                          : const Color(0xFF202126),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      message["message"] ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              14,
              10,
              14,
              15,
            ),
            color: const Color(0xFF17181D),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      enabled: !isTyping,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      minLines: 1,
                      maxLines: 4,
                      textInputAction:
                          TextInputAction.send,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText:
                            "Ask Disha anything...",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor:
                            const Color(0xFF292A2F),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Container(
                    decoration: BoxDecoration(
                      color: isTyping
                          ? Colors.grey
                          : const Color(0xFF2475EE),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed:
                          isTyping ? null : sendMessage,
                      icon: Icon(
                        isTyping
                            ? Icons.hourglass_top
                            : Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}