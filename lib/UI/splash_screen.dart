import 'package:firebase_project/Firebase%20Services/splahs_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
    splashServices.animate();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
            height:splashServices.height,
            width: splashServices.width,
            duration: Duration(seconds: 2),
            curve: Curves.easeIn,
            child: AnimatedRotation(
              duration: Duration(milliseconds: 1800),
              turns: splashServices.turns,
              child: Image.asset(
                'assets/images/firebaseImage.png',
              ),
            )),
      ),
    );
  }
}
