import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/Firebase%20Services/provider.dart';
import 'package:firebase_project/UI/ForgotPassword.dart';
import 'package:firebase_project/UI/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Widgets/Button.dart';
import '../../Widgets/TextForm.dart';
import '../../utils/Utils.dart';
import '../Firebase/Firebase_Post.dart';
import 'Signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // bool loading = false;
  var _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    ConfirmPasswordController.dispose();
  }

  Login(provider){
    if (_formKey.currentState!.validate()) {

      provider.setLoading(true);

      _auth
          .signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .then((value) {
        // Utils().toastMessege(value.user!.email.toString(),Colors.green);
        Utils().toastMessege('Successfully Logged', Colors.green);

        provider.setLoading(false);


        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }).onError((error, stackTrace) {
        Utils().toastMessege(error.toString(), Colors.red);
        provider.setLoading(false);

        // setState(() {
        //   loading = false;
        // });
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    print('build');
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Here'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                                // icon: Icon(Icons.visibility),
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
                                height: 50,
                              ),
                              Button(
                                  loading: provider.loading,
                                  title: 'Login',
                                  onTap: () {
                                    Login(provider);
                                  }
                              )
                            ],
                          );
                        }),

                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: ForgetPassword(),
                                        type: PageTransitionType.scale,
                                        alignment: Alignment.center,
                                        duration: Duration(seconds: 1)));
                              },
                              child: Text('Forgot Password')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: SignUpScreen(),
                                          type: PageTransitionType.fade,
                                          duration: Duration(seconds: 1)));
                                },
                                child: Text('SignUp'))
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
