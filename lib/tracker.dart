import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tracker extends StatelessWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.network(
              'https://st.depositphotos.com/1026266/4716/i/950/depositphotos_47167825-stock-photo-business-man-and-woman-sitting.jpg'),
        ),
      ),
    );
  }
}
