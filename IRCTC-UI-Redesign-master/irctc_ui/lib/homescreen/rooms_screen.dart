import 'package:flutter/material.dart';

class RoomsScreen extends StatefulWidget {
  final String initialDestination;

  const RoomsScreen({
    super.key,
    this.initialDestination = "All India",
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final TextEditingController searchController = TextEditingController();

  DateTime? checkIn;
  DateTime? checkOut;

  int guests = 2;
  String selectedDestination = "All India";

  final Set<int> favouriteRooms = {};

  final List<String> destinations = [
    "All India",
    "Jaipur",
    "New Delhi",
    "Mumbai",
    "Ahmedabad",
    "Agra",
    "Lucknow",
    "Bhopal",
    "Amritsar",
    "Jammu",
    "Udaipur",
    "Varanasi",
    "Kolkata",
    "Chennai",
    "Bengaluru",
    "Hyderabad",
    "Pune",
    "Goa",
  ];

  final List<Map<String, dynamic>> rooms = [
    {
      "name": "Royal Heritage Room",
      "city": "Jaipur",
      "location": "MI Road, Jaipur",
      "rating": "4.8",
      "price": 2499,
      "type": "Deluxe Room",
      "distance": "2.1 km from Jaipur Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast", "Parking"],
      "icon": Icons.king_bed,
    },
    {
      "name": "Pink City Premium Stay",
      "city": "Jaipur",
      "location": "Bani Park, Jaipur",
      "rating": "4.6",
      "price": 1899,
      "type": "Premium Room",
      "distance": "1.4 km from Jaipur Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.hotel,
    },
    {
      "name": "Capital Grand Room",
      "city": "New Delhi",
      "location": "Connaught Place",
      "rating": "4.7",
      "price": 2799,
      "type": "Executive Room",
      "distance": "2.8 km from New Delhi Railway Station",
      "status": "Limited",
      "amenities": ["Wi-Fi", "AC", "Restaurant", "Parking"],
      "icon": Icons.apartment,
    },
    {
      "name": "Delhi Railway Residency",
      "city": "New Delhi",
      "location": "Paharganj, New Delhi",
      "rating": "4.3",
      "price": 1999,
      "type": "Standard Room",
      "distance": "1.2 km from New Delhi Railway Station",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Room Service"],
      "icon": Icons.bed,
    },
    {
      "name": "Mumbai Central Suites",
      "city": "Mumbai",
      "location": "Mumbai Central",
      "rating": "4.5",
      "price": 3299,
      "type": "Luxury Suite",
      "distance": "0.8 km from Mumbai Central",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast", "Parking"],
      "icon": Icons.king_bed_outlined,
    },
    {
      "name": "Marine City Rooms",
      "city": "Mumbai",
      "location": "Dadar West",
      "rating": "4.2",
      "price": 2199,
      "type": "Deluxe Room",
      "distance": "1.5 km from Dadar Station",
      "status": "Limited",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.hotel_outlined,
    },
    {
      "name": "Ahmedabad Comfort Stay",
      "city": "Ahmedabad",
      "location": "Ashram Road",
      "rating": "4.4",
      "price": 1799,
      "type": "Premium Room",
      "distance": "1.7 km from Ahmedabad Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Parking"],
      "icon": Icons.bedroom_parent,
    },
    {
      "name": "Agra Taj View Rooms",
      "city": "Agra",
      "location": "Fatehabad Road",
      "rating": "4.6",
      "price": 2299,
      "type": "Deluxe Room",
      "distance": "3.2 km from Agra Cantt",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.hotel,
    },
    {
      "name": "Lucknow Nawab Residency",
      "city": "Lucknow",
      "location": "Hazratganj",
      "rating": "4.5",
      "price": 2099,
      "type": "Executive Room",
      "distance": "2.0 km from Lucknow Station",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Restaurant"],
      "icon": Icons.king_bed,
    },
    {
      "name": "Bhopal Lake View Stay",
      "city": "Bhopal",
      "location": "MP Nagar",
      "rating": "4.3",
      "price": 1599,
      "type": "Standard Room",
      "distance": "1.9 km from Bhopal Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Parking"],
      "icon": Icons.hotel_outlined,
    },
    {
      "name": "Golden Temple Residency",
      "city": "Amritsar",
      "location": "Golden Temple Road",
      "rating": "4.7",
      "price": 2399,
      "type": "Premium Room",
      "distance": "1.1 km from Amritsar Junction",
      "status": "Limited",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.king_bed,
    },
    {
      "name": "Jammu Mountain Rooms",
      "city": "Jammu",
      "location": "Rail Head Complex",
      "rating": "4.2",
      "price": 1699,
      "type": "Deluxe Room",
      "distance": "0.9 km from Jammu Tawi",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Parking"],
      "icon": Icons.landscape,
    },
    {
      "name": "Udaipur Lake Palace Stay",
      "city": "Udaipur",
      "location": "Lake Pichola",
      "rating": "4.9",
      "price": 3599,
      "type": "Luxury Suite",
      "distance": "3.5 km from Udaipur Station",
      "status": "Limited",
      "amenities": ["Wi-Fi", "AC", "Breakfast", "Pool"],
      "icon": Icons.king_bed,
    },
    {
      "name": "Varanasi Ganga View Rooms",
      "city": "Varanasi",
      "location": "Assi Ghat",
      "rating": "4.6",
      "price": 2199,
      "type": "Premium Room",
      "distance": "4.1 km from Varanasi Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.water,
    },
    {
      "name": "Kolkata Heritage Rooms",
      "city": "Kolkata",
      "location": "Park Street",
      "rating": "4.4",
      "price": 1999,
      "type": "Executive Room",
      "distance": "2.5 km from Howrah Station",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Restaurant"],
      "icon": Icons.apartment,
    },
    {
      "name": "Chennai Marina Stay",
      "city": "Chennai",
      "location": "T Nagar",
      "rating": "4.3",
      "price": 1899,
      "type": "Deluxe Room",
      "distance": "3.0 km from Chennai Central",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast"],
      "icon": Icons.hotel,
    },
    {
      "name": "Bengaluru Tech Park Rooms",
      "city": "Bengaluru",
      "location": "MG Road",
      "rating": "4.6",
      "price": 2699,
      "type": "Executive Room",
      "distance": "2.3 km from Bengaluru City",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast", "Parking"],
      "icon": Icons.business,
    },
    {
      "name": "Hyderabad Charminar Stay",
      "city": "Hyderabad",
      "location": "Abids",
      "rating": "4.5",
      "price": 1999,
      "type": "Premium Room",
      "distance": "2.7 km from Hyderabad Deccan",
      "status": "Limited",
      "amenities": ["Wi-Fi", "AC", "Restaurant"],
      "icon": Icons.hotel,
    },
    {
      "name": "Pune City Comfort",
      "city": "Pune",
      "location": "Shivajinagar",
      "rating": "4.4",
      "price": 1799,
      "type": "Standard Room",
      "distance": "1.3 km from Pune Junction",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Parking"],
      "icon": Icons.bed,
    },
    {
      "name": "Goa Beachside Rooms",
      "city": "Goa",
      "location": "Calangute",
      "rating": "4.8",
      "price": 2999,
      "type": "Premium Suite",
      "distance": "8.5 km from Madgaon Station",
      "status": "Available",
      "amenities": ["Wi-Fi", "AC", "Breakfast", "Pool"],
      "icon": Icons.beach_access,
    },
  ];

  @override
  void initState() {
    super.initState();

    selectedDestination = widget.initialDestination;

    if (!destinations.contains(selectedDestination)) {
      selectedDestination = "All India";
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredRooms {
    final query = searchController.text.toLowerCase().trim();

    return rooms.where((room) {
      final destinationMatch =
          selectedDestination == "All India" ||
          room["city"] == selectedDestination;

      final searchMatch =
          query.isEmpty ||
          room["name"].toString().toLowerCase().contains(query) ||
          room["city"].toString().toLowerCase().contains(query) ||
          room["location"].toString().toLowerCase().contains(query) ||
          room["type"].toString().toLowerCase().contains(query);

      return destinationMatch && searchMatch;
    }).toList();
  }

  Future<void> selectDate({required bool isCheckIn}) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: isCheckIn
          ? checkIn ?? now
          : checkOut ?? checkIn ?? now,
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

        if (checkOut != null && checkOut!.isBefore(picked)) {
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

  void showRoomDetails(Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17191E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2475EE).withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          room["icon"],
                          color: const Color(0xFF2475EE),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          room["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    room["type"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF2475EE),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          room["location"],
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.train,
                        color: Color(0xFF2475EE),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          room["distance"],
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Room Facilities",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (room["amenities"] as List<String>)
                        .map(
                          (amenity) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF24272E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        room["rating"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₹${room["price"]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        " / night",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${room["name"]} selected for booking",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        "Book This Room",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2475EE),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dateBox({
    required String title,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1F24),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: Color(0xFF2475EE),
              size: 21,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(value),
                    style: TextStyle(
                      color: value == null
                          ? Colors.white54
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roomCard(Map<String, dynamic> room, int index) {
    final isFavourite = favouriteRooms.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1F24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFF2475EE).withValues(
                    alpha: 0.13,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  room["icon"],
                  color: const Color(0xFF2475EE),
                  size: 31,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room["name"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      room["type"],
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF2475EE),
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            room["location"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    if (isFavourite) {
                      favouriteRooms.remove(index);
                    } else {
                      favouriteRooms.add(index);
                    }
                  });
                },
                icon: Icon(
                  isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavourite
                      ? Colors.redAccent
                      : Colors.white54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(
                    alpha: 0.13,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room["rating"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: room["status"] == "Available"
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  room["status"],
                  style: TextStyle(
                    color: room["status"] == "Available"
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                "₹${room["price"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                " /night",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            room["distance"],
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 11),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (room["amenities"] as List<String>)
                .take(3)
                .map(
                  (amenity) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF282B32),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      amenity,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showRoomDetails(room);
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
                  label: const Text("View Room"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Colors.white24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showRoomDetails(room);
                  },
                  icon: const Icon(
                    Icons.bed,
                    size: 18,
                  ),
                  label: const Text("Book"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2475EE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
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

  @override
  Widget build(BuildContext context) {
    final displayedRooms = filteredRooms;

    return Scaffold(
      backgroundColor: const Color(0xFF010101),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1F24),
        elevation: 0,
        title: const Text(
          "Rooms",
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
        actions: [
          IconButton(
            tooltip: "My favourite rooms",
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Favourite rooms are marked with ❤️",
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find a Room 🛏️",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Comfortable rooms near railway stations across India.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Search city, room or location",
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF2475EE),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1D1F24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDestination,
                  dropdownColor: const Color(0xFF202126),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  items: destinations
                      .map(
                        (destination) => DropdownMenuItem<String>(
                          value: destination,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF2475EE),
                                size: 19,
                              ),
                              const SizedBox(width: 10),
                              Text(destination),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedDestination = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: dateBox(
                    title: "Check-in",
                    value: checkIn,
                    onTap: () {
                      selectDate(isCheckIn: true);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: dateBox(
                    title: "Check-out",
                    value: checkOut,
                    onTap: () {
                      if (checkIn == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please select check-in first",
                            ),
                          ),
                        );
                        return;
                      }

                      selectDate(isCheckIn: false);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1F24),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    color: Color(0xFF2475EE),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Guests",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
                      color: Colors.white70,
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
                      if (guests < 10) {
                        setState(() {
                          guests++;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF2475EE),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Text(
                  "Available Rooms",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "${displayedRooms.length} rooms",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            if (displayedRooms.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1F24),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.hotel_outlined,
                      color: Colors.white38,
                      size: 50,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No rooms found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Try another city or search.",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(
                displayedRooms.length,
                (index) => roomCard(
                  displayedRooms[index],
                  rooms.indexOf(displayedRooms[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}