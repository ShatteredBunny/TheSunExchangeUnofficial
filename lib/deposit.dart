import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_sun_exchange_unofficial/api.dart';
import 'package:the_sun_exchange_unofficial/model/member.dart';
import 'package:the_sun_exchange_unofficial/model/member_wallet.dart';
import 'package:the_sun_exchange_unofficial/utils.dart';

import 'cache.dart';

class DepositWidget extends StatefulWidget {
  const DepositWidget({super.key});

  @override
  State<DepositWidget> createState() => _DepositWidgetState();
}

class _DepositWidgetState extends State<DepositWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MemberWallet>>(
        future: _fetch(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MemberWallet>> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = _buildWidget(snapshot.data ?? []);
          } else if (snapshot.hasError) {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ]);
          } else {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading data...'),
                  ),
                ]);
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Deposit funds'),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              body: Center(child: SingleChildScrollView(child: child)));
        });
  }

  Future<List<MemberWallet>> _fetch() async {
    return await Api.get().wallets(await Cache.get().getMemberId());
  }

  _buildWidget(List<MemberWallet> wallets) {
    MemberWallet btcWallet = wallets.firstWhere((e) => e.currency == "XBT");
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          const Text(
            "Bitcoin",
            textScaleFactor: 2,
            style: TextStyle(color: Colors.orange),
          ),
          btcWallet.address == null
              ? Container()
              : GestureDetector(
                  onTap: () => Utils.copy(context, btcWallet.address!),
                  child: QrImage(
                    data: btcWallet.address!,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            btcWallet.address == null
                ? Container()
                : Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Text(
                              btcWallet.address!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textScaleFactor: 0.8,
                            )),
                        IconButton(
                          onPressed: () =>
                              Utils.copy(context, btcWallet.address!),
                          icon: const Icon(Icons.copy),
                          tooltip: "Copy",
                        ),
                      ],
                    )),
          ]),
          const Icon(Icons.warning, color: Colors.red),
          Text(
            btcWallet.address == null
                ? "You don't have a deposit address yet. Make sure you have completed KYC."
                : "Warning: This is your deposit address as reported by The Sun Exchange. However, this app may not be up to date with the API and e.g. a maintenance notification could be missed. To make sure your deposit will arrive, it's recommended to check at the website.",
            style: const TextStyle(color: Colors.red),
          ),
          const Divider(),
          const Text(
            "Fiat",
            textScaleFactor: 2,
            style: TextStyle(color: Colors.green),
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text:
                    'To deposit fiat via bank transfer or credit card, please visit the ',
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: 'website',
                style: const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await Utils.openLink("https://thesunexchange.com/");
                  }),
            const TextSpan(text: '.', style: TextStyle(color: Colors.black)),
          ])),
        ]));
  }
}
