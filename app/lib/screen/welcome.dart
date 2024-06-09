import 'package:animate_do/animate_do.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import '../theam/them.dart';
import '../widget/custom_scafford.dart';
import '../widget/welcome_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Welcome Back!',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1900),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '\nEnter personal details to start',
                            style: TextStyle(
                              fontSize: 20,
                              // height: 0,
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'conversation',
                            style: TextStyle(
                              fontSize: 20,
                              // height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: FadeInDown(
                      duration: Duration(milliseconds: 2100),
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: Signup(),
                        color: Color.fromARGB(5, 0, 0, 0),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FadeInRight(
                      duration: Duration(milliseconds: 2200),
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: login_screen(),
                        color: Colors.white,
                        textColor: lightColorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
