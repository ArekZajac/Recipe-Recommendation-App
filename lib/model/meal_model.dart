class Meal {
  final int? id;
  final String? title, imgURL;
  Meal({this.id, this.title, this.imgURL});
  factory Meal.fromMap(Map<String, dynamic> map) {
//Meal object
    return Meal(
      id: map['id'],
      title: map['title'],
      imgURL: 'https://spoonacular.com/recipeImages/' + map['image'],
    );
  }
}
