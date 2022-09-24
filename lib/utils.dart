import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static copy(BuildContext context, String text) async {
    const snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Copied to Clipboard',
          textAlign: TextAlign.center,
        ));
    Clipboard.setData(ClipboardData(text: text))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
  }
}
