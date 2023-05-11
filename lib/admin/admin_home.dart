import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:trash_it/widgets/widgets.dart';

import '../home/home_screen.dart';
import 'admin_auth/add_emp.dart';
import 'admin_auth/admin_signup.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        drawer: const AdminDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Admin App',
            style: GoogleFonts.merienda(fontSize: 20, color: Colors.white),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
                  Container(
              
                padding:const EdgeInsets.all(8),
                 height: MediaQuery.of(context).size.width/2.5,
                  width: MediaQuery.of(context).size.width-2,
                  decoration:   BoxDecoration(
                     borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.green,
                        blurRadius: 2.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                            0.5, 0.3) 
                        )
                  ],
                    image: const DecorationImage(
                        image: AssetImage('assets/images/user1.png'),
                        fit: BoxFit.fill),
                  ),
     
                ),
           const     SizedBox(height: 30,),
              Button(
                text: 'New Admin',
                icons: Icons.add,
                btncolor: Colors.red.shade300,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminSignUp()));
                }),
            Button(
                text: 'New Employe',
                icons: Icons.add,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewEmploye()));
                }),

                
            Button(
                btncolor: Colors.green,
                text: 'Users',
                icons: Icons.account_circle_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profile(
                                collname: 'users',
                              )));
                }),
            Button(
                btncolor: Colors.orange,
                text: 'Employes',
                icons: Icons.delivery_dining_rounded,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profile(
                                collname: 'employe',
                              )));
                }),
            Button(
                btncolor: Colors.purple,
                text: 'Workers',
                icons: Icons.engineering_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profile(
                                collname: 'worker',
                              )));
                }),
          ],
        ));
  }
}

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
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
          .collection('admin')
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
    return WillPopScope(
      onWillPop: () async {
        return (await onClose(context)) ?? false;
      },
      child: SafeArea(
        child: Drawer(
          width: MediaQuery.of(context).size.width / 1.6,
          backgroundColor: const Color.fromARGB(239, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    style:
                        GoogleFonts.benne(fontSize: 30, color: Colors.purple)),
                accountEmail: Text(userEmail,
                    style:
                        GoogleFonts.benne(fontSize: 20, color: Colors.purple)),
                currentAccountPicture: Container(
                  margin: const EdgeInsets.all(15),
                  height: 2,
                  child: CircleAvatar(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '',
                      style:
                          const TextStyle(fontSize: 30.0, color: Colors.white),
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
                          builder: (context) => const AdminHome()));
                }),
              Button(
                  text: 'New Employe',
                  icons: Icons.add,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddNewEmploye()));
                  }),
              Button(
                  btncolor: Colors.green,
                  text: 'Users',
                  icons: Icons.account_circle_outlined,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile(
                                  collname: 'users',
                                )));
                  }),
              Button(
                  btncolor: Colors.orange,
                  text: 'Employes',
                  icons: Icons.delivery_dining_rounded,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile(
                                  collname: 'employe',
                                )));
                  }),
              Button(
                  btncolor: Colors.purple,
                  text: 'Workers',
                  icons: Icons.engineering_outlined,
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile(
                                  collname: 'worker',
                                )));
                  }),
              Button(
                  btncolor: Colors.redAccent,
                  text: 'Log Out',
                  icons: Icons.logout,
                  onPress: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
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
                                    content: Text('mr.umakanrh@gmail.com'),
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
      ),
    );
  }
}

class Profile extends StatefulWidget {
  final String collname;

  const Profile({Key? key, required this.collname}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _sellStream;
  List<Map<String, dynamic>> data = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> blockUser(String uid) async {
    await _firestore.collection(widget.collname).doc(uid).update({
      'status': 'block',
    });
  }

  Future<void> unblockUser(String uid) async {
    await _firestore.collection(widget.collname).doc(uid).update({
      'status': 'active',
    });
  }

  @override
  void initState() {
    super.initState();
    _sellStream =
        FirebaseFirestore.instance.collection(widget.collname).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _sellStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No items to show'));
            }
            return ListView.builder(
              // reverse: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return ProfileCard(
                    name: doc.data().toString().contains('userName')
                        ? doc.get('userName')
                        : '',
                    gmail: doc.data().toString().contains('userEmail')
                        ? doc.get('userEmail')
                        : '',
                    phone: doc.data().toString().contains('userphone') 
                        ? doc.get('userphone')
                        : '',
                    uid: doc.data().toString().contains('userUID')
                        ? doc.get('userUID')
                        : '',
                    status: doc.data().toString().contains('status')
                        ? doc.get('status')
                        : '',
                    onpressunblock: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure want to Unblock',
                                style: GoogleFonts.alef(fontSize: 32),
                              ),
                              actions: [
                                Button(
                                    btncolor: Colors.red,
                                    text: 'Yes',
                                    icons: Icons.check_circle_outlined,
                                    onPress: () async {
                                      await unblockUser(doc.id);
                                      Navigator.of(context).pop();
                                    }),
                                Button(
                                    btncolor: Colors.blue,
                                    text: 'No',
                                    icons: Icons.highlight_remove_sharp,
                                    onPress: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          });
                    },
                    onpress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure want to Block',
                                style: GoogleFonts.alef(fontSize: 32),
                              ),
                              actions: [
                                Button(
                                    btncolor: Colors.red,
                                    text: 'Yes',
                                    icons: Icons.check_circle_outlined,
                                    onPress: () async {
                                      await blockUser(doc.id);
                                      Navigator.of(context).pop();
                                    }),
                                Button(
                                    btncolor: Colors.blue,
                                    text: 'No',
                                    icons: Icons.highlight_remove_sharp,
                                    onPress: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          });
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
