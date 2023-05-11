// ignore_for_file: camel_case_types, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/users/user_home/user_home.dart';
import 'package:trash_it/widgets/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

 

import '../../widgets/widgets.dart';

class Wo_PickUp extends StatefulWidget {
  const Wo_PickUp({super.key});

  @override
  State<Wo_PickUp> createState() => _Wo_PickUpState();
}

class _Wo_PickUpState extends State<Wo_PickUp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

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
              .collectionGroup('Sell')
              .where('workerId', isEqualTo: workerId)
                .where('status', isEqualTo: 'Assigned worker')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
      
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
      
            final sellList = snapshot.data!.docs;
            return 
            
            
            ListView.builder(
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
                        Text('Worker: ${data['workerName']}'),
                        Text('Type: ${data['type']}'),
                        Text('Address: ${data['address']}'),
                        Text('Quantity: ${data['quantity']}'),
                        const Divider(
                          thickness: 2.0,
                        ),
                        Button(
                          text: 'Add to Task',
                          icons: Icons.add,
                          onPress: () {
                              showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure want to add to task.!',
                                style: GoogleFonts.alef(fontSize: 32),
                              ),
                              actions: [
                                Button(
                                    btncolor: Colors.red,
                                    text: 'Yes',
                                    icons: Icons.check_circle_outlined,
                                    onPress: () async {
                                         await sell.reference.update({
                  'status': 'Worker Arriving',
                });
                                      // await addtotask(widget.uid);
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
                          btncolor: const Color.fromARGB(255, 60, 181, 64),
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


 

