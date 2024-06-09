import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/custom_textfield.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../constants/globals_variable.dart';
import '../../../constants/utils.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'loginsignuphelper.dart';

class singup extends StatefulWidget {
  const singup({super.key});

  @override
  State<singup> createState() => _singupState();
}

class _singupState extends State<singup> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _conpasswordController = TextEditingController();
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  String type = '';

  void signUpUser() {
    if(_conpasswordController.text != _passwordController.text){
      showSnackBar(context, 'Passwords do not match');
    } else if (_numberController.text.length != 11){
      showSnackBar(context, 'Phone number should be of 11 digits');
    } else if (type == ''){
      showSnackBar(context, 'Please select the type of account');
    } else {
      if (EmailValidator.validate(_emailController.text)) {
        authService.signUpUser(
            context: context,
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            number: _numberController.text,
            type: type
        );
        Navigator.pop(context);
      } else {
        showSnackBar(context, "Email is not valid");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              logsighelper(
                  text1: 'Sign',
                  text2: 'up',
                  text3:
                  'Please sign up to get access to a vast range of clothes.'),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: GlobalVariables.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    cbutton("Store"),
                    cbutton("User"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GlobalVariables.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        formatter: [
                          FilteringTextInputFormatter.allow(GlobalVariables.getRegExpstring())
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _numberController,
                        hintText: 'Number',
                        textInputType: TextInputType.phone,
                        maxLength: 11,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        obsure: true,
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: _conpasswordController,
                        obsure: true,
                        hintText: 'Confirm Password',
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("Already have account",style: GoogleFonts.poppins(
                            decoration: TextDecoration.underline
                        ),),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                          text: 'Sign Up',
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              signUpUser();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cbutton(String title){
    return Expanded(
      child: InkWell(
        onTap: (){
          type = title;
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: type == title ? Colors.red.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Image.asset(title == 'Store' ? 'assets/store.png' : 'assets/user.png',height: 50,width: 50,),
              const SizedBox(height: 10,),
              Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize:20),),
            ],
          ),
        ),
      ),
    );
  }

}
