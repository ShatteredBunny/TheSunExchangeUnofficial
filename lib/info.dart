import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_sun_exchange_unofficial/utils.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "The Sun Exchange Unofficial",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.5,
                    )),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text:
                          '''This app is unofficial and not affiliated with The Sun Exchange, Inc. I developed it because I wanted to be able to easily check my solar cells on my phone.\n
The app only communicates with the API of The Sun Exchange, Inc. and stores credentials locally. No data is sent elsewhere. The privacy policy can be found ''',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: 'here',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Utils.openLink(
                              "https://github.com/ShatteredBunny/TheSunExchangeUnofficial/blob/master/PRIVACY.md");
                        }),
                  const TextSpan(
                      text:
                          ''' and the privacy policy of The Sun Exchange Inc. can be found ''',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: 'here',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Utils.openLink(
                              "https://thesunexchange.com/privacy-policy");
                        }),
                  const TextSpan(
                    text: ".\n\nThe source code is available on ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: 'GitHub',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Utils.openLink(
                              "https://github.com/ShatteredBunny/TheSunExchangeUnofficial");
                        }),
                  const TextSpan(
                    text: ".",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
                const Divider(),
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Donations",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.2,
                    )),
                const Text(
                    "If you want to donate for the development of this app you can send me some bitcoin to this address:"),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("bc1q73ddk3[...]mc8ka2",
                        style: TextStyle(fontFamily: 'Monospace')),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Utils.copy(context,
                            "bc1q73ddk3k5p65yjrzdfv20q40dmz8lsp0xmc8ka2");
                      },
                    ),
                  ],
                )),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                    text:
                        "Please note that I'm not affiliated with The Sun Exchange, Inc. If you want to support them, please visit their ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                      text: 'website',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Utils.openLink("https://thesunexchange.com/");
                        }),
                  const TextSpan(
                    text: ".",
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
              ])),
        )));
  }
}
