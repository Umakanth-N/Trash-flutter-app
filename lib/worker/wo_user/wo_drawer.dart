import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/worker/wo_user/wo_home.dart';
import 'package:trash_it/worker/wo_user/wo_task.dart';


import '../../home/home_screen.dart';
import '../../widgets/widgets.dart';

class WorkerDrawer extends StatefulWidget {
  const WorkerDrawer({super.key});

  @override
  State<WorkerDrawer> createState() => _WorkerDrawerState();
}

class _WorkerDrawerState extends State<WorkerDrawer> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  Future<void> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get user data from Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('worker')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()!['userName'] ?? '';
          userEmail = snapshot.data()!['userEmail'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      opacity: 0.3,
                      image: AssetImage('assets/images/rec2.png')),
                  color: Colors.white),
              accountName: Text(userName,
                  style: GoogleFonts.benne(fontSize: 30, color: Colors.purple)),
              accountEmail: Text(userEmail,
                  style: GoogleFonts.benne(fontSize: 20, color: Colors.purple)),
              currentAccountPicture: Container(
                margin: const EdgeInsets.all(15),
                height: 2,
                child: CircleAvatar(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '',
                    style: const TextStyle(fontSize: 30.0, color: Colors.white),
                  ),
                ),
              ),
            ),

            Button(
                text: 'Home',
                icons: Icons.mobile_friendly,
                onPress: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkerHome()));
                }),

                
            // Button(
            //     text: 'My Account',
            //     icons: Icons.mobile_friendly,
            //     onPress: () {}),
            Button(
                btncolor: Colors.green,
                text: 'Tasks',
                icons: Icons.account_circle_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkerTask ()));
                }),
            Button(
                btncolor: Colors.redAccent,
                text: 'Log Out',
                icons: Icons.logout,
                onPress: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const HomeScreen()));
                  });
                }),
            BottomAppBar(
              height: 70,
              child: Container(
                color: const Color.fromARGB(255, 191, 124, 211),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('The App Beveloped By Umakanth N'),
                                  content:
                                      Text('The App contains May features'),
                                  actions: [],
                                );
                              });
                        },
                        child: Text(
                          'Developer Contact.?',
                          style: GoogleFonts.benne(
                              fontSize: 15, color: Colors.white),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
