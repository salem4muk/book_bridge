import 'package:book_bridge/helper/loading_overlay_helper.dart';
import 'package:book_bridge/view/screens/auth/update_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:material_dialogs/dialogs.dart';
import '../../../constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../helper/dialog_helper.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/custom_Text_Form_Field.dart';
import '../booking_mechanism_screen.dart';
import '../donation_mechanism_screen.dart';
import '../my_donation_screen.dart';
import '../my_reservation_screen.dart';

class MoreTap extends StatefulWidget {
  const MoreTap({super.key});

  @override
  State<MoreTap> createState() => _MoreTapState();
}

class _MoreTapState extends State<MoreTap> {
  final AuthController authController = Get.find<AuthController>();

  bool obscure = true;
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20).h,
                    child: Column(
                      children: [
                        UserProfile(authController: authController),
                        ProfileButton(
                          keyForm: key,
                          obscure: obscure,
                          onObscureChanged: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        ),
                        MenuItem(
                          icon: IconlyBroken.plus,
                          text: "تبرعاتي",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyDonationScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          icon: IconlyBroken.bookmark,
                          text: "حجوزاتي",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyReservationScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          icon: IconlyBroken.info_circle,
                          text: "الية التبرع",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DonationMechanismScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          icon: IconlyBroken.info_circle,
                          text: "الية الحجز",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BookingMechanismScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          icon: IconlyBroken.logout,
                          text: "تسجيل الخروج",
                          onTap: () {
                            Dialogs.bottomMaterialDialog(
                              msg: 'هل تريد تسجيل الخروج؟',
                              title: 'تسجيل الخروج',
                              context: context,
                              actions: [
                                CustomButton(
                                  color: form,
                                  textColor: primary,
                                  text: "إلغاء",
                                  width: 150.w,
                                  height: 40.h,
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                CustomButton(
                                  color: primary,
                                  textColor: form,
                                  text: "تم",
                                  width: 150.w,
                                  height: 40.h,
                                  onTap: () {
                                    authController.logout();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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

class UserProfile extends StatelessWidget {
  final AuthController authController;

  const UserProfile({required this.authController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      child: Text(
        authController.box.read('userName') ?? 'مرحبا بك',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProfileButton extends StatefulWidget {
  final GlobalKey<FormState> keyForm;
  final bool obscure;
  final VoidCallback onObscureChanged;

  const ProfileButton({
    required this.keyForm,
    required this.obscure,
    required this.onObscureChanged,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  bool isLoading = false;
  Map<String, dynamic>? userInfo;
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  Future<void> fetchUserInfo() async {
    setState(() {
      isLoading = true;
    });

    userInfo = await authController.getUserInformation();

    setState(() {
      isLoading = false;
    });

    if (userInfo != null) {
      _newEmailController.text = userInfo!['email'];
      showUserProfileDialog(userInfo!);
    }
  }

  void showUserProfileDialog(Map<String, dynamic> userInfo) {
    Dialogs.bottomMaterialDialog(
      isScrollControlled: true,
      title: 'الملف الشخصي',
      msg:
          "عدد مرات الاستفادة من التبرع ${userInfo['no_bookingOfFirstSemester']} / 3",
      context: context,
      actions: [
        Stack(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: widget.keyForm,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hint: "أسم المستخدم",
                      suffixIcon: IconlyBroken.profile,
                      initialValue: userInfo['userName'],
                      enabled: false,
                    ),
                    CustomTextFormField(
                      hint: "رقم الهاتف",
                      suffixIcon: IconlyBroken.call,
                      initialValue: userInfo['phoneNumber'],
                      enabled: false,
                    ),
                    CustomTextFormField(
                      controller: _newEmailController,
                      hint: "البريد الألكتروني",
                      suffixIcon: IconlyBroken.message,
                    ),
                    ObscureTextFormField(
                      controller: _oldPasswordController,
                      hint: "كلمة المرور",
                      validater: (value) {
                        if (value!.isEmpty) {
                          return 'ارجاء إدخال كلمة المرور الحالية';
                        }
                        if (value.length < 8 || value.length > 30) {
                          return "كلمة المرور الحالية يجب ان تكون اكبر من 8 واصغر من 30";
                        }
                        return null;
                      },
                    ),
                    CustomButton(
                      color: primary,
                      textColor: form,
                      text: "تغيير كلمة المرور",
                      width: 3000.w,
                      height: 50.h,
                      onTap: () {
                        Get.to(() => UpdatePasswordScreen(authController: authController));
                        // Get.toNamed('/update_password');
                      },
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          color: form,
                          textColor: primary,
                          text: "إلغاء",
                          width: 150.w,
                          height: 40.h,
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        CustomButton(
                          color: primary,
                          textColor: form,
                          text: "تم",
                          width: 150.w,
                          height: 40.h,
                          onTap: () {
                            if (widget.keyForm.currentState!.validate()) {
                              if (_newEmailController.text !=
                                  userInfo['email']) {
                                authController.updateEmail(
                                  _oldPasswordController.text,
                                  _newEmailController.text,
                                );
                              } else {
                                DialogHelper.showDialog(
                                    'الرجاء ادخال بريد الكتروني جديد');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: CustomButton(
        text: "الملف الشخصي",
        textColor: primary,
        onTap: fetchUserInfo,
        color: form,
        height: 50.h,
        width: 170.w,
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: lineColor,
            width: 1.0.w,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12).w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: primary),
                  SizedBox(width: 20.w),
                  Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: textColor),
                  ),
                ],
              ),
              const Icon(IconlyBroken.arrow_left_2, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}

class ObscureTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validater;

  const ObscureTextFormField({
    required this.controller,
    required this.hint,
    this.validater,
    Key? key,
  }) : super(key: key);

  @override
  State<ObscureTextFormField> createState() => _ObscureTextFormFieldState();
}

class _ObscureTextFormFieldState extends State<ObscureTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      hint: widget.hint,
      validater: widget.validater,
      suffixIcon: IconlyBroken.lock,
      prefixIcon: obscureText ? IconlyBroken.hide : IconlyBroken.show,
      onTapPrefixIcon: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
    );
  }
}
