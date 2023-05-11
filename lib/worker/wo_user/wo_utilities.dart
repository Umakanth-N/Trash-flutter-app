
// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types, must_be_immutable
class Wo_PickupCard extends StatelessWidget {
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

  Wo_PickupCard({
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
          
          ],
        ),
      ),
    );
  }
}