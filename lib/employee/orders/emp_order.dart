import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 

import 'package:intl/intl.dart';

import '../pickup/emp_pickup.dart';

class EmployeeOrders extends StatefulWidget {
  const EmployeeOrders({super.key});

  @override
  State<EmployeeOrders> createState() => _EmployeeOrdersState();
}

class _EmployeeOrdersState extends State<EmployeeOrders> {
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
          .collection("Buy")
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
                  subcollection: 'Buy',
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