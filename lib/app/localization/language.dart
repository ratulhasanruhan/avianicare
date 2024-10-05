import 'package:get/get.dart';
import 'package:avianicare/app/localization/arabic.dart';
import 'package:avianicare/app/localization/bangla.dart';
import 'package:avianicare/app/localization/english.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': english,
        'ar': arabic,
        'bn': bangla,
      };
}
