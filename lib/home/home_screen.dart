import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:trash_it/worker/wo_auth/wo_auth.dart';
import 'package:trash_it/widgets/widgets.dart';

import '../users/user_auth/user_auth.dart';
import 'drawer_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        return (await onClose(context)                
                ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        drawer: const HomeDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Trash It',
            style: GoogleFonts.merienda(fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width-2,
                  margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(   
                      color: Colors.white,
                       borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.blue,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                            0.4, 0.4) // shadow direction: bottom right
                        )
                  ],),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Image(
                          image: AssetImage(
                            'assets/images/rec1.jpg',
                          ),
                          fit: BoxFit.fill,
                          height: 150,
                          // width: MediaQuery.of(context).size.width,
                        ),
                      SizedBox(width: 5,),
                      
                        Image(
                          image: AssetImage(
                            'assets/images/user1.png',
                          ),
                          fit: BoxFit.cover,
                          height: 150,
                          // width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(width: 5,),
                          Image(
                          image: AssetImage(
                            'assets/images/rec1.jpg',
                          ),
                          fit: BoxFit.cover,
                          height: 150,
                          // width: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Button(
                        btncolor: Colors.green,
                        text: 'User App',
                        icons: Icons.account_circle_outlined,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserAuth()));
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    Button(
                        btncolor: Colors.orange,
                        text: 'Worker',
                        icons: Icons.delivery_dining,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WorkerLogin()));
                        }),
                  ],
                ),
                // Container(
                //   margin: const EdgeInsets.all(12),
                //   height: 250,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(40),
                //         bottomRight: Radius.circular(40),
                //       ),
                //       gradient: LinearGradient(colors: [
                //         Colors.lightBlue.shade200,
                //         Colors.lightBlue.shade200,
                //         Colors.lightBlue.shade300,
                //       ])),
                //   child: Column(
                //     children: [
                //       // RichText(
                //       //     text: TextSpan(
                //       //   text: 'Team',
                //       //   style: GoogleFonts.notoSerifKhojki(
                //       //       fontWeight: FontWeight.bold,
                //       //       fontSize: 25,
                //       //       color: const Color.fromARGB(255, 232, 144, 12)),
                //       // ))
                //     ],
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.all(08),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightGreen.shade400,
                          offset: const Offset(0, 20),
                          blurRadius: 30,
                          spreadRadius: -5,
                        ),
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.lightGreen.shade400,
                            Colors.lightGreen.shade300,
                            Colors.lightGreen.shade500,
                            Colors.lightGreen.shade600,
                          ],
                          stops: const [
                            0.1,
                            0.3,
                            0.9,
                            2.0
                          ])),
                  child: RichText(
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'ABOUT,\n',
                      style: GoogleFonts.notoSerifKhojki(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: const Color.fromARGB(255, 232, 144, 12)),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'This application provides the service to the people  in their remote areas. \n',
                            style: GoogleFonts.notoSerifKhojki(
                                fontSize: 15, color: Colors.white)),
                        TextSpan(
                            text:
                                ' Basically in the app people will requist for service using form it will be sent to the users if user is accept the request and helped \n',
                            style: GoogleFonts.notoSerifKhojki(
                                fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}
