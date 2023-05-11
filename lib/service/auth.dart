// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/error_dialog.dart';

//===== Sign Up and adding data to firestore Code ========

void signUpSaveData(dynamic emailController, dynamic passcontroller,
    {required BuildContext context,
    required Widget route,
    // required dynamic saveData,
    required String collName,
    required String role,
    required dynamic nameCont,
    required dynamic subCol_1,
    required dynamic subCol_2,
    required dynamic phonCont}) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passcontroller.text.trim())
      .then((auth) async {
    await saveDataToFirestore(
      collectionName: collName,
      currentUser: auth.user!,
      role: role,
      subColl_1: subCol_1,
      subColl_2: subCol_2,
      phoneCont: phonCont,
      nameCont: nameCont,
      
    );
    Navigator.pop(context);
       showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: 'Use Login Screen to login',
          );
        });
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (c) => route));
  }).catchError((error) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        });
  });
}

//===== Sign Up and adding data to firestore Code(Storing the data) ========
Future<void> saveDataToFirestore(
    {required String collectionName,
    required User currentUser,
    required String role,
    required dynamic subColl_1,
    required dynamic subColl_2,
    required dynamic phoneCont,
    required dynamic nameCont}) async {
  try {
    // create a new user document with userUID, userEmail, userName, and phone fields
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(currentUser.uid)
        .set({
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "userName": nameCont.text.trim(),
      "userphone": phoneCont.text.trim(),
      "role": role,
      "status":'active',
    });

    // add sub-collections "Buy" and "Sell"
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(currentUser.uid)
        .collection(subColl_1)
        .doc()
        .set({});

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(currentUser.uid)
        .collection(subColl_2)
        .doc()
        .set({});

    if (kDebugMode) {
      print("User added to Firestore with sub-collections 'Buy' and 'Sell'.");
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error adding user to Firestore: $error");
    }
  }
}

//=========== Login Authentication ==========

Future<void> loginAuth(BuildContext context,
    {required TextEditingController emailCont,
    required TextEditingController passCont,
    required String collName,
    required String role,
    required Widget route}) async {
  try {
 

    final UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailCont.text, password: passCont.text);

    // Get the currently logged-in user
    final currentUser = user.user!;

    if (user.user != null) {
      final userData = await FirebaseFirestore.instance
          .collection(collName)
          .doc(user.user!.uid)
          .get();
      if (userData.exists) {
        final Map<String, dynamic> data =
            userData.data() as Map<String, dynamic>;
        if (data['role'] == role &&data['status'] == 'active') {
          // Save user data locally
          await saveDataLocally(
            context,
            currentUser,
            collName,
            emailCont,
            role,
          ).then((value) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => route),
            );
          });
        } else {
          Navigator.pop(context); // Close the loading dialog
          showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: 'Invalid role! or Blocked by Admin',
              );
            },
          );
        }
      } else {
        Navigator.pop(context); // Close the loading dialog
        showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: 'User data not found!',
            );
          },
        );
      }
    } else {
      Navigator.pop(context); // Close the loading dialog
      showDialog(
        context: context,
        builder: (c) {
          return const ErrorDialog(
            message: 'Invalid credentials!',
          );
        },
      );
    }
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Close the loading dialog
    showDialog(
      context: context,
      builder: (c) {
        return ErrorDialog(
          message: e.message ?? 'Error signing in!',
        );
      },
    );
  } catch (e) {
    Navigator.pop(context); // Close the loading dialog
    showDialog(
      context: context,
      builder: (c) {
        return const ErrorDialog(
          message: 'An error occurred!',
        );
      },
    );
  }
}

 

Future<void> saveDataLocally(BuildContext context, User currentUser,
    dynamic collName, TextEditingController emailCont, String role,) async {

  // Fetch user data from Firestore based on the user's UID
  final snapshot = await FirebaseFirestore.instance
      .collection(collName)
      .doc(currentUser.uid)
      .get();

  // Store data in SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Store the user ID, email, and username locally using SharedPreferences
  final data = snapshot.data();
  if (data != null) {
    await prefs.setString("useruid", currentUser.uid);
    await prefs.setString('collectionName', collName);
    await prefs.setString('username', data['userName']);
      await prefs.setString('email', emailCont.text);
    await prefs.setString('role', role);
  }
 
}
 