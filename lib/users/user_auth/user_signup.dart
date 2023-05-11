 import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/auth.dart';
import '../../widgets/widgets.dart';
import '../user_home/user_home.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
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
            'User Sign UP',
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
                           icons: Icons.face,
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
                        Button(text: 'Sign UP', icons: Icons.playlist_add_circle_outlined, 
                        btncolor: Colors.green,
                        onPress: (){
                                       if (_userSignup.currentState!.validate()) {
                                _userSignup.currentState!.save();
                                setState(() {
                                  signUpSaveData(
                                      _emailcontroller, _conpasscontroller,
                                      context: context,
                                      route: const UsersHome(),
                                      collName: 'users',
                                      role: 'user',
                                      nameCont: _namecontroller,
                                      subCol_1: 'Buy',
                                      subCol_2: 'Sell',
                                      phonCont: _phonecontroller);
                                });
                              }

                        }),
                  
                        const SizedBox(
                          width: 50,
                        ),
            Button(text: 'Clear', icons: Icons.clear, onPress: (){
                 _namecontroller.text = '';
                              _emailcontroller.text = '';
                              _phonecontroller.text = '';
                              _conpasscontroller.text = '';
                              _passcontroller.text = '';
            }),

                      ],
                    )
                  ]),
            )),
      ]),
    );
  }
}
