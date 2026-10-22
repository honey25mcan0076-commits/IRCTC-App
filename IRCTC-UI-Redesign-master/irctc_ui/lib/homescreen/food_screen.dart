// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String selectedStation = "All Stations";
  String selectedCategory = "All";
  String searchText = "";

  final List<String> stations = [
    "All Stations",
    "Jaipur",
    "New Delhi",
    "Mumbai",
    "Ahmedabad",
    "Bengaluru",
    "Kolkata",
    "Chennai",
    "Lucknow",
    "Bhopal",
    "Amritsar",
    "Agra",
  ];

  final List<String> categories = [
    "All",
    "Veg",
    "Non-Veg",
    "Snacks",
    "Beverages",
  ];

  final List<Map<String, dynamic>> foodItems = [
    {
      "name": "North Indian Thali",
      "restaurant": "Rail Food Express",
      "station": "Jaipur",
      "category": "Veg",
      "price": 189,
      "rating": 4.6,
      "time": "25-30 min",
      "icon": Icons.restaurant,
    },
    {
      "name": "Paneer Butter Masala",
      "restaurant": "Taste Junction",
      "station": "New Delhi",
      "category": "Veg",
      "price": 179,
      "rating": 4.5,
      "time": "30-35 min",
      "icon": Icons.ramen_dining,
    },
    {
      "name": "Chicken Biryani",
      "restaurant": "Biryani Station",
      "station": "Hyderabad",
      "category": "Non-Veg",
      "price": 229,
      "rating": 4.7,
      "time": "30-40 min",
      "icon": Icons.lunch_dining,
    },
    {
      "name": "Veg Biryani",
      "restaurant": "Food Junction",
      "station": "Lucknow",
      "category": "Veg",
      "price": 169,
      "rating": 4.4,
      "time": "25-30 min",
      "icon": Icons.rice_bowl,
    },
    {
      "name": "Masala Dosa",
      "restaurant": "South Express",
      "station": "Bengaluru",
      "category": "Veg",
      "price": 129,
      "rating": 4.5,
      "time": "20-25 min",
      "icon": Icons.breakfast_dining,
    },
    {
      "name": "Rajma Rice",
      "restaurant": "Delhi Rasoi",
      "station": "New Delhi",
      "category": "Veg",
      "price": 149,
      "rating": 4.3,
      "time": "20-30 min",
      "icon": Icons.rice_bowl,
    },
    {
      "name": "Chole Bhature",
      "restaurant": "Punjab Junction",
      "station": "Amritsar",
      "category": "Veg",
      "price": 139,
      "rating": 4.6,
      "time": "20-25 min",
      "icon": Icons.restaurant_menu,
    },
    {
      "name": "Paneer Tikka",
      "restaurant": "Royal Kitchen",
      "station": "Agra",
      "category": "Veg",
      "price": 199,
      "rating": 4.5,
      "time": "25-30 min",
      "icon": Icons.kebab_dining,
    },
    {
      "name": "Veg Sandwich",
      "restaurant": "Quick Bites",
      "station": "Mumbai",
      "category": "Snacks",
      "price": 99,
      "rating": 4.2,
      "time": "15-20 min",
      "icon": Icons.lunch_dining,
    },
    {
      "name": "Chicken Roll",
      "restaurant": "Kolkata Rolls",
      "station": "Kolkata",
      "category": "Non-Veg",
      "price": 149,
      "rating": 4.4,
      "time": "20-25 min",
      "icon": Icons.fastfood,
    },
    {
      "name": "Gujarati Thali",
      "restaurant": "Ahmedabad Rasoi",
      "station": "Ahmedabad",
      "category": "Veg",
      "price": 199,
      "rating": 4.7,
      "time": "30-35 min",
      "icon": Icons.restaurant,
    },
    {
      "name": "Idli Sambar",
      "restaurant": "South Indian Hub",
      "station": "Chennai",
      "category": "Veg",
      "price": 109,
      "rating": 4.3,
      "time": "20-25 min",
      "icon": Icons.breakfast_dining,
    },
    {
      "name": "Aloo Paratha",
      "restaurant": "Desi Kitchen",
      "station": "Bhopal",
      "category": "Veg",
      "price": 119,
      "rating": 4.5,
      "time": "20-25 min",
      "icon": Icons.restaurant_menu,
    },
    {
      "name": "Veg Burger",
      "restaurant": "Railway Cafe",
      "station": "Jaipur",
      "category": "Snacks",
      "price": 129,
      "rating": 4.1,
      "time": "15-20 min",
      "icon": Icons.fastfood,
    },
    {
      "name": "Samosa Combo",
      "restaurant": "Station Snacks",
      "station": "New Delhi",
      "category": "Snacks",
      "price": 79,
      "rating": 4.2,
      "time": "10-15 min",
      "icon": Icons.local_dining,
    },
    {
      "name": "Fresh Fruit Juice",
      "restaurant": "Fresh Stop",
      "station": "Mumbai",
      "category": "Beverages",
      "price": 89,
      "rating": 4.3,
      "time": "10-15 min",
      "icon": Icons.local_drink,
    },
    {
      "name": "Cold Coffee",
      "restaurant": "Cafe Express",
      "station": "Jaipur",
      "category": "Beverages",
      "price": 109,
      "rating": 4.4,
      "time": "10-15 min",
      "icon": Icons.coffee,
    },
    {
      "name": "Tea & Snacks",
      "restaurant": "Rail Cafe",
      "station": "Lucknow",
      "category": "Beverages",
      "price": 69,
      "rating": 4.2,
      "time": "10-15 min",
      "icon": Icons.local_cafe,
    },
    {
      "name": "Mughlai Chicken",
      "restaurant": "Royal Mughlai",
      "station": "Agra",
      "category": "Non-Veg",
      "price": 249,
      "rating": 4.6,
      "time": "30-40 min",
      "icon": Icons.dinner_dining,
    },
    {
      "name": "Dal Makhani Combo",
      "restaurant": "Punjabi Kitchen",
      "station": "Amritsar",
      "category": "Veg",
      "price": 179,
      "rating": 4.5,
      "time": "25-30 min",
      "icon": Icons.restaurant,
    },
  ];

  List<Map<String, dynamic>> get filteredFood {
    return foodItems.where((food) {
      final matchesStation = selectedStation == "All Stations" ||
          food["station"] == selectedStation;

      final matchesCategory =
          selectedCategory == "All" || food["category"] == selectedCategory;

      final query = searchText.toLowerCase();

      final matchesSearch = query.isEmpty ||
          food["name"].toString().toLowerCase().contains(query) ||
          food["restaurant"].toString().toLowerCase().contains(query) ||
          food["station"].toString().toLowerCase().contains(query);

      return matchesStation && matchesCategory && matchesSearch;
    }).toList();
  }

  void showFoodDetails(Map<String, dynamic> food) {
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF15171B),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(22, 20, 22, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Color(0xFF22252B),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          food["icon"],
                          color: Color(0xFF3C87F6),
                          size: 34,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food["name"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              food["restaurant"],
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  _detailRow(
                    Icons.location_on_outlined,
                    "Station",
                    food["station"],
                  ),
                  _detailRow(
                    Icons.access_time,
                    "Delivery",
                    food["time"],
                  ),
                  _detailRow(
                    Icons.star,
                    "Rating",
                    "${food["rating"]} / 5",
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF24272D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setModalState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$quantity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${food["name"]} added to your food order",
                            ),
                            backgroundColor: Color(0xFF2475EE),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2475EE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Add to Order • ₹${food["price"] * quantity}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF3C87F6),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            "$title: ",
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = filteredFood;

    return Scaffold(
      backgroundColor: Color(0xFF08090B),
      appBar: AppBar(
        backgroundColor: Color(0xFF111318),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Food on Train",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Your food orders will appear here"),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF191B20),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search food, restaurant or station",
                    hintStyle: TextStyle(
                      color: Colors.white38,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white54,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Station dropdown
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF191B20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStation,
                    isExpanded: true,
                    dropdownColor: Color(0xFF191B20),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    items: stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStation = value!;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Categories
            SizedBox(
              height: 48,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = selectedCategory == category;

                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: Color(0xFF2475EE),
                      backgroundColor: Color(0xFF1A1C21),
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 12),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Text(
                    "${foods.length} food options",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.verified,
                    color: Colors.greenAccent,
                    size: 17,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Verified vendors",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: foods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.no_food_outlined,
                            color: Colors.white30,
                            size: 60,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No food found",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Try another station or category",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        25,
                      ),
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        final food = foods[index];

                        return GestureDetector(
                          onTap: () => showFoodDetails(food),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 13),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color(0xFF15171B),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF22252B),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    food["icon"],
                                    color: Color(0xFF3C87F6),
                                    size: 31,
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              food["name"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "AVAILABLE",
                                              style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        food["restaurant"],
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white38,
                                            size: 14,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            food["station"],
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            "${food["rating"]}",
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Text(
                                            "₹${food["price"]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "• ${food["time"]}",
                                            style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white30,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}