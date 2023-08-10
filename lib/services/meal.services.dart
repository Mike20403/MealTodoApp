import 'package:firebase_database/firebase_database.dart';
import 'package:flutterproject/modals/meal.dart';

class MealService {
  List<Meal> meals = [];
  final DatabaseReference _mealRef =
  FirebaseDatabase.instance.ref('/meals');

  Future<void> addMeal(Meal meal) async {
    await _mealRef.child(meal.id.toString()).set(meal.toJson());
  }

  Future<void> updateMeal(String key, Meal meal) async {
    await _mealRef.child(key).update(meal.toJson());
  }

  Future<void> deleteMeal(String key) async {
    await _mealRef.child(key).remove();
  }
  Future<DatabaseEvent> fetchMeal() async {

   return  await _mealRef.once();


  }
  Stream<DatabaseEvent> getMealStream() {
    return _mealRef.onValue;
  }
}