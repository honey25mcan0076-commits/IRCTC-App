import 'package:flutter/material.dart';

import '../booking_storage.dart';
import '../notification_controller.dart';
import 'ticket_confirmation.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  // ============================================================
  // LOAD BOOKINGS
  // ============================================================

  Future<void> _loadBookings() async {
    final data = await BookingStorage.getBookings();

    if (!mounted) return;

    setState(() {
      bookings = data;
      isLoading = false;
    });
  }

  // ============================================================
  // CANCEL BOOKING
  // ============================================================

  Future<void> _cancelBooking(
    String pnr,
    String trainName,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Cancel Booking?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel your booking for $trainName?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Cancel Booking"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    // Update booking status
    await BookingStorage.cancelBooking(pnr);

    // Add cancellation notification
    appNotificationController.addNotification(
      icon: Icons.cancel_rounded,
      title: "Booking Cancelled",
      message: "$trainName • PNR $pnr",
      time: "Just now",
      color: Colors.red,
    );

    // Reload bookings
    await _loadBookings();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Booking cancelled successfully",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ============================================================
  // VIEW TICKET
  // ============================================================

  void _viewTicket(
    Map<String, dynamic> booking,
  ) {
    final passengers =
        (booking['passengers'] as List? ?? [])
            .map(
              (item) => Map<String, String>.from(
                item as Map,
              ),
            )
            .toList();

    final selectedSeats = List<String>.from(
      booking['selectedSeats'] ?? [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TicketConfirmationScreen(
          trainName: booking['trainName'] ?? '',
          trainNumber: booking['trainNumber'] ?? '',
          fromCode: booking['fromCode'] ?? '',
          fromName: booking['fromName'] ?? '',
          toCode: booking['toCode'] ?? '',
          toName: booking['toName'] ?? '',
          travelDate: booking['travelDate'] ?? '',
          className: booking['className'] ?? '',
          quota: booking['quota'] ?? '',
          passengers: passengers,
          selectedSeats: selectedSeats,
          pnrNumber: booking['pnr'] ?? '',
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Bookings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return _buildBookingCard(
                        bookings[index],
                      );
                    },
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Bookings Yet",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Your confirmed train bookings will appear here.",
              textAlign: TextAlign.center,
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
  // BOOKING CARD
  // ============================================================

  Widget _buildBookingCard(
    Map<String, dynamic> booking,
  ) {
    final String status =
        booking['status'] ?? 'Confirmed';

    final bool cancelled =
        status == 'Cancelled';

    final String trainName =
        booking['trainName'] ?? 'Train';

    final String trainNumber =
        booking['trainNumber'] ?? '';

    final String fromCode =
        booking['fromCode'] ?? '';

    final String toCode =
        booking['toCode'] ?? '';

    final String fromName =
        booking['fromName'] ?? '';

    final String toName =
        booking['toName'] ?? '';

    final String travelDate =
        booking['travelDate'] ?? '';

    final String className =
        booking['className'] ?? '';

    final String quota =
        booking['quota'] ?? '';

    final String pnr =
        booking['pnr'] ?? '';

    final dynamic fare =
        booking['fare'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ==================================================
            // TRAIN HEADER
            // ==================================================

            Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cancelled
                        ? Colors.red.withValues(
                            alpha: 0.12,
                          )
                        : Colors.green.withValues(
                            alpha: 0.12,
                          ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.train_rounded,
                    color: cancelled
                        ? Colors.red
                        : Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        trainName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        trainNumber,
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cancelled
                        ? Colors.red.withValues(
                            alpha: 0.12,
                          )
                        : Colors.green.withValues(
                            alpha: 0.12,
                          ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: cancelled
                          ? Colors.red
                          : Colors.green,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==================================================
            // ROUTE
            // ==================================================

            Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        fromCode,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        fromName,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.blue,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [

                      Text(
                        toCode,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        toName,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 10),

            // ==================================================
            // DETAILS
            // ==================================================

            _infoRow(
              Icons.calendar_month_rounded,
              "Journey Date",
              travelDate,
            ),

            _infoRow(
              Icons.airline_seat_recline_normal_rounded,
              "Class",
              className,
            ),

            _infoRow(
              Icons.people_alt_rounded,
              "Quota",
              quota,
            ),

            _infoRow(
              Icons.confirmation_number_rounded,
              "PNR",
              pnr,
            ),

            _infoRow(
              Icons.currency_rupee_rounded,
              "Fare",
              "₹$fare",
            ),

            const SizedBox(height: 14),

            // ==================================================
            // BUTTONS
            // ==================================================

            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _viewTicket(booking);
                    },
                    icon: const Icon(
                      Icons.receipt_long_rounded,
                    ),
                    label: const Text(
                      "View Ticket",
                    ),
                  ),
                ),

                if (!cancelled) ...[
                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _cancelBooking(
                          pnr,
                          trainName,
                        );
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                      ),
                      label: const Text(
                        "Cancel",
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red,
                        foregroundColor:
                            Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [

          Icon(
            icon,
            size: 19,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 10),

          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}