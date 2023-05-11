// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'user_login.dart';
import 'user_signup.dart';

class UserAuth extends StatelessWidget {
  // Key ULogin;
  const UserAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade200,
          title: const Text('User Auth Screen'),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(
              text: 'User Login',
            ),
            Tab(
              text: 'User SignUP',
            ),
          ]),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
            // color: Color.fromARGB(255, 200, 217, 237),
            child: const TabBarView(children: [
          UserLogin(),
          UserSignUp(),
        ])),
      ),
    );
  }
}

// login(BuildContext context) {
//   FirebaseAuth.instance.currentUser!.then((user) {});
// }
