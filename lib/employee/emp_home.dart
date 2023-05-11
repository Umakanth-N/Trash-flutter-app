import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/employee/pickup/emp_pickup.dart';

import 'package:trash_it/widgets/widgets.dart';

import '../home/home_screen.dart';
import 'add_worker.dart';
import 'orders/emp_order.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({Key? key}) : super(key: key);

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    EmploHome(),
    EmployeePickUp(),
    EmployeeOrders()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await onClose(context)) ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        drawer: const EmployeDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Employee'),
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
          backgroundColor: const Color.fromARGB(255, 39, 176, 146),
        ),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 39, 176, 146),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: 'Pick Up',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining),
              label: 'Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class EmployeDrawer extends StatefulWidget {
  const EmployeDrawer({super.key});

  @override
  State<EmployeDrawer> createState() => _EmployeDrawerState();
}

class _EmployeDrawerState extends State<EmployeDrawer> {
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
          .collection('employe')
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
                          builder: (context) => const EmployeeHome()));
                }),
            Button(
                btncolor: Colors.green,
                text: 'Add Workr',
                icons: Icons.account_circle_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewWorker()));
                }),
            // Button(
            //     btncolor: Colors.orange,
            //     text: 'My Sellings',
            //     icons: Icons.delivery_dining_rounded,
            //     onPress: () {
            //       // Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(
            //       //         builder: (context) => const Sell()));
            //     }),
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
                                  title: Text('Umakanth N'),
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

class EmploHome extends StatefulWidget {
  const EmploHome({super.key});

  @override
  State<EmploHome> createState() => _EmploHomeState();
}

class _EmploHomeState extends State<EmploHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
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
                image: AssetImage('assets/images/user1.png'), fit: BoxFit.fill),
          ),
        ),
      ],
    ));
  }
}
