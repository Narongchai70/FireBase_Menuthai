import 'package:flutter/material.dart';
import 'package:menuthai_firebase/app/data/modle_menu.dart';

class MenuDetailed extends StatelessWidget {
  final ThaiFood food;

  const MenuDetailed({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.menuName), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: food.imageUrl,
              child: Image.network(
                food.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'เมณู: ${food.menuName}',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'เชฟ: ${food.chef.name},',
                    maxLines: 1,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'วัตถุดิบ: ${food.ingredients}',
                    maxLines: 5,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
