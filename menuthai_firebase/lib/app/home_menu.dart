import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menuthai_firebase/app/data/modle_menu.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  final menuCollection = FirebaseFirestore.instance.collection('thai_foods');
  TextEditingController _searchController = TextEditingController();
  List<ThaiFood> foodList = [];
  List<ThaiFood> originalFoodList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterFoodList(_searchController.text);
    });
    _getMenu();
  }

  Future<void> _getMenu() async {
    final snapshot = await menuCollection.get();
    setState(() {
      foodList =
          snapshot.docs
              .map(
                (doc) => ThaiFood.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
      originalFoodList = List.from(foodList);
    });
  }

  void _filterFoodList(String query) {
    setState(() {
      if (query.isEmpty) {
        foodList = List.from(originalFoodList);
      } else {
        foodList =
            originalFoodList
                .where((food) => food.menuName.contains(query))
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เมนูอาหารไทย')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade500),
                  ),
                  hintText: 'ค้นหาอาหาร',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    final food = foodList[index];
                    return Container(
                      height: 220,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(food.menuName),
                                  Text(food.ingredients),
                                  Text(food.chef.name),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Hero(
                              tag: food.imageUrl,
                              child: Image.network(
                                food.imageUrl,
                                fit: BoxFit.cover,
                                height: 220,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 220,
                                    color: Colors.grey.shade500,
                                    child: const Icon(
                                      Icons.photo_outlined,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 220,
                                    color: Colors.grey.shade500,
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
