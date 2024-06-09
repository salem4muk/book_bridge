import 'dart:async';
import 'package:book_bridge/helper/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/loading_overlay_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_verify_code.dart';

class VerifyScreen extends StatefulWidget {
  final String identifier;
  final String type;


  const VerifyScreen({Key? key, required this.identifier, required this.type}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final AuthController authController = Get.find<AuthController>();
  TextEditingController pinController = TextEditingController();

  Timer? _timer;
  int _start = 60; // 1 minute in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _start = 60;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "تحقق من الرقم",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      "ادخل رمز التحقق الذي تم ارسالة الى رقم هاتفك",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  CustomVerifyCode(
                    controller: pinController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لم استلم رمز التحقق بعد؟ ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: mainText),
                      ),
                      TextButton(
                        onPressed: _start == 0
                            ? () {
                          if(widget.type == "phone") {
                            authController.sendVerificationCodeAgainPhone(
                                widget.identifier);
                          } else if(widget.type == "email"){
                            authController.sendVerificationCodeAgainEmail(
                                widget.identifier);
                          }
                                startTimer();
                              }
                            : null,
                        child: Text(
                          "أطلب الرمز مجددآ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: _start == 0 ? primary : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  if (_start > 0)
                    Text(
                      "يمكنك طلب الرمز مجدداً خلال $_start ثانية",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: mainText),
                    ),
                  SizedBox(height: 70.h),
                  CustomButton(
                    text: "تحقق",
                    color: primary,
                    textColor: form,
                    width: double.infinity,
                    height: 60.h,
                    onTap: () {
                      if (pinController.text.length == 4) {
                        if (widget.type == "phone") {
                          authController.verifyCodePhone(
                              widget.identifier, pinController.text);
                        } else if (widget.type == "email") {
                          authController.verifyCodeEmail(
                              widget.identifier, pinController.text);
                        }
                        pinController.clear();
                      }else {
                        DialogHelper.showDialog("الرجاء إدخال الكود المكون من أربعة أرقام بشكل صحيح");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (authController.isLoading.value) {
              return const LoadingOverlayHelper();
            }
            return const SizedBox.shrink();
          }),        ]),
      ),
    );
  }

}
