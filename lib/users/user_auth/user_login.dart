import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/auth.dart';
 
import '../../widgets/widgets.dart';
import '../user_home/user_home.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _userformKey = GlobalKey<FormState>();
  final _userEmail = TextEditingController();
  final _userPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _userformKey,
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 20,
            children: [
              Center(
                child: Text(
                  'User Login',
                  style: GoogleFonts.merienda(
                      fontSize: 30,
                      color: const Color.fromARGB(255, 255, 81, 7)),
                ),
              ),
              TextFieldCustom(
                controller: _userEmail,
                   icons: Icons.email,
                validater: FormBuilderValidators.compose([
                  FormBuilderValidators.email(),
                  FormBuilderValidators.required(),
                ]),
                boxlable: 'Email',
                boxname: 'Enter your Email',
              ),
              // SizedBox(
              //   height: 25,
              // ),
              TextFieldCustom(
                controller: _userPass,
                   icons: Icons.password,
                validater: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                boxlable: 'Password',
                boxname: 'Enter your Password',
              ),
              Button(
                  text: 'SignIN',
                  icons: Icons.login,
                  onPress: () {
                    if (_userformKey.currentState!.validate()) {
                      _userformKey.currentState!.save();
                      loginAuth(context,
                          emailCont: _userEmail,
                          passCont: _userPass,
                          collName: 'users',
                          role: 'user',
                          route: const UsersHome());
                    }
                  }),
              const SizedBox(
                height: 25,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserLogin()));
                  },
                  icon: const Icon(Icons.new_label),
                  label: const Text(
                    'New User, please use Signup',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
