import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_finder/recipeView.dart';

import './recipeView.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_api.dart';

String currentPageTit = '';
String currentPageIng = '';
String currentPageRec = '';

class Re extends StatefulWidget {
  @override
  Recipes createState() => new Recipes();
}

class Recipes extends State<Re> with AutomaticKeepAliveClientMixin<Re> {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _firstController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  Future<Image> getImage(String request) async {
    PixabayPicker api = PixabayPicker(
        apiKey: '27123464-c543262efa624bc8ea01b275a', language: "en");

    PixabayResponse? res = await api.api?.requestImagesWithKeyword(
        keyword: request, resultsPerPage: 1, page: 1);

    if (res != null && request != '') {
      return Image.network(
        res.hits.toString().substring(1, res.hits.toString().indexOf(' ')),
        fit: BoxFit.cover,
        width: 76,
        height: 76,
      );
    } else {
      return Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png',
        fit: BoxFit.cover,
        width: 76,
        height: 76,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _searchController,
                      onChanged: (String value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: const Icon(CupertinoIcons.plus),
                    onPressed: () {
                      showPopup(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 635,
              child: CupertinoScrollbar(
                controller: _firstController,
                isAlwaysShown: true,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('myRecipes')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("no data");
                    } else {
                      return ListView(
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          var date = DateTime.fromMicrosecondsSinceEpoch(
                              snapshot.data!.docs[index].get('timestamp') *
                                  1000);
                          return recipeItem(
                              context,
                              snapshot.data!.docs[index].get('title'),
                              snapshot.data!.docs[index].get('ingredients'),
                              snapshot.data!.docs[index].get('prereration'),
                              date,
                              snapshot.data!.docs[index].id);
                        }),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recipeItem(BuildContext context, String outputTit, String outputIng,
      String outputRec, DateTime time, String docID) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FutureBuilder(
                  future: getImage(outputTit),
                  builder: (BuildContext context, AsyncSnapshot<Image> image) {
                    if (image.hasData) {
                      return image.data as Widget;
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        outputTit,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        time.toString(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Container(
              width: double.infinity,
              height: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onTap: () {
              print('tapped');
              currentPageTit = outputTit;
              currentPageIng = outputIng;
              currentPageRec = outputRec;
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const RecipeView()),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CupertinoButton(
              child: const Icon(
                CupertinoIcons.trash,
                color: Colors.grey,
              ),
              onPressed: () {
                print('activated');
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Confirm'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('ok'),
                        onPressed: () {
                          Navigator.pop(context, 'ok');
                          FirebaseFirestore.instance
                              .collection('myRecipes')
                              .doc(docID)
                              .delete();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showPopup(BuildContext context) {
    String recipeInputTit = "";
    String recipeInputIng = "";
    String recipeInputPrep = "";
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPopupSurface(
            child: Container(
              padding: const EdgeInsetsDirectional.all(20),
              color: CupertinoColors.white,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).copyWith().size.height * 0.92,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: const Text("Add"),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('myRecipes')
                              .add(<String, dynamic>{
                            'title': recipeInputTit,
                            'ingredients': recipeInputIng,
                            'prereration': recipeInputPrep,
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CupertinoTextField(
                      placeholder: "Recipe Title",
                      onChanged: (String value) {
                        recipeInputTit = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CupertinoTextField(
                      placeholder: "Ingredients",
                      onChanged: (String value) {
                        recipeInputIng = value;
                      },
                      minLines: 5,
                      maxLines: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CupertinoTextField(
                      placeholder: "Preparation",
                      onChanged: (String value) {
                        recipeInputPrep = value;
                      },
                      minLines: 10,
                      maxLines: 20,
                    ),
                  ),
                ],
              ),
            ),
            isSurfacePainted: true,
          );
        });
  }
}
