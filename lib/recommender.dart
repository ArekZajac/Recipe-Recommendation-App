import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_finder/model/meal_model.dart';
import 'dart:convert';
import 'dart:core';

import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../model/meal_plan_model.dart';
import '../model/recipe_model.dart';
import 'main.dart';

class Recommender {
  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY = "58d96d8e6c654ddfb8714f6f9b94598b";

  final Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('myRecipes').snapshots();
  List dataList = [];

  Future<List<String>> createDataset() async {
    await FirebaseFirestore.instance
        .collection('myRecipes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc["ingredients"]);
      });
    });

    List<String> paresedList = [];
    for (var i = 0; i < dataList.length; i++) {
      if (dataList[i].contains("\n")) {
        paresedList = paresedList + const LineSplitter().convert(dataList[i]);
      }
    }

    for (var j = 0; j < paresedList.length; j++) {
      paresedList[j] = paresedList[j].replaceAll(RegExp("\\d"), "");
      paresedList[j] = paresedList[j].trim();
      if (paresedList[j].startsWith('g', 0)) {
        paresedList[j] = paresedList[j].substring(2);
      }
    }

    return paresedList;
  }

  String stringify(List<String> input) {
    return input.join(',');
  }

  pantryRecommendation(List<String> input) async {
    print('triggered!');
    String ings = '';
    await createDataset().then(
      (value) {
        ings = stringify(value);
      },
    );

    Map<String, String> params = {
      'ingredients': ings,
      'number': '3',
      'limitLicense': 'false',
      'ranking': '1',
      'ignorePantry': 'true',
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/findByIngredients',
      params,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      List<dynamic> data = json.decode(response.body);
      // Meal output = Meal.fromMap(data);
      recommendationBuilder(data);
    } catch (err) {
      throw err.toString();
    }
  }

  recommendationBuilder(List<dynamic> input) {
    print('building...');
    rec1.clear();
    rec1.add('${input[0]['title']}');
    rec1.add('${input[0]['image']}');
    rec1.add('${input[0]['id']}');

    rec2.clear();
    rec2.add('${input[1]['title']}');
    rec2.add('${input[1]['image']}');
    rec2.add('${input[1]['id']}');

    rec3.clear();
    rec3.add('${input[2]['title']}');
    rec3.add('${input[2]['image']}');
    rec3.add('${input[2]['id']}');

    // print(rec1);
    // print(rec2);
    // print(rec3);
  }
}
