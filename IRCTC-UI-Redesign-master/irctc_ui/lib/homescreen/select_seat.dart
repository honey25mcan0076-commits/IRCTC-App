import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/passenger_details.dart';

class SelectSeatScreen extends StatefulWidget {
  final String trainName;
  final String trainNumber;

  final String fromCode;
  final String fromName;

  final String toCode;
  final String toName;

  final String travelDate;
  final String className;
  final String quota;

  const SelectSeatScreen({
    super.key,
    this.trainName = "Demo Express",
    this.trainNumber = "92011",
    this.fromCode = "KYN",
    this.fromName = "Kalyan Jn",
    this.toCode = "DR",
    this.toName = "Dadar",
    this.travelDate = "Today",
    this.className = "All classes",
    this.quota = "General",
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen>
    with SingleTickerProviderStateMixin {
  final List<String> coaches = [
    "S1",
    "S2",
    "S3",
    "S4",
    "B1",
    "B2",
    "A1",
  ];

  String selectedCoach = "S1";

  final Map<String, Set<int>> selectedSeats = {};

  late AnimationController animationController;

  final Map<String, Set<int>> bookedSeats = {
    "S1": {2, 5, 8, 13, 17, 21, 26, 31, 38, 44},
    "S2": {1, 4, 9, 15, 20, 24, 29, 34, 41, 47},
    "S3": {3, 6, 11, 16, 22, 27, 32, 36, 43, 48},
    "S4": {2, 7, 12, 18, 23, 28, 33, 39, 42, 46},
    "B1": {1, 5, 10, 14, 19, 25, 30, 35, 40, 45},
    "B2": {4, 8, 13, 17, 21, 26, 31, 37, 43, 48},
    "A1": {2, 6, 11, 15, 22, 27, 33, 38, 42, 47},
  };

  @override
  void initState() {
    super.initState();

    for (final coach in coaches) {
      selectedSeats[coach] = <int>{};
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.92,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Set<int> get currentSelectedSeats {
    return selectedSeats[selectedCoach]!;
  }

  int get totalSelectedSeats {
    int total = 0;

    for (final seats in selectedSeats.values) {
      total += seats.length;
    }

    return total;
  }

  List<String> get allSelectedSeatNames {
    final List<String> result = [];

    for (final coach in coaches) {
      final seats = selectedSeats[coach]!;

      final sortedSeats = seats.toList()..sort();

      for (final seatNumber in sortedSeats) {
        result.add("$coach-$seatNumber");
      }
    }

    return result;
  }

  void toggleSeat(int seatNumber) {
    final bool booked =
        bookedSeats[selectedCoach]?.contains(seatNumber) ?? false;

    if (booked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This seat is already booked"),
          duration: Duration(milliseconds: 900),
        ),
      );
      return;
    }

    setState(() {
      final seats = selectedSeats[selectedCoach]!;

      if (seats.contains(seatNumber)) {
        seats.remove(seatNumber);
      } else {
        if (totalSelectedSeats >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Maximum 6 seats can be selected"),
            ),
          );
          return;
        }

        seats.add(seatNumber);
      }
    });

    animationController.forward(from: 0.92);
  }

  void changeCoach(String coach) {
    setState(() {
      selectedCoach = coach;
    });
  }

  Color seatColor(int seatNumber) {
    if (bookedSeats[selectedCoach]!.contains(seatNumber)) {
      return Colors.red;
    }

    if (currentSelectedSeats.contains(seatNumber)) {
      return Colors.green;
    }

    return Colors.white;
  }

  Color seatTextColor(int seatNumber) {
    if (bookedSeats[selectedCoach]!.contains(seatNumber)) {
      return Colors.white;
    }

    if (currentSelectedSeats.contains(seatNumber)) {
      return Colors.white;
    }

    return Colors.black87;
  }

  Widget seat(int number) {
    final bool selected = currentSelectedSeats.contains(number);

    return GestureDetector(
      onTap: () => toggleSeat(number),
      child: AnimatedScale(
        scale: selected ? 1.10 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: seatColor(number),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Colors.lightGreenAccent : Colors.white24,
              width: selected ? 2.5 : 1,
            ),
            boxShadow: selected
                ? [
                    const BoxShadow(
                      color: Colors.greenAccent,
                      blurRadius: 13,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              "$number",
              style: TextStyle(
                color: seatTextColor(number),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget seatRow(int firstSeat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          seat(firstSeat),
          seat(firstSeat + 1),
          const SizedBox(width: 28),
          seat(firstSeat + 2),
          seat(firstSeat + 3),
        ],
      ),
    );
  }

  Widget legend({
    required Color color,
    required String title,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROCEED TO PASSENGER DETAILS
  // ============================================================

  void proceedToPassengerDetails() {
    if (totalSelectedSeats == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one seat"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerDetailsScreen(
          trainName: widget.trainName,
          trainNumber: widget.trainNumber,
          fromCode: widget.fromCode,
          fromName: widget.fromName,
          toCode: widget.toCode,
          toName: widget.toName,
          travelDate: widget.travelDate,
          className: widget.className,
          quota: widget.quota,
          selectedSeats: allSelectedSeatNames,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F24),
        elevation: 0,
        centerTitle: true,
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
          "Select Seat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // ======================================================
          // TRAIN INFORMATION
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            color: const Color(0xFF202126),
            child: Column(
              children: [
                Text(
                  "${widget.trainName} (${widget.trainNumber})",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.fromName} (${widget.fromCode}) "
                  "→ ${widget.toName} (${widget.toCode})",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${widget.travelDate} • "
                  "${widget.className} • "
                  "${widget.quota}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // COACH LIST
          // ======================================================

          Container(
            height: 72,
            color: const Color(0xFF1D1F24),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              itemCount: coaches.length,
              itemBuilder: (context, index) {
                final coach = coaches[index];

                final selected = selectedCoach == coach;

                return GestureDetector(
                  onTap: () => changeCoach(coach),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 21,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF2879F6)
                          : const Color(0xFF2B2D34),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      coach,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ======================================================
          // LEGEND
          // ======================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            color: const Color(0xFF282B32),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 17,
              runSpacing: 8,
              children: [
                legend(
                  color: Colors.white,
                  title: "Available",
                ),
                legend(
                  color: Colors.red,
                  title: "Booked",
                ),
                legend(
                  color: Colors.green,
                  title: "Selected",
                ),
              ],
            ),
          ),

          // ======================================================
          // SEATS
          // ======================================================

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius: BorderRadius.circular(23),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.train,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "COACH",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (int row = 0; row < 12; row++)
                      seatRow((row * 4) + 1),
                    const SizedBox(height: 12),
                    Text(
                      currentSelectedSeats.isEmpty
                          ? "Select your preferred seat"
                          : "${currentSelectedSeats.length} "
                              "seat(s) selected in "
                              "$selectedCoach",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ==========================================================
      // BOTTOM BUTTON
      // ==========================================================

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
            height: 57,
            child: ElevatedButton(
              onPressed: proceedToPassengerDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2879F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                totalSelectedSeats == 0
                    ? "Select Seat"
                    : "Continue • $totalSelectedSeats Seat(s)",
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