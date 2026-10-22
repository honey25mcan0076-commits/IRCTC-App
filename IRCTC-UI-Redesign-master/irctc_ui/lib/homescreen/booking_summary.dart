import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/ticket_confirmation.dart';
import 'package:irctc_ui/notification_controller.dart';
import 'package:irctc_ui/booking_storage.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String trainName;
  final String trainNumber;

  final String fromCode;
  final String fromName;

  final String toCode;
  final String toName;

  final String travelDate;
  final String className;
  final String quota;

  final List<Map<String, String>> passengers;
  final List<String> selectedSeats;

  const BookingSummaryScreen({
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
    required this.passengers,
    required this.selectedSeats,
  });

  // ==============================================================
  // CONFIRM BOOKING
  // ==============================================================

  Future<void> confirmBooking(BuildContext context) async {
    final String generatedPnr =
        "PNR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    // ------------------------------------------------------------
    // SAVE BOOKING
    // ------------------------------------------------------------

    await BookingStorage.addBooking({
      "pnr": generatedPnr,
      "trainName": trainName,
      "trainNumber": trainNumber,
      "fromCode": fromCode,
      "fromName": fromName,
      "toCode": toCode,
      "toName": toName,
      "travelDate": travelDate,
      "className": className,
      "quota": quota,
      "passengers": passengers,
      "selectedSeats": selectedSeats,
      "status": "Confirmed",
      "fare": passengers.length * 485,
      "bookedAt": DateTime.now().toIso8601String(),
    });

    // ------------------------------------------------------------
    // BOOKING NOTIFICATION
    // ------------------------------------------------------------

    appNotificationController.addNotification(
      icon: Icons.confirmation_number_rounded,
      title: "Booking Confirmed",
      message:
          "$trainName • $fromCode → $toCode • PNR $generatedPnr",
      time: "Just now",
      color: Colors.green,
    );

    if (!context.mounted) return;

    // ------------------------------------------------------------
    // OPEN TICKET CONFIRMATION
    // ------------------------------------------------------------

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TicketConfirmationScreen(
          trainName: trainName,
          trainNumber: trainNumber,
          fromCode: fromCode,
          fromName: fromName,
          toCode: toCode,
          toName: toName,
          travelDate: travelDate,
          className: className,
          quota: quota,
          passengers: passengers,
          selectedSeats: selectedSeats,
          pnrNumber: generatedPnr,
        ),
      ),
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final int totalPassengers = passengers.length;
    final int totalFare = totalPassengers * 485;

    return Scaffold(
      backgroundColor: Colors.black,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F24),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Booking Summary",
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

      // ==========================================================
      // BODY
      // ==========================================================

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ========================================================
          // TRAIN CARD
          // ========================================================

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF202126),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [

                const Icon(
                  Icons.train,
                  color: Colors.blueAccent,
                  size: 42,
                ),

                const SizedBox(height: 10),

                Text(
                  trainName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Train No. $trainNumber",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            fromCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            fromName,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.greenAccent,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [

                          Text(
                            toCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            toName,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  "$travelDate • $className • $quota",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ========================================================
          // PASSENGER HEADING
          // ========================================================

          Text(
            "Passengers ($totalPassengers)",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ========================================================
          // PASSENGERS
          // ========================================================

          ...passengers.asMap().entries.map(
            (entry) {
              final int index = entry.key;
              final passenger = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF202126),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              const Color(0xFF2879F6),
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
                          child: Text(
                            passenger["name"] ??
                                "Passenger",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green
                                .withValues(alpha: 0.18),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: Text(
                            passenger["seat"] ??
                                (index <
                                        selectedSeats.length
                                    ? selectedSeats[index]
                                    : "-"),
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    passengerInfo(
                      Icons.cake_outlined,
                      "Age",
                      passenger["age"] ?? "-",
                    ),

                    passengerInfo(
                      Icons.wc,
                      "Gender",
                      passenger["gender"] ?? "-",
                    ),

                    passengerInfo(
                      Icons.airline_seat_recline_normal,
                      "Berth",
                      passenger["berth"] ?? "-",
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // ========================================================
          // FARE
          // ========================================================

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF202126),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Passengers",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    Text(
                      "$totalPassengers",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Fare per passenger",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    Text(
                      "₹485",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const Divider(
                  color: Colors.white24,
                  height: 25,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Total Fare",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "₹$totalFare",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ========================================================
          // CONFIRM BUTTON
          // ========================================================

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                confirmBooking(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2879F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ==============================================================
  // PASSENGER INFO
  // ==============================================================

  Widget passengerInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [

          Icon(
            icon,
            size: 19,
            color: Colors.white54,
          ),

          const SizedBox(width: 10),

          Text(
            "$title: ",
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}