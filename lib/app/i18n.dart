import 'package:flutter/widgets.dart';

bool isZh(BuildContext context) {
  return Localizations.localeOf(
    context,
  ).languageCode.toLowerCase().startsWith('zh');
}

String tr(BuildContext context, {required String zh, required String en}) {
  return isZh(context) ? zh : en;
}
