import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/custom_Text_Form_Field.dart';

class SendVerificationCodeScreen extends StatefulWidget {
  const SendVerificationCodeScreen({super.key});

  @override
  State<SendVerificationCodeScreen> createState() =>
      _SendVerificationCodeScreenState();
}

final key = GlobalKey<FormState>();
TextEditingController phoneNumberController = TextEditingController();
final AuthController authController = Get.find<AuthController>();

class _SendVerificationCodeScreenState
    extends State<SendVerificationCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: key,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10).h,
                              child: Text(
                                "قم بأدخال رقم الهاتف",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                            CustomTextFormField(
                              controller: phoneNumberController,
                              validater: (value) {
                                if (value!.isEmpty) {
                                  return 'ارجاء إدخال رقم الجوال';
                                }
                                // Phone number validation using regular expression
                                bool validPhoneNumber =
                                RegExp(r'^(73|78|77|70|71)\d{7}$')
                                    .hasMatch(value);
                                if (!validPhoneNumber) {
                                  return 'ارجاء إدخال رقم جوال صحيح';
                                }
                                return null;
                              },
                              hint: "رقم الهاتف",
                              suffixIcon: IconlyBroken.call,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 40.h,
                    ),
                    CustomButton(
                      text: "تحقق",
                      color: primary,
                      textColor: form,
                      width: double.infinity,
                      height: 60.h,
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          // Call the login method from the AuthController
                          authController.sendVerificationCodeForPhone(phoneNumberController.text);
                        }
                      },
                    ),
                    SizedBox(height: 30.h,),
                    CustomButton(
                        color: primary,
                        textColor: Colors.white,
                        text: "تسجيل الخروج",
                        width: double.infinity,
                        height: 60.h,
                        onTap: () {
                          authController.logout();
                        }),
                  ],
                ),
              ),
              if (authController.isLoading.value) const LoadingOverlayHelper(),
            ],
          )),
    );
  }

}
