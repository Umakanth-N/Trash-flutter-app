// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
import 'package:trash_it/home/home_screen.dart';
import 'package:trash_it/widgets/widgets.dart';

import '../admin/admin_home.dart';
import '../employee/emp_home.dart';
import '../users/user_home/user_home.dart';
import '../worker/wo_user/wo_home.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);
 
  @override
  // ignore: library_private_types_in_public_api
  _MySplashScreenState createState() => _MySplashScreenState();
}
class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      //if user is logged in already
      if (firebaseAuth.currentUser != null) {
        String userEmail = firebaseAuth.currentUser!.email!;
        String userUID = firebaseAuth.currentUser!.uid;
        // Query the "users" collection
        var usersSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Query the "workers" collection
        var workersSnapshot = await FirebaseFirestore.instance
            .collection("worker")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Query the "employe" collection
          var employeSnapshot = await FirebaseFirestore.instance
            .collection("employe")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
            // Query the "admins" collection
        var adminsSnapshot = await FirebaseFirestore.instance
            .collection("admin")
            .where("userEmail", isEqualTo: userEmail)
            .where("userUID", isEqualTo: userUID)
            .get();
        // Navigate to the corresponding screen based on the collection that contains the user's document
        if (usersSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const UsersHome()));
        } else if (workersSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const WorkerHome()));
        } else if (employeSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const EmployeeHome()));
        }
         else if (adminsSnapshot.docs.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AdminHome()));
        }
      }
      //if user is NOT logged in already
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // circularProgress(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  "assets/images/rec2.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Trash It",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 32, 122, 18),
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // ignore: duplicate_ignore
  Future<void> checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    _userRole = prefs.getString('userRole');
    if (_userRole == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }

    String collectionName;
    switch (_userRole) {
      case 'admin':
        collectionName = 'admins';
        break;
      case 'worker':
        collectionName = 'workers';
        break;
      case 'user':
      default:
        collectionName = 'users';
        break;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(user.uid)
        .get();
    if (!userDoc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    }
 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        switch (_userRole) {
          case 'admin':
            return const EmployeeHome();
          case 'worker':
            return const WorkerHome();
          case 'user':
          default:
            return const UsersHome();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


