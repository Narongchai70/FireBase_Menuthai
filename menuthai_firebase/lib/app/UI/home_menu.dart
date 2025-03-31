import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menuthai_firebase/app/UI/menu_detailed.dart';
import 'package:menuthai_firebase/app/data/modle_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference menu = FirebaseFirestore.instance.collection(
    'thai_foods',
  );
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  Stream<QuerySnapshot> getMenu() {
    return menu.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เมนูอาหารไทย")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "ค้นหาเมนู...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                searchQuery = '';
                              });
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                  });
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: getMenu(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs =
                        snapshot.data!.docs.where((doc) {
                          final food = doc.data() as Map<String, dynamic>;
                          final menuName =
                              food['menu_name'].toString().toLowerCase();
                          return menuName.contains(searchQuery);
                        }).toList();

                    if (docs.isEmpty) {
                      return const Center(child: Text("ไม่พบเมนูที่ค้นหา"));
                    }

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final foodData =
                            docs[index].data() as Map<String, dynamic>;
                        final food = ThaiFood.fromJson(foodData);

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => MenuDetailed(food: food),
                              ),
                            );
                          },
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${foodData['chef']['name']}',
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey),
                                        ),
                                        Text(
                                          '${foodData['menu_name']}',
                                          maxLines: 2,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.headlineMedium,
                                        ),
                                        Text(
                                          '${foodData['ingredients']}',
                                          maxLines: 3,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Hero(
                                    tag: foodData['image_url'],
                                    child: Image.network(
                                      foodData['image_url'],
                                      fit: BoxFit.cover,
                                      height: 220,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
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
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
