import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

import 'utils.dart';

class Tr extends StatefulWidget {
  @override
  Tracker createState() => new Tracker();
}

class Tracker extends State<Tr> with AutomaticKeepAliveClientMixin<Tr> {
  @override
  bool get wantKeepAlive => true;

  List streakList = [];
  List<Event> eventList = [];

  final Stream<QuerySnapshot> collectionStream =
      FirebaseFirestore.instance.collection('streaks').snapshots();

  getDates() async {
    await FirebaseFirestore.instance
        .collection('streaks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        streakList.add(doc["streak"]);
      });
    });
    // print(streakList);
    streakList = streakList.toSet().toList();
  }

  int getStreak() {
    List dateList = [];
    getDates();
    for (var i = 0; i < streakList.length; i++) {
      var dt = DateTime.fromMillisecondsSinceEpoch(streakList[i]);
      dateList.add("${dt.day}-${dt.month}-${dt.year}");
    }
    int counter = 0;
    DateTime today = DateTime.now();
    if (dateList.contains("${today.day}-${today.month}-${today.year}")) {
      print('yes');
      bool runner = true;
      counter - 0;
      do {
        if (dateList
            .contains("${today.day - counter}-${today.month}-${today.year}")) {
          counter++;
        } else {
          runner = false;
        }
      } while (runner);
    } else {
      return 0;
    }
    return counter;
  }

  List<Event> _getEventsForDay(DateTime day) {
    // return kEvents[day] ?? [];
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    for (var i = 0; i < streakList.length; i++) {
      kEvents.addAll(
        {
          DateTime.fromMillisecondsSinceEpoch(streakList[i]): [
            const Event('Streak'),
          ]
        },
      );
    }
    return kEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            children: [
              Container(
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  eventLoader: _getEventsForDay,
                ),
                width: double.infinity,
                height: 410,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CupertinoButton.filled(
                child: const Text("I Cooked Today"),
                onPressed: () {
                  FirebaseFirestore.instance.collection('streaks').add(
                    <String, dynamic>{
                      'streak': DateTime.now().millisecondsSinceEpoch,
                    },
                  );
                  getDates();
                },
              ),
              const SizedBox(height: 50),
              Text('You\'re on a ' + getStreak().toString() + ' day streak!'),
            ],
          ),
        ),
      ),
    );
  }
}
