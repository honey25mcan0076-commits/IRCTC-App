import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/select_seat.dart';

class SelectTrainScreen extends StatefulWidget {
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String travelDate;
  final String selectedClass;
  final String selectedQuota;

  const SelectTrainScreen({
    super.key,
    this.fromCode = "KYN",
    this.fromName = "Kalyan Jn",
    this.toCode = "DR",
    this.toName = "Dadar",
    this.travelDate = "Today",
    this.selectedClass = "All classes",
    this.selectedQuota = "General",
  });

  @override
  State<SelectTrainScreen> createState() =>
      _SelectTrainScreenState();
}

class _SelectTrainScreenState
    extends State<SelectTrainScreen> {
  int selectedTrain = -1;

  List<Map<String, String>> get trains {
    // JAIPUR -> NEW DELHI
    if (widget.fromCode == "JP" &&
        widget.toCode == "NDLS") {
      return [
        {
          "name": "Pink City Express",
          "number": "92011",
          "departure": "06:10 AM",
          "arrival": "10:55 AM",
          "duration": "4h 45m",
          "price": "₹485",
        },
        {
          "name": "Rajasthan City Express",
          "number": "92023",
          "departure": "08:30 AM",
          "arrival": "01:20 PM",
          "duration": "4h 50m",
          "price": "₹520",
        },
        {
          "name": "Jaipur Delhi Superfast",
          "number": "92035",
          "departure": "11:15 AM",
          "arrival": "04:05 PM",
          "duration": "4h 50m",
          "price": "₹545",
        },
        {
          "name": "Royal Rajasthan Express",
          "number": "92047",
          "departure": "04:40 PM",
          "arrival": "09:30 PM",
          "duration": "4h 50m",
          "price": "₹510",
        },
        {
          "name": "Desert Star Express",
          "number": "92059",
          "departure": "09:00 PM",
          "arrival": "01:55 AM",
          "duration": "4h 55m",
          "price": "₹490",
        },
      ];
    }

    // OTHER ROUTES
    return [
      {
        "name": "National Express",
        "number": "93011",
        "departure": "06:10 AM",
        "arrival": "10:55 AM",
        "duration": "4h 45m",
        "price": "₹485",
      },
      {
        "name": "City Superfast",
        "number": "93023",
        "departure": "08:30 AM",
        "arrival": "01:20 PM",
        "duration": "4h 50m",
        "price": "₹520",
      },
      {
        "name": "Intercity Express",
        "number": "93035",
        "departure": "11:15 AM",
        "arrival": "04:05 PM",
        "duration": "4h 50m",
        "price": "₹545",
      },
      {
        "name": "Royal Express",
        "number": "93047",
        "departure": "04:40 PM",
        "arrival": "09:30 PM",
        "duration": "4h 50m",
        "price": "₹510",
      },
      {
        "name": "Night Star Express",
        "number": "93059",
        "departure": "09:00 PM",
        "arrival": "01:55 AM",
        "duration": "4h 55m",
        "price": "₹490",
      },
    ];
  }

  void continueToSeat() {
    if (selectedTrain == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a train first"),
        ),
      );
      return;
    }

    final train = trains[selectedTrain];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSeatScreen(
          trainName: train["name"]!,
          trainNumber: train["number"]!,
          fromCode: widget.fromCode,
          fromName: widget.fromName,
          toCode: widget.toCode,
          toName: widget.toName,
          travelDate: widget.travelDate,
          className: widget.selectedClass,
          quota: widget.selectedQuota,
        ),
      ),
    );
  }

  Widget trainCard(
    int index,
    Map<String, String> train,
  ) {
    final bool selected = selectedTrain == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTrain = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: const Color(0xFF202126),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFF2879F6)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        const Color(0xFF2879F6).withValues(alpha: 0.3),
                    blurRadius: 15,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2879F6),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.train,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        train["name"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Train No. ${train["number"]}",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 28,
                  ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      train["departure"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.fromCode,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    children: [
                      Text(
                        train["duration"]!,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          Container(
                            width: 7,
                            height: 7,
                            decoration:
                                const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white24,
                            ),
                          ),
                          const Icon(
                            Icons.train,
                            color: Colors.white54,
                            size: 17,
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white24,
                            ),
                          ),
                          Container(
                            width: 7,
                            height: 7,
                            decoration:
                                const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      train["arrival"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.toCode,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedClass == "All classes"
                      ? "All Classes"
                      : widget.selectedClass,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                Text(
                  train["price"]!,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F24),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Train",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            color: const Color(0xFF202126),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.fromCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF2879F6),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      widget.toCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  "${widget.fromName} → ${widget.toName}",
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  widget.travelDate,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              10,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${trains.length} Trains Available",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.selectedQuota,
                  style: const TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              itemCount: trains.length,
              itemBuilder: (context, index) {
                return trainCard(
                  index,
                  trains[index],
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            15,
          ),
          color: const Color(0xFF1D1F24),
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: continueToSeat,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2879F6),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              child: Text(
                selectedTrain == -1
                    ? "Select Train"
                    : "Continue to Seat Selection",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}