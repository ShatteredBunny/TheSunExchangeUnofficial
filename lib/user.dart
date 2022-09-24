import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_sun_exchange_unofficial/login.dart';
import 'package:the_sun_exchange_unofficial/model/user_data.dart';

import 'api.dart';
import 'cache.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder<UserData>(
        future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  'Hello, ${snapshot.data?.member.firstName} ${snapshot.data?.member.lastName}!',
                  textScaleFactor: 1.2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Table(columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth()
              }, children: [
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${snapshot.data?.member.emailAddress}",
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Date of birth",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?.member.dob ?? '-',
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Location",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?.member.country == null
                            ? "-"
                            : "${snapshot.data?.member.country}, ${snapshot.data?.member.region}",
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?.member.address == null
                            ? "-"
                            : "${snapshot.data?.member.address}, ${snapshot.data?.member.postalCode} ${snapshot.data?.member.city}",
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Phone number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        snapshot.data?.member.phoneNumber ?? '-',
                      )),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Agreed to marketing",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Checkbox(
                    onChanged: null,
                    value: snapshot.data?.member.agreeToMarketing,
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Early access",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Checkbox(
                    onChanged: null,
                    value: snapshot.data?.member.hasEarlyAccess,
                  ),
                ]),
                TableRow(children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "KYC",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Status: ${snapshot.data?.kyc.displayStatus}",
                      ),
                      Text(
                        "Tier Level: ${snapshot.data?.kyc.displayTierLevel}",
                      ),
                      Text(
                        "Method: ${snapshot.data?.kyc.displayProvider}",
                      ),
                      Text(
                        "Date captured: ${snapshot.data?.kyc.kycCheckDate ?? '-'}",
                      ),
                    ],
                  ),
                ]),
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _logout,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Logout'),
                  ))
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _logout,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Logout'),
                  ))
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Loading data...'),
              ),
            ];
          }
          return Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ));
        },
      ),
    );
  }

  Future<UserData> _fetch() async {
    return UserData(await Cache.get().getMember(),
        await Api.get().kycStatus(await Cache.get().getMemberId()));
  }

  Future<void> _logout() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    if (token != null) {
      try {
        await Api.get().logout(token);
      } catch (_) {}
    }
    await storage.deleteAll();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginWidget()),
          (route) => false);
    }
  }
}
