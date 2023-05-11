import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:trash_it/widgets/widgets.dart';

import '../../home/home_screen.dart';

class WorkerTask extends StatefulWidget {
  const WorkerTask({Key? key}) : super(key: key);

  @override
  State<WorkerTask> createState() => _WorkerTaskState();
}

class _WorkerTaskState extends State<WorkerTask> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    // EmployeePickUp(),
    WorkerTaskView(collname: 'Sell'),
    WorkerTaskView(collname: 'Buy'),
    //  WorkerTaskView(collname: 'Buy',),
    // EmployeeOrders()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(235, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Worker App'),
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
        backgroundColor: const Color.fromARGB(204, 139, 161, 239),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(204, 139, 161, 239),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'Pick Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining_rounded),
            label: 'Orders',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class WorkerTaskView extends StatefulWidget {
  final String collname;
  const WorkerTaskView({super.key, required this.collname});

  @override
  State<WorkerTaskView> createState() => _WorkerTaskViewState();
}

class _WorkerTaskViewState extends State<WorkerTaskView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<void> TaskCompleate(String uid) async {
    await _firestore.collection(widget.collname).doc(uid).update({
      'status': 'Task Complete',
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? workerId = user?.uid;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/trash.jpg'),
            fit: BoxFit.contain,
            opacity: 0.3,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collectionGroup(widget.collname)
              .where('workerId', isEqualTo: workerId)
              .where('status', isEqualTo: 'Worker Arriving')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }

            final sellList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: sellList.length,
              itemBuilder: (BuildContext context, int index) {
                final sell = sellList[index];
                final Map<String, dynamic>? data =
                    sell.data() as Map<String, dynamic>?;
                if (data == null) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                    title: Text('Name: ${data['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${data['phone']}'),
                        Text('Type: ${data['type']}'),
                        Text('Worker: ${data['workerName']}'),
                        Text('Address: ${data['address']}'),
                        Text('Quantity: ${data['quantity']}'),
                        const Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Button(
                                text: 'Task Compleate',
                                icons: Icons.gps_fixed,
                                onPress: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Are you sure want to add to task.!',
                                            style:
                                                GoogleFonts.alef(fontSize: 32),
                                          ),
                                          actions: [
                                            Button(
                                                btncolor: Colors.red,
                                                text: 'Yes',
                                                icons:
                                                    Icons.check_circle_outlined,
                                                onPress: () async {
                                                  await sell.reference.update({
                                                    'status': 'Task Complete',
                                                  });

                                                  Navigator.of(context).pop();
                                                }),
                                            Button(
                                                btncolor: Colors.blue,
                                                text: 'No',
                                                icons: Icons
                                                    .highlight_remove_sharp,
                                                onPress: () {
                                                  Navigator.of(context).pop();
                                                })
                                          ],
                                        );
                                      });
                                }),
                            Button(
                                text: 'Open Map',
                                icons: Icons.gps_fixed,
                                onPress: () {
                                  openMap(data['lat'], data['lng'], context);
                         
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
