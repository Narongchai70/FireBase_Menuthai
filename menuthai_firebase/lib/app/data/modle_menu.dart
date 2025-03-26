class ThaiFood {
  final Chef chef;
  final String menuName;
  final String ingredients;
  final String imageUrl;

  ThaiFood({
    required this.chef,
    required this.menuName,
    required this.ingredients,
    required this.imageUrl,
  });

  factory ThaiFood.fromJson(Map<String, dynamic> json) {
    return ThaiFood(
      chef: Chef.fromJson(json['chef']),
      menuName: json['menu_name'] ?? '',
      ingredients: json['ingredients'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chef': chef.toJson(),
      'menu_name': menuName,
      'ingredients': ingredients,
      'image_url': imageUrl,
    };
  }
}

class Chef {
  final String name;

  Chef({required this.name});

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
