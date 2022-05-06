class Recipe {
  final String? spoonacularSourceUrl;

  Recipe({
    this.spoonacularSourceUrl,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      spoonacularSourceUrl: map['spoonacularSourceUrl'],
    );
  }
}
