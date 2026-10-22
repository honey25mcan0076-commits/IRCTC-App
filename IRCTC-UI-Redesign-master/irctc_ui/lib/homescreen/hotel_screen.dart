import 'package:flutter/material.dart';

class HotelScreen extends StatefulWidget {
  final String initialCity;

  const HotelScreen({
    super.key,
    this.initialCity = "Jaipur",
  });

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  late TextEditingController cityController;

  DateTime? checkIn;
  DateTime? checkOut;

  int guests = 2;

  final List<Map<String, dynamic>> hotels = [
    {
      "name": "Royal Heritage Hotel",
      "city": "Jaipur",
      "rating": "4.5",
      "price": "₹2,499",
      "location": "MI Road, Jaipur",
      "distance": "2.1 km from Jaipur Junction",
      "amenities": ["Wi-Fi", "Breakfast", "Parking"],
      "status": "AVAILABLE",
    },
    {
      "name": "Pink City Residency",
      "city": "Jaipur",
      "rating": "4.3",
      "price": "₹1,899",
      "location": "Bani Park, Jaipur",
      "distance": "1.4 km from Jaipur Junction",
      "amenities": ["Wi-Fi", "Restaurant", "AC"],
      "status": "AVAILABLE",
    },
    {
      "name": "City Palace Inn",
      "city": "Jaipur",
      "rating": "4.1",
      "price": "₹1,599",
      "location": "Station Road, Jaipur",
      "distance": "0.8 km from Jaipur Junction",
      "amenities": ["Wi-Fi", "AC", "Room Service"],
      "status": "LIMITED ROOMS",
    },
    {
      "name": "Metro Grand Hotel",
      "city": "New Delhi",
      "rating": "4.4",
      "price": "₹2,799",
      "location": "Paharganj, New Delhi",
      "distance": "1.2 km from New Delhi Railway Station",
      "amenities": ["Wi-Fi", "Breakfast", "AC"],
      "status": "AVAILABLE",
    },
    {
      "name": "Capital View Residency",
      "city": "New Delhi",
      "rating": "4.2",
      "price": "₹2,199",
      "location": "Connaught Place, New Delhi",
      "distance": "2.8 km from New Delhi Railway Station",
      "amenities": ["Wi-Fi", "Restaurant", "Parking"],
      "status": "LIMITED ROOMS",
    },
    {
      "name": "Delhi Central Suites",
      "city": "New Delhi",
      "rating": "4.6",
      "price": "₹3,299",
      "location": "Karol Bagh, New Delhi",
      "distance": "2.0 km from New Delhi Railway Station",
      "amenities": ["Wi-Fi", "Breakfast", "Gym"],
      "status": "AVAILABLE",
    },
    {
      "name": "Ahmedabad Palace Stay",
      "city": "Ahmedabad",
      "rating": "4.3",
      "price": "₹1,799",
      "location": "Navrangpura, Ahmedabad",
      "distance": "3.1 km from Ahmedabad Junction",
      "amenities": ["Wi-Fi", "Breakfast", "Parking"],
      "status": "AVAILABLE",
    },
    {
      "name": "Kalyan Comfort Inn",
      "city": "Kalyan",
      "rating": "4.1",
      "price": "₹1,299",
      "location": "Kalyan West",
      "distance": "1.0 km from Kalyan Junction",
      "amenities": ["Wi-Fi", "AC", "Restaurant"],
      "status": "LIMITED ROOMS",
    },
  ];

  @override
  void initState() {
    super.initState();

    cityController = TextEditingController(
      text: widget.initialCity,
    );
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Future<void> selectDate({
    required bool isCheckIn,
  }) async {
    final now = DateTime.now();

    DateTime initialDate;

    if (isCheckIn) {
      initialDate = checkIn ?? now;
    } else {
      initialDate = checkOut ?? checkIn ?? now;
    }

    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: initialDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2475EE),
              surface: Color(0xFF202126),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        checkIn = picked;

        if (checkOut != null &&
            checkOut!.isBefore(picked)) {
          checkOut = null;
        }
      } else {
        checkOut = picked;
      }
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return "Select date";
    }

    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  List<Map<String, dynamic>> get filteredHotels {
    final query =
        cityController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return hotels;
    }

    final result = hotels.where((hotel) {
      final city =
          hotel["city"].toString().toLowerCase();

      final name =
          hotel["name"].toString().toLowerCase();

      final location =
          hotel["location"].toString().toLowerCase();

      return city.contains(query) ||
          name.contains(query) ||
          location.contains(query);
    }).toList();

    if (result.isEmpty) {
      return [];
    }

    return result;
  }

  void searchHotels() {
    FocusScope.of(context).unfocus();

    setState(() {});

    if (filteredHotels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No hotels found for this destination.",
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${filteredHotels.length} hotels found in ${cityController.text}",
        ),
      ),
    );
  }

  Color statusColor(String status) {
    if (status == "AVAILABLE") {
      return Colors.greenAccent;
    }

    return Colors.orangeAccent;
  }

  IconData amenityIcon(String amenity) {
    switch (amenity) {
      case "Wi-Fi":
        return Icons.wifi;

      case "Breakfast":
        return Icons.free_breakfast;

      case "Parking":
        return Icons.local_parking;

      case "Restaurant":
        return Icons.restaurant;

      case "AC":
        return Icons.ac_unit;

      case "Room Service":
        return Icons.room_service;

      case "Gym":
        return Icons.fitness_center;

      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010101),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F24),
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
          "Hotel Finder",
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
              "Find Your Stay",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Comfortable stays near your destination.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            // DESTINATION
            const Text(
              "Destination",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: TextField(
                controller: cityController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText:
                      "City or hotel name",
                  hintStyle:
                      const TextStyle(
                    color: Colors.white38,
                  ),
                  prefixIcon:
                      const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF2475EE),
                  ),
                  suffixIcon:
                      cityController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color:
                                    Colors.white54,
                              ),
                              onPressed: () {
                                cityController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 17,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // DATES
            Row(
              children: [
                Expanded(
                  child: dateBox(
                    title: "CHECK-IN",
                    value: formatDate(checkIn),
                    icon: Icons.login,
                    onTap: () {
                      selectDate(
                        isCheckIn: true,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: dateBox(
                    title: "CHECK-OUT",
                    value: formatDate(checkOut),
                    icon: Icons.logout,
                    onTap: () {
                      if (checkIn == null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select check-in first",
                            ),
                          ),
                        );
                        return;
                      }

                      selectDate(
                        isCheckIn: false,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // GUESTS
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF2475EE,
                      ).withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      color: Color(0xFF2475EE),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 11),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Guests",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Adults",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      if (guests > 1) {
                        setState(() {
                          guests--;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white60,
                    ),
                  ),

                  Text(
                    "$guests",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      if (guests < 8) {
                        setState(() {
                          guests++;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // SEARCH
            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton.icon(
                onPressed: searchHotels,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: const Text(
                  "Search Hotels",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 27),

            // RESULTS HEADER
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Recommended Stays",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (filteredHotels.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF2475EE,
                      ).withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${filteredHotels.length} stays",
                      style: const TextStyle(
                        color: Colors.blueAccent,
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
              cityController.text.isEmpty
                  ? "Popular stays"
                  : "Hotels in ${cityController.text}",
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 14),

            if (filteredHotels.isEmpty)
              emptyHotels()
            else
              ...filteredHotels.map(
                (hotel) => hotelCard(hotel),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dateBox({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1F24),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  icon,
                  color:
                      const Color(0xFF2475EE),
                  size: 18,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    value,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: value ==
                              "Select date"
                          ? Colors.white38
                          : Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget hotelCard(
    Map<String, dynamic> hotel,
  ) {
    final status =
        hotel["status"].toString();

    final List<dynamic> amenities =
        hotel["amenities"] as List<dynamic>;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F24),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // HOTEL ICON
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF2475EE,
                  ).withValues(
                    alpha: 0.11,
                  ),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.apartment_outlined,
                  color: Color(0xFF2475EE),
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel["name"].toString(),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white38,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            hotel["location"]
                                .toString(),
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                const TextStyle(
                              color:
                                  Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 7),

              // RATING
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      hotel["rating"].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // DISTANCE
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.035),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.train_outlined,
                  color: Colors.white54,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    hotel["distance"].toString(),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 11),

          // AMENITIES
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: amenities.map(
              (amenity) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(
                      alpha: 0.04,
                    ),
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        amenityIcon(
                          amenity.toString(),
                        ),
                        color:
                            Colors.white54,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        amenity.toString(),
                        style:
                            const TextStyle(
                          color:
                              Colors.white60,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 14),

          const Divider(
            color: Colors.white10,
            height: 1,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        hotel["price"].toString(),
                        style: const TextStyle(
                          color:
                              Colors.greenAccent,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Padding(
                        padding:
                            EdgeInsets.only(
                          bottom: 2,
                        ),
                        child: Text(
                          "/ night",
                          style: TextStyle(
                            color:
                                Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$guests guest${guests > 1 ? "s" : ""}",
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // STATUS
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor(status)
                      .withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(7),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color:
                        statusColor(status),
                    fontSize: 8,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // VIEW BUTTON
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${hotel["name"]} selected",
                        ),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF2475EE,
                    ),
                    elevation: 0,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 13,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        9,
                      ),
                    ),
                  ),
                  child: const Text(
                    "View",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyHotels() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F24),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.hotel_outlined,
            color: Colors.white30,
            size: 48,
          ),

          SizedBox(height: 12),

          Text(
            "No hotels found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Try another city or hotel name.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}