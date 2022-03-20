import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'recipes.dart' as recipes;

class RecipeView extends StatelessWidget {
  const RecipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:
          CupertinoNavigationBar(middle: Text(recipes.currentPageTit)),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 5, 0),
              child: Text('Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Text(recipes.currentPageIng),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 5, 0),
              child: Text('Preperation:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Text(recipes.currentPageRec),
            ),
          ],
        ),
      ),
    );
  }
}
