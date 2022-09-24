import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_sun_exchange_unofficial/password_reset.dart';
import 'package:the_sun_exchange_unofficial/splash.dart';

import 'api.dart';
import 'info.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Widget> _errors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InfoWidget())),
                icon: const Icon(Icons.info)),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    autofillHints: const [AutofillHints.password],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordResetWidget(),
                        ));
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "Forgot your password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        try {
                          var login = await Api.get().login(
                              emailController.text, passwordController.text);
                          const storage = FlutterSecureStorage();
                          await storage.write(
                              key: "email", value: emailController.text);
                          await storage.write(
                              key: "password", value: passwordController.text);
                          await storage.write(key: "token", value: login.login);
                          if (mounted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SplashWidget(),
                                ));
                          }
                        } catch (e) {
                          setState(() {
                            _errors = [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Padding(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 60,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                          'Error: ${e is List ? e[0]['message'] : e.toString()}',
                                          textScaleFactor: 1.2),
                                    ),
                                  ])
                            ];
                          });
                        }
                      },
                    )),
                ..._errors
              ],
            )));
  }
}
