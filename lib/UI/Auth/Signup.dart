import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/UI/Auth/Login.dart';
import 'package:firebase_project/UI/Auth/Phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Firebase Services/provider.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/TextForm.dart';
import '../../utils/Utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  var password='';
  var confirmPassword='';


  @override

  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    ConfirmPasswordController.dispose();
  }

  Registration(provider){
    if(password == confirmPassword){
      if (_formKey.currentState!.validate()) {
        provider.setLoading(true);
        auth.createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString()).then((value) {
          Utils().toastMessege('Successfully Created',Colors.green);
          provider.setLoading(false);


        }).onError((error, stackTrace){
          Utils().toastMessege(error.toString(),Colors.red);
          provider.setLoading(false);

        });
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password doesn't match"),backgroundColor: Colors.red,));
    }

  }


  @override
  Widget build(BuildContext context) {
    print('build');
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SignUp Here'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextForm(
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      icon: Icon(Icons.email),
                      validator: (value) {
                        if (value! == null || value!.isEmpty) {
                          return 'Email is required';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Enter valid email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Consumer<AuthProvider>(builder: (context,provider,child){
                      return Column(
                        children: [
                          TextForm(
                            labelText: 'Password',
                            hintText: 'Enter Your Password',
                            icon: Icon(
                              provider.obsecureValue
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            obsecure: provider.obsecureValue,
                            onIconTap: () {
                              provider.setObsecure();
                            },
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validator: (value) {
                              if (value! == null || value!.isEmpty) {
                                return 'password is required';
                              } else if (value.length < 6) {
                                return 'Password must be greather then 6';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextForm(
                            labelText: 'Confirm Password',
                            hintText: 'Enter Your Password',
                            icon: Icon(
                              provider.obsecureValue
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            obsecure: provider.obsecureValue,
                            onIconTap: () {
                              provider.setObsecure();
                            },
                            keyboardType: TextInputType.visiblePassword,
                            controller: ConfirmPasswordController,
                            validator: (value) {
                              if (value! == null || value!.isEmpty) {
                                return 'password is required';
                              } else if (value.length < 6) {
                                return 'Password must be greather then 6';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Button(
                              loading: provider.loading,
                              title: 'Sign Up',
                              onTap: () {
                                if(_formKey.currentState!.validate()){
                                  password = passwordController.text.toString();
                                  confirmPassword = ConfirmPasswordController.text.toString();
                                }
                                Registration(provider);
                              }
                          )
                        ],
                      );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("Already have an account"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: LoginScreen(),
                                      type: PageTransitionType.fade,
                                      duration: Duration(seconds: 1)
                                  ));
                            },
                            child: Text('Login'))
                      ],
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Phone()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.purple,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Center(
                          child:  Text('Sign Up with phone number'),
                        ),
                      ),
                    )
                  ],
                )
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
