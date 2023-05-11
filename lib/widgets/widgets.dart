import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'error_dialog.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
  final dynamic validater;
  final String boxlable;
  final String boxname;
  final TextInputType? keyBord;
  final dynamic controller;
  final bool? enabled;
  final IconData icons;
  int? maxline;
  TextFieldCustom(
      {super.key,
      required this.boxlable,
      required this.boxname,
      required this.icons,
      this.controller,
      this.enabled,
      this.keyBord,
      this.maxline,
      this.validater});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxline,
      keyboardType: keyBord,
      controller: controller,
      validator: validater,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        prefixIcon: Icon(icons),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide:
              BorderSide(width: 3.5, color: Colors.white), //<-- SEE HERE
        ),
        label: Text(
          boxlable,
          style: const TextStyle(),
        ),
        hintText: boxname,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(),
        ),
      ),
      // name: boxlable,
    );
  }
}

// ignore: must_be_immutable
class Button extends StatelessWidget {
  String text;
  IconData icons;
  Color? btncolor;
  Color? btxtcolor;
   

  double? fontsize;
  dynamic onPress;
  Button({
    super.key,
    required this.text,
    required this.icons,
    required this.onPress,
 

    this.btncolor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      
        style: ElevatedButton.styleFrom(
               
            shape: const StadiumBorder(), backgroundColor: btncolor),
        icon: Icon(
          icons,
        ),
        label: Text(text,
            style: GoogleFonts.merienda(fontSize: fontsize, color: btxtcolor)),
        onPressed: onPress
     
        );
  }
}

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// ignore: must_be_immutable
class BuyCard extends StatelessWidget {
  final dynamic name;
  dynamic type;
  dynamic address;
  dynamic quantity;
  dynamic desc;
  dynamic status;
  BuyCard(
      {super.key,
      this.address,
      this.desc,
      this.status,
      required this.name,
      required this.quantity,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.vertical,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name: $name',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),

            Text('Type: $type'),
            Text('Quantity: $quantity'),
            Text('Status: $status'),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [

            //   ],
            // ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Address: 123 Main St.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ButtonBar(
              children: [
                Button(
                    btncolor: Colors.green,
                    text: 'Accept',
                    icons: Icons.task_alt,
                    onPress: () {}),
                Button(
                    btncolor: Colors.red,
                    text: 'Ignore',
                    icons: Icons.delete,
                    onPress: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SellCard extends StatelessWidget {
  final dynamic name;
  dynamic gmail;
  dynamic phone;
  dynamic type;
  dynamic address;
  dynamic quantity;
  dynamic desc;
  dynamic status;
  dynamic date;
  Widget? drop;
  late dynamic onpress;

  SellCard({
    super.key,
    this.address,
    this.gmail,
    this.phone,
    this.desc,
    this.status,
    this.date,
    this.drop,
    this.onpress,
    required this.name,
    required this.quantity,
    required this.type,
  });

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
              'Name: $name',
              style: GoogleFonts.oswald(
                  fontSize: 22, color: const Color.fromARGB(255, 33, 112, 35)),
            ),
            Text(
              'Gmail: $gmail',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Phone: $phone',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Type: $type',
              style: GoogleFonts.bitter(fontSize: 18, color: Colors.black),
            ),
            Text(
              'Quantity: $quantity',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Address: $address',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),

            Text(
              'Date Time: $date',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Status: $status',
              style: GoogleFonts.bitter(
                  fontSize: 18,
                  color: const Color.fromARGB(255, 216, 68, 68),
                  fontWeight: FontWeight.bold),
            ),

            // drop,
            ButtonBar(
              children: [
                // Button(text: 'Edit', icons: Icons.edit, onPress: () {}),
                Button(
                  btncolor: Colors.red,
                  text: 'Delete',
                  icons: Icons.delete,
                  onPress: onpress,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProfileCard extends StatelessWidget {
  final dynamic name;
  dynamic gmail;
  dynamic phone;
  dynamic uid;
  dynamic status;
  late dynamic onpress;
    late dynamic onpressunblock;

  ProfileCard({
    super.key,
    this.gmail,
    this.phone,
    this.status,
    this.onpress,
    this.onpressunblock,
    this.uid,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // direction: Axis.vertical,
          // spacing: 3,
          // runSpacing: 5,
          crossAxisAlignment: CrossAxisAlignment. start,
          children: [
            Text(
              'Name: $name',
              style: GoogleFonts.oswald(
                  fontSize: 22, color: const Color.fromARGB(255, 33, 112, 35)),
            ),
            Text(
              'Gmail: $gmail',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Phone: $phone',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
              Text(
              'Account Status: $status',
              style: GoogleFonts.bitter(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'ID:- $uid',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.bitter(fontSize: 18, color: Colors.black),
            ),

            // drop,
            ButtonBar(
              children: [
                Button(text: 'Unblock', icons: Icons.edit, onPress: onpressunblock),
                Button(
                  btncolor: Colors.red,
                  text: 'Block',
                  icons: Icons.delete,
                  onPress: onpress,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openMap(double latitude, double longitude, context) async {
  // Check if location permission is granted
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    // Request location permission if not granted
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      const ErrorDialog(message: 'Location permission denied');
   
      return;
    }
  }

  try {
    
    // Show circular progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double currentLatitude = position.latitude;
    double currentLongitude = position.longitude;

    Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&origin=$currentLatitude,$currentLongitude');

    if (await canLaunch(mapUrl.toString())) {
      await launch(mapUrl.toString());
    } else {
      // ErrorDialog(message: 'Could not open the map');
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            const ErrorDialog(message: 'Could not open the map'),
      );
    }
  } on PlatformException catch (e) {
    // Handle the PlatformException for permission denied
    if (e.code == 'PERMISSION_DENIED') {
      Navigator.pop(context); // Dismiss circular progress indicator

      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
            message: 'Permission denied to access the device\'s location'),
      );
    } else {
      Navigator.pop(context); // Dismiss circular progress indicator
      ErrorDialog(
          message:
              'Error occurred while getting the current location: ${e.message}');
 
    }
  } catch (e) {
    // Handle other exceptions
    ErrorDialog(
        message: 'Error occurred while getting the current location: $e');
  }
}

Future<dynamic> onClose(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      // barrierColor: Color.fromARGB(135, 240, 217, 133),
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Do you want to exit?',
              style: TextStyle(fontSize: 25),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 25, color: Colors.red.shade400),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'NO',
                  style: TextStyle(fontSize: 25, color: Colors.green.shade400),
                ))
          ],
        );
      });
}
