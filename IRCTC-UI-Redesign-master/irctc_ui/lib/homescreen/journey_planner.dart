import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/hotel_screen.dart';

class JourneyPlannerScreen extends StatefulWidget {
  const JourneyPlannerScreen({super.key});

  @override
  State<JourneyPlannerScreen> createState() =>
      _JourneyPlannerScreenState();
}

class _JourneyPlannerScreenState
    extends State<JourneyPlannerScreen> {
  String fromCode = "JP";
  String fromName = "Jaipur";

  String toCode = "NDLS";
  String toName = "New Delhi";

  DateTime? journeyDate;

  bool showSchedules = false;

  final List<Map<String, String>> stations = [
    {"code": "JP", "name": "Jaipur"},
    {"code": "NDLS", "name": "New Delhi"},
    {"code": "DLI", "name": "Delhi"},
    {"code": "DR", "name": "Dadar"},
    {"code": "KYN", "name": "Kalyan Jn"},
    {"code": "BCT", "name": "Mumbai Central"},
    {"code": "ADI", "name": "Ahmedabad Jn"},
    {"code": "AII", "name": "Ajmer Jn"},
    {"code": "AGC", "name": "Agra Cantt"},
    {"code": "LKO", "name": "Lucknow"},
    {"code": "CNB", "name": "Kanpur Central"},
    {"code": "BPL", "name": "Bhopal Jn"},
    {"code": "JAT", "name": "Jammu Tawi"},
    {"code": "ASR", "name": "Amritsar"},
  ];

  Future<void> selectStation(bool isFrom) async {
    String searchText = "";

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredStations =
                stations.where((station) {
              final code =
                  station["code"]!.toLowerCase();
              final name =
                  station["name"]!.toLowerCase();
              final query =
                  searchText.toLowerCase();

              return code.contains(query) ||
                  name.contains(query);
            }).toList();

            return AlertDialog(
              backgroundColor:
                  const Color(0xFF202126),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20),
              ),
              title: Text(
                isFrom
                    ? "Select From Station"
                    : "Select To Station",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 430,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Search station or code...",
                        hintStyle:
                            const TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon:
                            const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor:
                            const Color(0xFF2B2D34),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          searchText = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child:
                          filteredStations.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No station found",
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      filteredStations
                                          .length,
                                  itemBuilder:
                                      (context,
                                          index) {
                                    final station =
                                        filteredStations[
                                            index];

                                    return ListTile(
                                      contentPadding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 5,
                                      ),
                                      leading:
                                          Container(
                                        width: 45,
                                        height: 45,
                                        alignment:
                                            Alignment
                                                .center,
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                            0xFF2475EE,
                                          ).withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          station[
                                              "code"]!,
                                          style:
                                              const TextStyle(
                                            color: Colors
                                                .blueAccent,
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        station[
                                            "name"]!,
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        station[
                                            "code"]!,
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing:
                                          const Icon(
                                        Icons
                                            .arrow_forward_ios,
                                        color: Colors
                                            .white24,
                                        size: 15,
                                      ),
                                      onTap: () {
                                        Navigator.pop(
                                          dialogContext,
                                          station,
                                        );
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        if (isFrom) {
          fromCode = result["code"]!;
          fromName = result["name"]!;
        } else {
          toCode = result["code"]!;
          toName = result["name"]!;
        }

        showSchedules = false;
      });
    }
  }

  void swapStations() {
    setState(() {
      final oldFromCode = fromCode;
      final oldFromName = fromName;

      fromCode = toCode;
      fromName = toName;

      toCode = oldFromCode;
      toName = oldFromName;

      showSchedules = false;
    });
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: journeyDate ?? now,
      firstDate: now,
      lastDate: DateTime(
        now.year + 1,
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme:
                const ColorScheme.dark(
              primary: Color(0xFF2475EE),
              surface: Color(0xFF202126),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        journeyDate = picked;
        showSchedules = false;
      });
    }
  }

  String get formattedDate {
    if (journeyDate == null) {
      return "Choose journey date";
    }

    return "${journeyDate!.day.toString().padLeft(2, '0')}/"
        "${journeyDate!.month.toString().padLeft(2, '0')}/"
        "${journeyDate!.year}";
  }

  void searchJourney() {
    if (journeyDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select journey date",
          ),
        ),
      );
      return;
    }

    if (fromCode == toCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "From and To stations cannot be same",
          ),
        ),
      );
      return;
    }

    setState(() {
      showSchedules = true;
    });
  }

  void openHotels() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelScreen(
          initialCity: toName,
        ),
      ),
    );
  }

  List<Map<String, String>> get schedules {
    // Jaipur -> New Delhi
    if (fromCode == "JP" &&
        toCode == "NDLS") {
      return [
        {
          "name": "Ajmer Shatabdi",
          "number": "12016",
          "departure": "06:00 AM",
          "arrival": "10:30 AM",
          "duration": "4h 30m",
          "class": "CC / EC",
          "fare": "₹850",
          "status": "AVAILABLE",
        },
        {
          "name": "Rajasthan Double Decker",
          "number": "12985",
          "departure": "05:45 AM",
          "arrival": "10:30 AM",
          "duration": "4h 45m",
          "class": "CC",
          "fare": "₹780",
          "status": "AVAILABLE",
        },
        {
          "name": "Ashram Express",
          "number": "12915",
          "departure": "04:25 PM",
          "arrival": "12:10 AM",
          "duration": "7h 45m",
          "class": "1A / 2A / 3A / SL",
          "fare": "₹590",
          "status": "LIMITED",
        },
        {
          "name": "Rajasthan Sampark Kranti",
          "number": "12463",
          "departure": "08:40 PM",
          "arrival": "04:55 AM",
          "duration": "8h 15m",
          "class": "1A / 2A / 3A / SL",
          "fare": "₹620",
          "status": "FILLING FAST",
        },
      ];
    }

    // New Delhi -> Jaipur
    if (fromCode == "NDLS" &&
        toCode == "JP") {
      return [
        {
          "name": "Ajmer Shatabdi",
          "number": "12015",
          "departure": "04:55 PM",
          "arrival": "10:20 PM",
          "duration": "5h 25m",
          "class": "CC / EC",
          "fare": "₹850",
          "status": "AVAILABLE",
        },
        {
          "name": "Rajasthan Double Decker",
          "number": "12986",
          "departure": "05:35 PM",
          "arrival": "10:40 PM",
          "duration": "5h 05m",
          "class": "CC",
          "fare": "₹780",
          "status": "AVAILABLE",
        },
        {
          "name": "Rajasthan Sampark Kranti",
          "number": "12464",
          "departure": "04:50 PM",
          "arrival": "12:45 AM",
          "duration": "7h 55m",
          "class": "1A / 2A / 3A / SL",
          "fare": "₹620",
          "status": "LIMITED",
        },
      ];
    }

    // Ahmedabad -> Jaipur
    if (fromCode == "ADI" &&
        toCode == "JP") {
      return [
        {
          "name": "Ashram Express",
          "number": "12915",
          "departure": "07:10 PM",
          "arrival": "06:10 AM",
          "duration": "11h",
          "class": "1A / 2A / 3A / SL",
          "fare": "₹720",
          "status": "AVAILABLE",
        },
        {
          "name": "AII Intercity",
          "number": "12981",
          "departure": "06:30 AM",
          "arrival": "05:45 PM",
          "duration": "11h 15m",
          "class": "CC / 2S",
          "fare": "₹610",
          "status": "LIMITED",
        },
      ];
    }

    // Kalyan -> Dadar
    if (fromCode == "KYN" &&
        toCode == "DR") {
      return [
        {
          "name": "Mumbai Local Fast",
          "number": "M-214",
          "departure": "08:10 AM",
          "arrival": "09:05 AM",
          "duration": "55m",
          "class": "1st / 2nd",
          "fare": "₹35",
          "status": "AVAILABLE",
        },
        {
          "name": "Mumbai Local Fast",
          "number": "M-328",
          "departure": "09:25 AM",
          "arrival": "10:20 AM",
          "duration": "55m",
          "class": "1st / 2nd",
          "fare": "₹35",
          "status": "AVAILABLE",
        },
      ];
    }

    // Generic route
    return [
      {
        "name": "Superfast Express",
        "number": "12945",
        "departure": "06:30 AM",
        "arrival": "12:45 PM",
        "duration": "6h 15m",
        "class": "1A / 2A / 3A / SL",
        "fare": "₹680",
        "status": "AVAILABLE",
      },
      {
        "name": "Intercity Express",
        "number": "12401",
        "departure": "10:15 AM",
        "arrival": "04:30 PM",
        "duration": "6h 15m",
        "class": "CC / 2S",
        "fare": "₹490",
        "status": "LIMITED",
      },
      {
        "name": "Night Express",
        "number": "12955",
        "departure": "09:10 PM",
        "arrival": "05:30 AM",
        "duration": "8h 20m",
        "class": "2A / 3A / SL",
        "fare": "₹610",
        "status": "FILLING FAST",
      },
    ];
  }

  Color statusColor(String status) {
    if (status == "AVAILABLE") {
      return Colors.greenAccent;
    }

    if (status == "LIMITED") {
      return Colors.orangeAccent;
    }

    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF010101),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1D1F24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Journey Planner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Plan Your Journey",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Find trains, schedules and stays for your trip.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            // ROUTE CARD
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      stationBox(
                        isFrom: true,
                      ),

                      const SizedBox(height: 12),

                      stationBox(
                        isFrom: false,
                      ),
                    ],
                  ),

                  Positioned(
                    right: 12,
                    top: 48,
                    child: GestureDetector(
                      onTap: swapStations,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF2475EE,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Colors.black45,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_vert,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DATE
            const Text(
              "Journey Date",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            GestureDetector(
              onTap: selectDate,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF1D1F24),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color:
                          Color(0xFF2475EE),
                      size: 21,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: journeyDate ==
                                  null
                              ? Colors.white54
                              : Colors.white,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons
                          .arrow_forward_ios,
                      color: Colors.white38,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // SEARCH BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: searchJourney,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 21,
                ),
                label: const Text(
                  "Search Journey",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2475EE),
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 13),

            // HOTELS
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: openHotels,
                icon: const Icon(
                  Icons.hotel,
                  color:
                      Colors.blueAccent,
                  size: 20,
                ),
                label: const Text(
                  "Find Hotels at Destination",
                  style: TextStyle(
                    color:
                        Colors.blueAccent,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.white12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),

            // SCHEDULE RESULTS
            if (showSchedules) ...[
              const SizedBox(height: 28),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Train Schedules",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color: const Color(
                        0xFF2475EE,
                      ).withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Text(
                      "${schedules.length} trains",
                      style: const TextStyle(
                        color:
                            Colors.blueAccent,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Text(
                "$fromName ($fromCode) → "
                "$toName ($toCode)",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 14),

              ...schedules.map(
                (train) => scheduleCard(train),
              ),
            ],

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget stationBox({
    required bool isFrom,
  }) {
    final code =
        isFrom ? fromCode : toCode;
    final name =
        isFrom ? fromName : toName;

    return GestureDetector(
      onTap: () {
        selectStation(isFrom);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF292B31),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF2475EE,
                ).withValues(
                  alpha: 0.13,
                ),
                borderRadius:
                    BorderRadius.circular(11),
              ),
              child: Icon(
                isFrom
                    ? Icons.location_on_outlined
                    : Icons.flag_outlined,
                color:
                    const Color(0xFF2475EE),
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    isFrom ? "FROM" : "TO",
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    name,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    code,
                    style:
                        const TextStyle(
                      color:
                          Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .keyboard_arrow_down,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget scheduleCard(
    Map<String, String> train,
  ) {
    final status = train["status"]!;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F24),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF2475EE,
                  ).withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.train,
                  color:
                      Color(0xFF2475EE),
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      train["name"]!,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Train ${train["number"]}",
                      style:
                          const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                train["fare"]!,
                style:
                    const TextStyle(
                  color:
                      Colors.greenAccent,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              timeColumn(
                train["departure"]!,
                "Departure",
              ),

              Expanded(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color:
                                Colors.white24,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets
                                  .symmetric(
                            horizontal: 6,
                          ),
                          child: Icon(
                            Icons
                                .arrow_forward,
                            color:
                                Colors.white54,
                            size: 17,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color:
                                Colors.white24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      train["duration"]!,
                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              timeColumn(
                train["arrival"]!,
                "Arrival",
                alignRight: true,
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Colors.white10,
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons
                    .airline_seat_recline_normal,
                color: Colors.white54,
                size: 17,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  train["class"]!,
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color: statusColor(status)
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    7,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color:
                        statusColor(status),
                    fontSize: 9,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget timeColumn(
    String time,
    String label, {
    bool alignRight = false,
  }) {
    return SizedBox(
      width: 78,
      child: Column(
        crossAxisAlignment:
            alignRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style:
                const TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}