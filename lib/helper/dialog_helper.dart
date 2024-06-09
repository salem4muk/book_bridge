import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';

class DialogHelper {
  static void showDialog(String message) {
      Dialogs.bottomMaterialDialog(
        context: Get.context!,
          actions : [Center(child: Text(message,textAlign: TextAlign.center,),)]
      );
  }
}
