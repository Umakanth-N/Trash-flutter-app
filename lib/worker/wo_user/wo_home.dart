import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/worker/wo_user/wo_pick.dart';
import 'package:trash_it/worker/wo_user/wo_task.dart';

import '../../home/home_screen.dart';
import '../../widgets/widgets.dart';
import 'wo_drawer.dart';
import 'wo_order.dart';

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(235, 255, 255, 255),
      // backgroundColor: Colors.black,
      drawer: const WorkerDrawer(),
      appBar: AppBar(
        title: const Text('Worker App'),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(204, 139, 161, 239),
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
        // backgroundColor: const Color.fromARGB(200, 255, 255, 255),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            Wo_PickUp(),
            Home(),
            SellList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // backgroundColor: const Color.fromARGB(166, 242, 171, 171),
          backgroundColor: const Color.fromARGB(204, 139, 161, 239),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromARGB(199, 255, 255, 255),
          // selectedFontSize: 35,
          selectedIconTheme: const IconThemeData(
            size: 28,
            color: Colors.white,
          ),
          selectedItemColor: const Color.fromARGB(255, 131, 9, 125),
          selectedLabelStyle: GoogleFonts.merienda(
            fontSize: 16,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.badge),
              label: '''Pick Up's ''',
              // backgroundColor: Color.fromARGB(203, 241, 231, 143)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              // backgroundColor: Color.fromARGB(175, 255, 255, 255)
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 5,
                child: Icon(
                  Icons.delivery_dining,
                ),
              ),
              label: 'Drop',
              // backgroundColor: Colors.blue,
            ),
          ]),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await onClose(context)) ?? false;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          // padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wor2.png'),
              fit: BoxFit.contain,
              opacity: 0.6,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // margin: EdgeInsets.all(14),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/user1.png'),
                        fit: BoxFit.fitWidth),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                        text: 'Task',
                        icons: Icons.recycling,
                        btncolor: Colors.green,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WorkerTask()));
                        }),
                    // Button(text: 'Sell', icons: Icons.send, onPress: () {}),
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
