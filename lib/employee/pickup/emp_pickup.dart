// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../../widgets/widgets.dart';

class EmployeePickUp extends StatefulWidget {
  const EmployeePickUp({Key? key}) : super(key: key);

  @override
  State<EmployeePickUp> createState() => _EmployeePickUpState();
}

class _EmployeePickUpState extends State<EmployeePickUp> {
  late List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final FirebaseFirestore firestoreIns = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await firestoreIns.collection("users").get();

    for (final userDoc in userSnapshot.docs) {
      final QuerySnapshot<Map<String, dynamic>> sellSnapshot = await userDoc
          .reference
          .collection("Sell")
          .where("status", isEqualTo: "pending")
          .get();
      for (final sellDoc in sellSnapshot.docs) {
        setState(() {
          data.add(sellDoc.data());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(194, 255, 255, 255),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                return PickUpCard(
                  subcollection: 'Sell',
                  name: doc.containsKey('name') ? doc['name'] : '',
                  gmail: doc.containsKey('email') ? doc['email'] : '',
                  phone: doc.containsKey('phone') ? doc['phone'] : '',
                  quantity: doc.containsKey('quantity') ? doc['quantity'] : '',
                  type: doc.containsKey('type') ? doc['type'] : '',
                  address: doc.containsKey('address') ? doc['address'] : '',
                  status: doc.containsKey('status') ? doc['status'] : '',
                  date: doc.containsKey('dateTime')
                      ? DateFormat.yMd()
                          .add_jm()
                          .format(doc['dateTime'].toDate())
                      : '',
                  docID: doc.containsKey('docID') ? doc['docID'] : '',
                  cuid: doc.containsKey('UID') ? doc['UID'] : '',
                );
              },
            )
          : const Center(child: Text('No items to show')),
    );
  }
}

// ignore: must_be_immutable
class PickUpCard extends StatefulWidget {
  final dynamic name;
  String subcollection;
  dynamic gmail;
  dynamic phone;
  dynamic type;
  dynamic address;
  dynamic quantity;
  dynamic desc;
  dynamic status;
  dynamic date;
  dynamic docID;
  dynamic cuid;
  Widget? drop;

  PickUpCard({
    super.key,
    this.address,
    this.gmail,
    this.docID,
    this.phone,
    this.desc,
    this.status,
    this.date,
    this.cuid,
    required this.subcollection,    
    required this.name,
    required this.quantity,
    required this.type,
  });

  @override
  State<PickUpCard> createState() => _PickUpCardState();
}

class _PickUpCardState extends State<PickUpCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void assignWorker(BuildContext context, String docId) {
    // String selectedWorkerName = '';
    // String selectedWorkerId = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Worker'),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('worker').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              }

              final workers = snapshot.data!.docs;
              final workerNames = <String>[];
              final workerIds = <String>[];

              for (final worker in workers) {
                workerNames.add(worker['userName'].toString());
                workerIds.add(worker['userUID'].toString());
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text(workerNames[index]))),
                    onTap: () async {


                      
                      final usersid = widget.cuid;
                      final sellid = widget.docID;
                      try {
                        final userRef = _firestore
                            .collection('users')
                            .doc(usersid)
                            .collection(widget.subcollection)
                            .doc(sellid);
                        await userRef.update({
                          'status': 'Assigned worker',
                          'workerName': workerNames[index],
                          'workerId': workerIds[
                              index], // replace [worker id] with actual worker id
                        });
                        Navigator.of(context).pop();
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error: $e');
                        }
                      }
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.vertical,
          spacing: 3,
          runSpacing: 5,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.name}',
              style: GoogleFonts.oswald(
                  fontSize: 22, color: const Color.fromARGB(255, 33, 112, 35)),
            ),
            Text(
              'Gmail: ${widget.gmail}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Phone: ${widget.phone}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'UID: ${widget.cuid}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'SID: ${widget.docID}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Type: ${widget.type}',
              style: GoogleFonts.bitter(fontSize: 18, color: Colors.black),
            ),
            Text(
              'Quantity: ${widget.quantity}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Address: ${widget.address}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),

            Text(
              'Date Time: ${widget.date}',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Status: ${widget.status}',
              style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 216, 68, 68),
                  fontWeight: FontWeight.bold),
            ),

            // drop,
            ButtonBar(
              children: [
                Button(
                  text: 'Assign Worker',
                  icons: Icons.edit,
                  onPress: () {
                    assignWorker(context, widget.docID);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}








