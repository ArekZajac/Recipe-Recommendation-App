import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './model/meal_plan_model.dart';
import './services/api_service.dart';
import 'recommender.dart';
import 'main.dart';

List<dynamic> rec1 = [];
List<dynamic> rec2 = [];
List<dynamic> rec3 = [];

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(rec1);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            suggestionCard(context, rec1[0], NetworkImage(rec1[1])),
            suggestionCard(context, rec2[0], NetworkImage(rec2[1])),
            suggestionCard(context, rec3[0], NetworkImage(rec3[1])),
          ],
        ),
      ),
    );
  }

  Widget suggestionCard(
      BuildContext context, String titleText, NetworkImage coverImage) {
    return CupertinoButton(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                ),
              ],
              image: DecorationImage(image: coverImage, fit: BoxFit.cover),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withAlpha(150),
                  Colors.black.withAlpha(0),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text(
              titleText,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      onPressed: () {
        // showCupertinoDialog(
        //   context: context,
        //   builder: (BuildContext context) => CupertinoAlertDialog(
        //     title: Text(titleText + ' card is clicked.'),
        //     actions: <Widget>[
        //       CupertinoDialogAction(
        //         child: const Text('ok'),
        //         onPressed: () {
        //           Navigator.pop(context, 'ok');
        //         },
        //       ),
        //     ],
        //   ),
        // );

        // recommender.createDataset();
      },
    );
  }
}
