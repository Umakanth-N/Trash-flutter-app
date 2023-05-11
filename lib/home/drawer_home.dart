import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin/admin_auth/admin_login.dart';
import '../employee/emp_auth/emp_auth.dart';
import '../worker/wo_auth/wo_auth.dart';
import '../users/user_auth/user_auth.dart';
import '../widgets/widgets.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        backgroundColor: const Color.fromARGB(239, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: const Icon(Icons.account_box_rounded),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        opacity: 0.3,
                        image: AssetImage('assets/images/rec2.png')),
                    color: Colors.white),
                accountName: Text('Recycle',
                    style:
                        GoogleFonts.benne(fontSize: 30, color: Colors.purple)),
                accountEmail: Text('Recycle@gmail.com',
                    style:
                        GoogleFonts.benne(fontSize: 20, color: Colors.purple))),
            // Button(text: 'ABOUT', icons: Icons.mobile_friendly, onPress: () {}),
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
            Button(
                btncolor: Colors.orange,
                text: 'Worker App',
                icons: Icons.delivery_dining_rounded,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkerLogin()));
                }),
            Button(
                btncolor:Colors.amber.shade600,
                text: 'Employee App',
                icons: Icons.work_outline,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmployeLogin()
                           
                          ));
                }),
            Button(
                btncolor: Colors.red.shade400,
                text: 'Admin App',
                icons: Icons.admin_panel_settings_outlined,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminLogin()
                       
                          ));
                }),
            BottomAppBar(
              height: 70,
              child: Container(
                color: const Color.fromARGB(255, 191, 124, 211),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Text('Umakanth N'),
                                  content:
                                      Text('The App contains May features'),
                                  actions: [],
                                );
                              });
                        },
                        child: Text(
                          'Developer Contact.?',
                          style: GoogleFonts.benne(
                              fontSize: 15, color: Colors.white),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
