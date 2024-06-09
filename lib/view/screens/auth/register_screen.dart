import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/custom_Text_Form_Field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.find<AuthController>();

  // The variable related to showing and hiding the text
  bool obscure = true;
  bool obscureConfirmation = true;

  // The key related to the form
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "مرحبا!",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0).w,
                              child: Text(
                                "انشاء حسابك هنا",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            CustomTextFormField(
                              controller: _emailController,
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
                            CustomTextFormField(
                              validater: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء إدخال كلمة المرور';
                                }
                                if (value.length < 8 || value.length > 30) {
                                  return "كلمة المرور يجب ان تكون اكبر من 8 واصغر من 30";
                                }

                                // You can add more complex password validation logic here if needed.
                                return null;
                              },
                              obscureText: obscure,
                              controller: _passwordController,
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
                            CustomTextFormField(
                              validater: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء إدخال تأكيد كلمة المرور';
                                }
                                if (value != _passwordController.text) {
                                  return 'كلمة المرور غير متطابقة';
                                }
                                return null;
                              },
                              obscureText: obscureConfirmation,
                              hint: "تأكيد كلمة المرور",
                              suffixIcon: IconlyBroken.lock,
                              prefixIcon: obscureConfirmation == false
                                  ? IconlyBroken.show
                                  : IconlyBroken.hide,
                              onTapPrefixIcon: () {
                                setState(() {
                                  obscureConfirmation = !obscureConfirmation;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => authController.isLoading.value
                              ? const CircularProgressIndicator()
                              : CustomButton(
                            color: primary,
                            textColor: form,
                            text: "التسجيل",
                            width: double.infinity,
                            height: 60.h,
                            onTap: () {
                              if (_key.currentState!.validate()) {
                                authController.register(
                                    _emailController.text, _passwordController.text);
                              }
                            },
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                " لديك حساب؟",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: mainText),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.toNamed('/login');
                                  },
                                  child: Text(
                                    "قم بتسجيل الدخول الان",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: primary),
                                  )),
                            ],
                          )
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
