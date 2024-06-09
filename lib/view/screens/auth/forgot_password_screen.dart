import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/custom_Text_Form_Field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final key = GlobalKey<FormState>(); // Form key
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "هل نست كلمة المرور ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10).h,
                    child: Text(
                      "قم بأدخال البريد الاكتروني",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Form(
                    key: key,
                    child: CustomTextFormField(
                      controller: emailController,
                      validater: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء ادخال البريد الإلكتروني';
                        }
                        // Email validation using regular expression
                        bool validEmail =
                        RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value);
                        if (!validEmail) {
                          return 'الرجاء إدخال البريد الإلكتروني بشكل صحيح';
                        }
                        return null;
                      },
                      hint: "البريد الإلكتروني",
                      suffixIcon: IconlyBroken.message,
                    ),
                  ),
                  SizedBox(height: 40.h,),
                  CustomButton(
                    text: "تحقق",
                    color: primary,
                    textColor: form,
                    width: double.infinity,
                    height: 60.h,
                    onTap: () {
                      if (key.currentState!.validate()) {
                        authController.forgotPassword(emailController.text);
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (authController.isLoading.value) {
            return const LoadingOverlayHelper();
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
