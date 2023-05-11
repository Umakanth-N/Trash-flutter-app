import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:trash_it/users/user_home/user_drawer.dart';
import 'package:trash_it/users/user_home/user_sell.dart';

import '../../home/home_screen.dart';
import '../../widgets/widgets.dart';
import 'user_buy.dart';

class UsersHome extends StatefulWidget {
  const UsersHome({super.key});

  @override
  State<UsersHome> createState() => _UsersHomeState();
}

class _UsersHomeState extends State<UsersHome> {
  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await onClose(context)) ?? false;
      },
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(235, 255, 255, 255),

        drawer: const UserDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'User App',
            style: GoogleFonts.merienda(
              fontSize: 30,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const HomeScreen()));
                  });
                },
                icon: const Icon(Icons.logout_rounded))
          ],
          backgroundColor: Colors.green,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/tr1.jpg'),
              fit: BoxFit.contain,
              opacity: 0.6,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.width / 2.5,
                  width: MediaQuery.of(context).size.width - 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.green,
                          blurRadius: 2.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.5, 0.3))
                    ],
                    image: const DecorationImage(
                        image: AssetImage('assets/images/user1.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                        text: 'Buy',
                        icons: Icons.recycling,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Buy()));
                        }),
                    Button(
                        text: 'Sell',
                        icons: Icons.send,
                        btncolor: Colors.green,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Sell()));
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
