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

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscure = true; // Variable to show/hide the password
  final key = GlobalKey<FormState>(); // Form key

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20).w,
                  child: Column(
                    children: [
                      Form(
                        key: key,
                        child: Column(
                          children: [
                            Text(
                              "!مرحبا بعودتك",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0).w,
                              child: Text(
                                "الرجاء إدخال حسابك هنا",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            CustomTextFormField(
                              controller: identifierController,
                              validater: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ادخال رقم الجوال أو البريد الإلكتروني';
                                }
                                return null;
                              },
                              hint: " رقم الجوال أو البريد الإلكتروني",
                              suffixIcon: IconlyBroken.call,
                            ),
                            CustomTextFormField(
                              controller: passwordController,
                              validater: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ادخال كلمة المرور';
                                }
                                return null;
                              },
                              obscureText: obscure,
                              hint: "كلمة المرور",
                              suffixIcon: IconlyBroken.lock,
                              prefixIcon: obscure == false
                                  ? IconlyBroken.show
                                  : IconlyBroken.hide,
                              onTapPrefixIcon: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Text(
                                    "نسيت كلمة المرور؟",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  onTap: () {
                                    Get.toNamed('/forgot_password');
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 70.h),
                      CustomButton(
                        text: "تسجيل الدخول",
                        color: primary,
                        textColor: form,
                        width: double.infinity,
                        height: 60.h,
                        onTap: () {
                          if (key.currentState!.validate()) {
                            authController.login(
                              identifierController.text,
                              passwordController.text,
                            );
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ليس لديك حساب؟",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: mainText),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/register");
                            },
                            child: Text(
                              "أنشاء حساب",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (authController.isLoading.value) {
                  return const LoadingOverlayHelper();
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
