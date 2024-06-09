import 'package:book_bridge/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../constants.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/custom_Text_Form_Field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.code, required this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
  final String code;
  final String email;
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final AuthController authController = Get.find<AuthController>();

  bool obscure = true;
  bool obscureConfirmation = true;
  final key = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ).w,
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "اعد ضبط كلمة المرور  ",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10).h,
                  child: Text(
                    "قم بأدخال كلمة مورور جديدة",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                CustomTextFormField(
                  controller: _passwordController,
                  validater: (value) {
                    if (value!.isEmpty) {
                      return 'ارجاء إدخال كلمة المرور';
                    }
                    if (value.length < 8 || value.length > 30) {
                      return "كلمة المرور يجب ان تكون اكبر من 8 واصغر من 30";
                    }
                    return null;
                  },
                  obscureText: obscure,
                  hint: "كلمة المرور",
                  suffixIcon: IconlyBroken.lock,
                  prefixIcon:
                      obscure == false ? IconlyBroken.show : IconlyBroken.hide,
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
                SizedBox(
                  height: 40.h,
                ),
                CustomButton(
                  text: "حفظ",
                  color: primary,
                  textColor: form,
                  width: double.infinity,
                  height: 60.h,
                  onTap: () {
                    if (key.currentState!.validate()) {
                      authController.resetPassword(_passwordController.text, widget.code, widget.email);
                    }
                  },
                ),

              ],
            ),
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
