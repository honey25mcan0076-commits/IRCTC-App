import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/booking_summary.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final String trainName;
  final String trainNumber;

  final String fromCode;
  final String fromName;

  final String toCode;
  final String toName;

  final String travelDate;
  final String className;
  final String quota;

  final List<String> selectedSeats;

  const PassengerDetailsScreen({
    super.key,
    required this.trainName,
    required this.trainNumber,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.travelDate,
    required this.className,
    required this.quota,
    required this.selectedSeats,
  });

  @override
  State<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState
    extends State<PassengerDetailsScreen> {
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> ageControllers;

  late List<String> genders;
  late List<String> berthPreferences;

  final List<String> genderOptions = [
    "Male",
    "Female",
    "Other",
  ];

  final List<String> berthOptions = [
    "No Preference",
    "Lower",
    "Middle",
    "Upper",
    "Side Lower",
    "Side Upper",
  ];

  @override
  void initState() {
    super.initState();

    final int passengerCount = widget.selectedSeats.length;

    nameControllers = List.generate(
      passengerCount,
      (_) => TextEditingController(),
    );

    ageControllers = List.generate(
      passengerCount,
      (_) => TextEditingController(),
    );

    genders = List.generate(
      passengerCount,
      (_) => "Male",
    );

    berthPreferences = List.generate(
      passengerCount,
      (_) => "No Preference",
    );
  }

  @override
  void dispose() {
    for (final controller in nameControllers) {
      controller.dispose();
    }

    for (final controller in ageControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void continueToBooking() {
    final List<Map<String, String>> passengers = [];

    for (int i = 0; i < widget.selectedSeats.length; i++) {
      final name = nameControllers[i].text.trim();
      final age = ageControllers[i].text.trim();

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please enter name for Passenger ${i + 1}",
            ),
          ),
        );
        return;
      }

      if (age.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please enter age for Passenger ${i + 1}",
            ),
          ),
        );
        return;
      }

      final int? ageValue = int.tryParse(age);

      if (ageValue == null || ageValue <= 0 || ageValue > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please enter valid age for Passenger ${i + 1}",
            ),
          ),
        );
        return;
      }

      passengers.add({
        "name": name,
        "age": age,
        "gender": genders[i],
        "berth": berthPreferences[i],
        "seat": widget.selectedSeats[i],
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryScreen(
          trainName: widget.trainName,
          trainNumber: widget.trainNumber,
          fromCode: widget.fromCode,
          fromName: widget.fromName,
          toCode: widget.toCode,
          toName: widget.toName,
          travelDate: widget.travelDate,
          className: widget.className,
          quota: widget.quota,
          passengers: passengers,
          selectedSeats: widget.selectedSeats,
        ),
      ),
    );
  }

  Widget passengerCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF202126),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2879F6),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Passenger ${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Seat: ${widget.selectedSeats[index]}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // NAME
          TextField(
            controller: nameControllers[index],
            style: const TextStyle(
              color: Colors.white,
            ),
            textCapitalization:
                TextCapitalization.words,
            decoration: InputDecoration(
              labelText: "Passenger Name",
              labelStyle: const TextStyle(
                color: Colors.white70,
              ),
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.white70,
              ),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // AGE
          TextField(
            controller: ageControllers[index],
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: "Age",
              labelStyle: const TextStyle(
                color: Colors.white70,
              ),
              prefixIcon: const Icon(
                Icons.cake_outlined,
                color: Colors.white70,
              ),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // GENDER
          DropdownButtonFormField<String>(
            initialValue: genders[index],
            dropdownColor: const Color(0xFF303136),
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: "Gender",
              labelStyle: const TextStyle(
                color: Colors.white70,
              ),
              prefixIcon: const Icon(
                Icons.wc,
                color: Colors.white70,
              ),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: genderOptions.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  genders[index] = value;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          // BERTH
          DropdownButtonFormField<String>(
            initialValue: berthPreferences[index],
            dropdownColor: const Color(0xFF303136),
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: "Berth Preference",
              labelStyle: const TextStyle(
                color: Colors.white70,
              ),
              prefixIcon: const Icon(
                Icons.airline_seat_recline_normal,
                color: Colors.white70,
              ),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: berthOptions.map((berth) {
              return DropdownMenuItem(
                value: berth,
                child: Text(berth),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  berthPreferences[index] = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1D1F24),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Passenger Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          // JOURNEY INFO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF18191D),
            child: Column(
              children: [
                Text(
                  "${widget.trainName} (${widget.trainNumber})",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  "${widget.fromName} (${widget.fromCode}) → "
                  "${widget.toName} (${widget.toCode})",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
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

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.selectedSeats.length,
              itemBuilder: (context, index) {
                return passengerCard(index);
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: continueToBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2879F6),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Continue with ${widget.selectedSeats.length} Passenger"
                "${widget.selectedSeats.length > 1 ? 's' : ''}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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