// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/users/user_home/user_drawer.dart';
import 'package:trash_it/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../../widgets/error_dialog.dart';
import 'user_home.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _buyStream;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _buyStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Buy")
        .snapshots();
  }

  void deleteBuyData(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Buy")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Buy Screen',
          style: GoogleFonts.merienda(
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const UsersHome()));
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const BuyItem();
              });
        },
        child: Wrap(
          direction: Axis.vertical,
          children: const [
            Icon(Icons.add_circle_outline_outlined),
            Text('Buy')
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _buyStream,
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
              return SellCard(
                name: doc.data().toString().contains('name')
                    ? doc.get('name')
                    : '',
              gmail:  doc.data().toString().contains('email')
                    ? doc.get('email')
                    : '',
                    phone:  doc.data().toString().contains('phone')
                    ? doc.get('phone')
                    : '',
                quantity: doc.data().toString().contains('quantity')
                    ? doc.get('quantity')
                    : '',
                type: doc.data().toString().contains('type')
                    ? doc.get('type')
                    : '',
                date: doc.data().containsKey('dateTime')
                    ? DateFormat.yMd()
                        .add_jm()
                        .format(doc.get('dateTime').toDate())
                    : '',
                          address:  doc.data().toString().contains('address')
                    ? doc.get('address')
                    : '',
                status:
                    doc.data().containsKey('status') ? doc.get('status') : '',
                onpress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Are you sure want to delete',
                            style: GoogleFonts.alef(fontSize: 32),
                          ),
                          actions: [
                            Button(
                                btncolor: Colors.red,
                                text: 'Yes',
                                icons: Icons.check_circle_outlined,
                                onPress: () {
                                  deleteBuyData(doc.id);
                                  Navigator.of(context).pop();
                                }),
                            Button(
                                btncolor: Colors.blue,
                                text: 'No',
                                icons: Icons.highlight_remove_sharp,
                                onPress: () {
                                  // deleteSellData(doc.id);
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BuyItem extends StatefulWidget {
  const BuyItem({super.key});

  @override
  State<BuyItem> createState() => _BuyItemState();
}

class _BuyItemState extends State<BuyItem> {
  String? _buytypeController;
  String? _userCityController;
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();

  TextEditingController locationController = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _deccontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _quntitycontroller = TextEditingController();
  final _sellProduct = GlobalKey<FormState>();
  String completeAddress = "";
  Position? position;
  List<Placemark>? placeMarks;

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied location permission
    } else {
      // Show a circular progress indicator while getting the location

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Hide the progress indicator
      Navigator.pop(context);

      position = newPosition;

      placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placeMarks![0];

      completeAddress =
          '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

      locationController.text = completeAddress;
    }
    Navigator.pop(context);
  }

  Future<void> addSellData() async {
    // Get a reference to the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the current user's UID
    final String uids = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to the user's document
    final DocumentReference userDoc = firestore.collection('users').doc(uids);

    // Create a reference to the subcollection for the user's document
    final CollectionReference subCollection = userDoc.collection('Buy');

    // Generate a unique ID for the subcollection document
    final subDocRef = subCollection.doc();

    final subDocId = subDocRef.id;

    final DateTime now = DateTime.now();
    // Add a new document to the subcollection
    subDocRef.set({
      'UID': uids,
      'name': _namecontroller.text.trim(),
      'email': _emailcontroller.text.trim(),
      'phone': _phonecontroller.text.trim(),
      'type': _buytypeController.toString(),
      'quantity': _quntitycontroller.text.trim(),
      'city': _userCityController.toString(),
      'address': _addresscontroller.text.trim(),
      'description': _deccontroller.text.trim(),
      'status': 'pending',
      'docID': subDocId,
      'dateTime': now,
      "lat": position!.latitude,
      "lng": position!.longitude,
    }).then((value) {
 const ErrorDialog(message: 'Data Added',);
// onlodingDilog(context, 'Data Added ');
      // const LoadingDialog(message: 'Data Added ');
      // if (kDebugMode) {
      //   print(
      //       'Document added to subcollection for user $uids with ID: $subDocId');
      // }
    }).catchError((error) {
      // print('Error adding document to subcollection: $error');
const ErrorDialog(message: 'Data Problem',);
    //  onlodingDilog(context, 'Data Problem ');
    });
    //  Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(247, 199, 230, 232),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 10,
            spacing: 20,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '''Buy Waste's''',
                    style: GoogleFonts.merienda(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      )),
                ],
              ),
              Form(
                key: _sellProduct,
                child: Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 10,
                    spacing: 20,
                    children: <Widget>[
                      //Name
                      TextFieldCustom(
                          controller: _namecontroller,
                          icons: Icons.account_circle,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          boxname: 'Enter Name',
                          boxlable: 'Name'),
                      // Email
                      TextFieldCustom(
                          keyBord: TextInputType.emailAddress,
                          controller: _emailcontroller,
                          icons: Icons.email,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                            FormBuilderValidators.match('@gmail.com',
                                errorText: 'use @gmail.com only')
                          ]),
                          boxname: 'Enter Email',
                          boxlable: 'Email'),

                      // Phone Number
                      TextFieldCustom(
                          controller: _phonecontroller,
                          icons: Icons.phone,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.minLength(10),
                            FormBuilderValidators.maxLength(10)
                          ]),
                          boxname: 'Enter Phone',
                          boxlable: 'Phone'),

                      //  Type
                      SizedBox(
                        width: 150,
                        child: ColoredBox(
                          color: Colors.white,

                          // color: Colors.white,

                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hoverColor: Colors.green,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a type of material';
                              }
                              return null;
                            },
                            hint: const Text('Select Type'),
                            value: _buytypeController,
                            onChanged: (newValue) {
                              setState(() {
                                _buytypeController = newValue;
                              });
                            },
                            items: [
                              'Wet Waste',
                              'Dry Waste',
                              'E-Waste',
                              'Other'
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      //Quantity
                      TextFieldCustom(
                          maxline: 1,
                          keyBord: TextInputType.emailAddress,
                          controller: _quntitycontroller,
                          icons: Icons.scale,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.maxLength(5),
                          ]),
                          boxname: 'Enter Quantity in KG',
                          boxlable: 'Quantity'),
                      // Address
                      TextFieldCustom(
                          maxline: 4,
                          icons: Icons.abc,
                          keyBord: TextInputType.emailAddress,
                          controller: _addresscontroller,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          boxname:
                              '''Ex:House no , Street/area Landmark City, State, Pincode''',
                          boxlable: 'Address'),

                      TextFieldCustom(
                          maxline: 4,
                          keyBord: TextInputType.emailAddress,
                          controller: _deccontroller,
                          icons: Icons.abc,
                          validater: FormBuilderValidators.compose([
                            FormBuilderValidators.maxLength(500),
                          ]),
                          boxname: 'Provide some information',
                          boxlable: 'Description'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ColoredBox(
                              color: Colors.white,

                              // color: Colors.white,

                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    hoverColor: Colors.green,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a type of material';
                                  }
                                  return null;
                                },
                                hint: const Text('Select Type'),
                                value: _userCityController,
                                onChanged: (newValue) {
                                  setState(() {
                                    _userCityController = newValue;
                                  });
                                },
                                items: [
                                  'Ballari',
                                ].map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Button(
                            text: 'Get Location',
                            icons: Icons.location_on,
                            onPress: () {
                              setState(() {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                getCurrentLocation();
                              });
                            },
                          ),
                        ],
                      ),

                      TextFieldCustom(
                        boxname: 'Location',
                        boxlable: 'GPS',
                        icons: Icons.location_searching,
                        controller: locationController,
                        enabled: false,
                        validater: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                    ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                      btncolor: Colors.red,
                      icons: Icons.cancel,
                      text: 'Clear',
                      onPress: () {
                        _namecontroller.text = '';
                        _emailcontroller.text = '';
                        _phonecontroller.text = '';
                        _quntitycontroller.text = '';
                        _deccontroller.text = '';
                        _addresscontroller.text = '';
                      }),
                  Button(
                      btncolor: Colors.green,
                      icons: Icons.add,
                      text: 'Submit',
                      onPress: () {
                        if (_sellProduct.currentState!.validate()) {
                          _sellProduct.currentState!.save();
                          setState(() {
                            addSellData();
                
                          });
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
