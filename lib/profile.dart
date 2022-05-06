import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Pr extends StatefulWidget {
  @override
  Profile createState() => new Profile();
}

class Profile extends State<Pr> with AutomaticKeepAliveClientMixin<Pr> {
  @override
  bool get wantKeepAlive => true;

  bool _switch = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(children: [
            CupertinoTextField(),
            setting(context, "Reminders"),
          ]),
        ),
      ),
    );
  }

  Widget setting(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      trailing: CupertinoSwitch(
        value: _switch,
        onChanged: (bool value) {
          setState(() {
            _switch = value;
          });
        },
      ),
      onTap: () {
        setState(() {
          _switch = !_switch;
        });
      },
    );
  }
}
