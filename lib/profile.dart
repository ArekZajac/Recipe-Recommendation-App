import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.network(
              'https://c8.alamy.com/comp/2CCC2AK/minimal-3d-rendering-cgi-illustration-white-shiny-balls-spheres-or-globes-against-white-or-grey-studio-background-floating-person-concept-model-2CCC2AK.jpg'),
        ),
      ),
    );
  }
}
