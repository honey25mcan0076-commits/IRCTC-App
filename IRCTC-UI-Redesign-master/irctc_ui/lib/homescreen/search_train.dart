import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/select_train.dart';

class SearchTrainScreen extends StatefulWidget {
  final String? initialFromCode;
  final String? initialFromName;
  final String? initialToCode;
  final String? initialToName;
  final DateTime? initialDepartureDate;

  const SearchTrainScreen({
    super.key,
    this.initialFromCode,
    this.initialFromName,
    this.initialToCode,
    this.initialToName,
    this.initialDepartureDate,
  });

  @override
  State<SearchTrainScreen> createState() =>
      _SearchTrainScreenState();
}

class _SearchTrainScreenState
    extends State<SearchTrainScreen> {
  late String fromCode;
  late String fromName;

  late String toCode;
  late String toName;

  String selectedClass = "All classes";
  String selectedQuota = "General";

  DateTime? departureDate;
  DateTime? returnDate;

  bool roundTrip = false;
  bool flexibleDate = false;
  bool disabilityConcession = false;

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

  final List<String> classes = [
    "All classes",
    "1A - First AC",
    "2A - Second AC",
    "3A - Third AC",
    "SL - Sleeper",
    "CC - Chair Car",
    "2S - Second Sitting",
  ];

  final List<String> quotas = [
    "General",
    "Ladies",
    "Senior Citizen",
    "Tatkal",
    "Premium Tatkal",
  ];

  @override
  void initState() {
    super.initState();

    fromCode = widget.initialFromCode ?? "KYN";
    fromName = widget.initialFromName ?? "Kalyan Jn";

    toCode = widget.initialToCode ?? "DR";
    toName = widget.initialToName ?? "Dadar";

    departureDate = widget.initialDepartureDate;
  }

  // ============================================================
  // SELECT STATION
  // ============================================================

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
                            "Search station...",
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
                                  12),
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
                      child: ListView.builder(
                        itemCount:
                            filteredStations.length,
                        itemBuilder:
                            (context, index) {
                          final station =
                              filteredStations[
                                  index];

                          return ListTile(
                            leading:
                                CircleAvatar(
                              backgroundColor:
                                  const Color(
                                      0xFF2879F6),
                              child: Text(
                                station["code"]!
                                            .length >=
                                        2
                                    ? station[
                                            "code"]!
                                        .substring(
                                            0, 2)
                                    : station[
                                        "code"]!,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                            title: Text(
                              station["code"]!,
                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              station["name"]!,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                              ),
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
      });
    }
  }

  // ============================================================
  // SWAP
  // ============================================================

  void swapStations() {
    setState(() {
      final tempCode = fromCode;
      final tempName = fromName;

      fromCode = toCode;
      fromName = toName;

      toCode = tempCode;
      toName = tempName;
    });
  }

  // ============================================================
  // DATE
  // ============================================================

  Future<void> selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme:
                const ColorScheme.dark(
              primary: Color(0xFF2879F6),
              surface: Color(0xFF202126),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        departureDate = picked;

        if (returnDate != null &&
            returnDate!.isBefore(
                departureDate!)) {
          returnDate = null;
        }
      });
    }
  }

  Future<void> selectReturnDate() async {
    if (departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please select departure date first"),
        ),
      );
      return;
    }

    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
          returnDate ?? departureDate!,
      firstDate: departureDate!,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme:
                const ColorScheme.dark(
              primary: Color(0xFF2879F6),
              surface: Color(0xFF202126),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return "Choose date";
    }

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // ============================================================
  // SEARCH TRAINS
  // ============================================================

  void searchTrains() {
    if (departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please select departure date"),
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

    if (roundTrip && returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select return date",
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SelectTrainScreen(
          fromCode: fromCode,
          fromName: fromName,
          toCode: toCode,
          toName: toName,
          travelDate:
              formatDate(departureDate),
          selectedClass: selectedClass,
          selectedQuota: selectedQuota,
        ),
      ),
    );
  }

  // ============================================================
  // STATION BOX
  // ============================================================

  Widget stationBox({
    required bool isFrom,
  }) {
    return GestureDetector(
      onTap: () => selectStation(isFrom),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 19,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D34),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    isFrom
                        ? fromCode
                        : toCode,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      isFrom
                          ? fromName
                          : toName,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF8F9095),
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget dropdownBox({
    required String value,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      color: const Color(0xFF292B31),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D34),
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // OPTION
  // ============================================================

  Widget optionRow({
    required String title,
    required bool value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: value
                  ? const Color(0xFF2879F6)
                  : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(7),
              border: Border.all(
                color:
                    const Color(0xFF2879F6),
                width: 2,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
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
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1D1F24),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),
        title: const Text(
          "Search Train",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          35,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF202126),
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      "Journey",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  stationBox(
                    isFrom: true,
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: swapStations,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(0xFF2879F6),
                        shape:
                            BoxShape.circle,
                      ),
                      child:
                          const Icon(
                        Icons.swap_vert,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  stationBox(
                    isFrom: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Class",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            dropdownBox(
              value: selectedClass,
              items: classes,
              onSelected: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),

            const SizedBox(height: 18),

            const Text(
              "Quota",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            dropdownBox(
              value: selectedQuota,
              items: quotas,
              onSelected: (value) {
                setState(() {
                  selectedQuota = value;
                });
              },
            ),

            const SizedBox(height: 18),

            const Text(
              "Departure Date",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: selectDate,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF2B2D34),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color:
                          Colors.white60,
                    ),
                    const SizedBox(
                        width: 12),
                    Text(
                      formatDate(
                          departureDate),
                      style: TextStyle(
                        color:
                            departureDate ==
                                    null
                                ? Colors
                                    .white38
                                : Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            optionRow(
              title: "Round Trip",
              value: roundTrip,
              onTap: () {
                setState(() {
                  roundTrip =
                      !roundTrip;

                  if (!roundTrip) {
                    returnDate = null;
                  }
                });
              },
            ),

            if (roundTrip) ...[
              const SizedBox(height: 15),

              GestureDetector(
                onTap: selectReturnDate,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(18),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(0xFF2B2D34),
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color:
                            Colors.white60,
                      ),
                      const SizedBox(
                          width: 12),
                      Text(
                        formatDate(
                            returnDate),
                        style: TextStyle(
                          color:
                              returnDate ==
                                      null
                                  ? Colors
                                      .white38
                                  : Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            const Text(
              "Options",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            optionRow(
              title:
                  "Flexible with date",
              value: flexibleDate,
              onTap: () {
                setState(() {
                  flexibleDate =
                      !flexibleDate;
                });
              },
            ),

            const SizedBox(height: 14),

            optionRow(
              title:
                  "Disability concession",
              value:
                  disabilityConcession,
              onTap: () {
                setState(() {
                  disabilityConcession =
                      !disabilityConcession;
                });
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: searchTrains,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xFF2879F6),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),
                ),
                child: const Text(
                  "Search Trains",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
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