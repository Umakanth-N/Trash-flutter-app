import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trash_it/worker/wo_user/wo_home.dart';
import '../../service/auth.dart';
import '../../widgets/widgets.dart';



class DeliverySignUp extends StatefulWidget {
  const DeliverySignUp({Key? key}) : super(key: key);

  @override
  State<DeliverySignUp> createState() => _DeliverySignUpState();
}

class _DeliverySignUpState extends State<DeliverySignUp> {
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _conpasscontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _userSignup = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Center(
          child: Text(
            'Worker Sign UP',
            style: GoogleFonts.merienda(
                fontSize: 30, color: const Color.fromARGB(255, 255, 81, 7)),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _userSignup,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 10,
                  spacing: 20,
                  children: [
                    // Name
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
                        ]),
                        boxname: 'Enter Email',
                        boxlable: 'Email'),
                    // Password
                    TextFieldCustom(
                      controller: _passcontroller,
                      icons: Icons.password,
                      validater: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(8),
                      ]),
                      boxlable: 'Password',
                      boxname: 'Enter your Password',
                    ),
                    //  Conform Password
                    TextFieldCustom(
                      controller: _conpasscontroller,
                      icons: Icons.password,
                      validater: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(8),
                        (val) {
                          // if (val.isEmpty) return 'Empty';
                          if (val != _passcontroller.text) return 'Not Match';
                          return null;
                        }
                      ]),
                      boxlable: 'Confirm Password',
                      boxname: 'Re-Enter your Password',
                    ),
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

                    Row(
                      children: [
                        ElevatedButton(
                            style: const ButtonStyle(
                                // backgroundColor: MaterialColor,
                                ),
                            onPressed: () {
                              if (_userSignup.currentState!.validate()) {
                                _userSignup.currentState!.save();
                                setState(() {
                                  signUpSaveData(
                                      _emailcontroller, _conpasscontroller,
                                      context: context,
                                      route: const WorkerHome(),
                                      collName: 'worker',
                                      role: 'worker',
                                      nameCont: _namecontroller,
                                      subCol_1: 'history',
                                      subCol_2: 'task',
                                      phonCont: _phonecontroller);
                                });
                              }
                            },
                            child: const Text('Sign UP')),
                        const SizedBox(
                          width: 50,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 54, 54),
                                textStyle: const TextStyle(fontSize: 15)),
                            onPressed: () {
                              _namecontroller.text = '';
                              _emailcontroller.text = '';
                              _phonecontroller.text = '';
                              _conpasscontroller.text = '';
                              _passcontroller.text = '';
                            },
                            child: const Text('Clear Details')),
                      ],
                    )
                  ]),
            )),
      ]),
    );
  }
}
