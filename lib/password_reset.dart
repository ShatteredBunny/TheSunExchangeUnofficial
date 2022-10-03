import 'package:flutter/material.dart';

import 'api.dart';

class PasswordResetWidget extends StatefulWidget {
  const PasswordResetWidget({super.key});

  @override
  State<PasswordResetWidget> createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends State<PasswordResetWidget> {
  TextEditingController emailController = TextEditingController();
  List<Widget> _errors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Password reset'),
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
                      'Password reset',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Reset password'),
                      onPressed: () async {
                        try {
                          await Api.get().passwordReset(emailController.text);
                          if (mounted) {
                            Navigator.pop(
                              context,
                            );
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
                ..._errors,
              ],
            )));
  }
}
