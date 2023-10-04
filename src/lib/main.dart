import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import './home.dart';
import './recipes.dart';
import './tracker.dart';
import './profile.dart';
import './recipeView.dart';
import 'recommender.dart';

// i hate flutter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Recommender recommender = Recommender();
  await recommender.pantryRecommendation([]);
  print(rec1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Cookbook App';

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.wand_stars),
            label: 'Suggestions',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'My Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_pie),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'My Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 1:
                return Re();
              case 2:
                return Tr();
              case 3:
                return Pr();
              default:
                return const Home();
            }
          },
        );
      },
    );
  }
}
