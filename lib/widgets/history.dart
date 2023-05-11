import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatefulWidget {
  String subCollection;
  History({super.key, required this.subCollection});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
          .collection(widget.subCollection)
          .where("status", isEqualTo: "Task Complete")
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
      backgroundColor: const Color.fromARGB(244, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'History'
        ),
      ),
      body: data.isNotEmpty
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blue,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                0.4, 0.4) // shadow direction: bottom right
                            )
                      ],
                      color: Colors.white,
                      image: const DecorationImage(
                          image: AssetImage('assets/images/wor2.png'),
                          opacity: 0.4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${doc.containsKey('name') ? doc['name'] : ''}',
                        style: GoogleFonts.merienda(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 255, 81, 7)),
                      ),
                      Text(
                        'Email : ${doc.containsKey('email') ? doc['email'] : ''}',
                        style: GoogleFonts.cabin(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 11, 54, 90),
                        ),
                      ),
                      Text(
                        'Status: Completed',
                        style: GoogleFonts.cabin(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 15, 80, 17)),
                      ),
                      ExpansionTile(
                        title: const Text(
                          'More',
                          textAlign: TextAlign.end,
                        ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        expandedAlignment: Alignment.topLeft,
                        children: <Widget>[
                          Text(
                            'Waste Type : ${doc.containsKey('type') ? doc['type'] : ''}',
                             textAlign: TextAlign.left,
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                                Text(
                            'ID : ${doc.containsKey('docID') ? doc['docID'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                                    Text(
                            'Quantity : ${doc.containsKey('quantity') ? doc['quantity'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                                    Text(
                            'Address : ${doc.containsKey('address') ? doc['address'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                       const   Divider(
                            color: Colors.red,
                          ),
                                    Text(
                            'Worker Name : ${doc.containsKey('workerName') ? doc['workerName'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                                    Text(
                            'Worker ID : ${doc.containsKey('workerId') ? doc['workerId'] : ''}',
                            style: GoogleFonts.cabin(
                              fontSize: 18,
                            ),
                          ),
                        
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: Text('No items to show')),
    );
  }
}
