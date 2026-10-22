import 'package:flutter/material.dart';

class LiveTrainStatusScreen extends StatefulWidget {
  const LiveTrainStatusScreen({super.key});

  @override
  State<LiveTrainStatusScreen> createState() =>
      _LiveTrainStatusScreenState();
}

class _LiveTrainStatusScreenState
    extends State<LiveTrainStatusScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedTrain = "12956";

  final List<Map<String, dynamic>> trains = [
    {
      "number": "12956",
      "name": "Jaipur Superfast",
      "from": "Jaipur Jn",
      "to": "Mumbai Central",
      "current": "Ajmer Jn",
      "next": "Beawar",
      "platform": "2",
      "delay": "On Time",
      "delayMinutes": "0 min",
      "progress": 0.38,
      "departure": "14:20",
      "arrival": "06:35",
    },
    {
      "number": "12957",
      "name": "Swarna Jayanti Rajdhani",
      "from": "Ahmedabad Jn",
      "to": "New Delhi",
      "current": "Ajmer Jn",
      "next": "Jaipur Jn",
      "platform": "4",
      "delay": "Delayed",
      "delayMinutes": "8 min",
      "progress": 0.62,
      "departure": "16:40",
      "arrival": "07:10",
    },
    {
      "number": "12916",
      "name": "Ashram Express",
      "from": "Ahmedabad Jn",
      "to": "New Delhi",
      "current": "Gandhinagar",
      "next": "Palanpur",
      "platform": "1",
      "delay": "On Time",
      "delayMinutes": "0 min",
      "progress": 0.28,
      "departure": "18:15",
      "arrival": "09:20",
    },
    {
      "number": "12015",
      "name": "Ajmer Shatabdi",
      "from": "New Delhi",
      "to": "Ajmer Jn",
      "current": "Gurugram",
      "next": "Rewari",
      "platform": "6",
      "delay": "On Time",
      "delayMinutes": "0 min",
      "progress": 0.31,
      "departure": "06:10",
      "arrival": "12:45",
    },
    {
      "number": "12413",
      "name": "Pooja Superfast",
      "from": "Ajmer Jn",
      "to": "Jammu Tawi",
      "current": "Jaipur Jn",
      "next": "Gandhinagar",
      "platform": "3",
      "delay": "Delayed",
      "delayMinutes": "12 min",
      "progress": 0.18,
      "departure": "15:00",
      "arrival": "08:25",
    },
  ];

  Map<String, dynamic> get currentTrain {
    return trains.firstWhere(
      (train) => train["number"] == selectedTrain,
      orElse: () => trains.first,
    );
  }

  List<Map<String, dynamic>> get filteredTrains {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return trains;
    }

    return trains.where((train) {
      return train["number"]
              .toString()
              .toLowerCase()
              .contains(query) ||
          train["name"]
              .toString()
              .toLowerCase()
              .contains(query) ||
          train["from"]
              .toString()
              .toLowerCase()
              .contains(query) ||
          train["to"]
              .toString()
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void selectTrain(Map<String, dynamic> train) {
    setState(() {
      selectedTrain = train["number"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final train = currentTrain;

    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Live Train Status",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF15171C),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "Search train number or train name",
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF4C92FF),
                    ),
                    suffixIcon:
                        searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white54,
                                ),
                              )
                            : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Selected train header
              Row(
                children: [
                  const Text(
                    "Running status",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.redAccent,
                          size: 7,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "LIVE",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Main train card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF101318),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF2475EE)
                        .withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2475EE)
                                .withValues(alpha: 0.13),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.train_rounded,
                            color: Color(0xFF4C92FF),
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                train["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Train ${train["number"]}",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: train["delay"] == "On Time"
                                ? Colors.green.withValues(alpha: 0.12)
                                : Colors.orange.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(9),
                          ),
                          child: Text(
                            train["delay"],
                            style: TextStyle(
                              color:
                                  train["delay"] == "On Time"
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Route
                    Row(
                      children: [
                        Expanded(
                          child: _station(
                            train["from"],
                            train["departure"],
                            true,
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF4C92FF),
                            size: 22,
                          ),
                        ),
                        Expanded(
                          child: _station(
                            train["to"],
                            train["arrival"],
                            false,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Progress
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2475EE),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 3,
                                color: Colors.white12,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      train["progress"],
                                  child: Container(
                                    height: 3,
                                    color:
                                        const Color(0xFF2475EE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white30,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _infoBox(
                            Icons.location_on_outlined,
                            "Current",
                            train["current"],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _infoBox(
                            Icons.near_me_outlined,
                            "Next",
                            train["next"],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _infoBox(
                            Icons.door_front_door_outlined,
                            "Platform",
                            train["platform"],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.update_rounded,
                            color: Color(0xFF4C92FF),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            train["delay"] == "On Time"
                                ? "Train is running as scheduled"
                                : "Train is ${train["delayMinutes"]} late",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Other trains
              const Text(
                "Other trains",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (filteredTrains.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15171C),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        color: Colors.white30,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No train found",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredTrains.map(
                  (item) => _trainListCard(item),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _station(
    String name,
    String time,
    bool first,
  ) {
    return Column(
      crossAxisAlignment:
          first
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign:
              first ? TextAlign.left : TextAlign.right,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _infoBox(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF17191E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF4C92FF),
            size: 18,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trainListCard(
    Map<String, dynamic> train,
  ) {
    final isSelected =
        selectedTrain == train["number"];

    return GestureDetector(
      onTap: () => selectTrain(train),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF111A29)
              : const Color(0xFF15171C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2475EE)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2475EE)
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.train_rounded,
                color: Color(0xFF4C92FF),
                size: 21,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    train["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${train["number"]}  •  ${train["from"]} → ${train["to"]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: isSelected
                  ? const Color(0xFF4C92FF)
                  : Colors.white24,
              size: isSelected ? 20 : 13,
            ),
          ],
        ),
      ),
    );
  }
}