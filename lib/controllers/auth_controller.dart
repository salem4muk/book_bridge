import 'dart:developer';
import 'package:book_bridge/services/auth_service.dart';
import 'package:book_bridge/view/screens/auth/new_password_screen.dart';
import 'package:book_bridge/view/screens/auth/verify_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helper/dialog_helper.dart';


class AuthController extends GetxController {
  static AuthController get to => Get.find();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    String token = box.read('token') ?? '';
    String phoneNumber = box.read('phoneNumber') ?? '';
    if (token.isNotEmpty) {
      if (phoneNumber.isNotEmpty) {
        isLoggedIn(true);
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.sendVerificationCode);
      }
    } else {
      isLoggedIn(false);
      Get.offNamed(AppRoutes.login);
    }
  }

  void login(String emailOrPhone, String password) async {
    isLoading(true);
    Map creds = {
      'emailOrPhone': emailOrPhone,
      'password': password,
      'device_name': 'mobile',
    };
    try {
      var response = await AuthService.login(creds);
      if (response.data['status'] == 'success') {
        if(response.data['user']['role'] != 'user'){
          DialogHelper.showDialog( 'لا يسمح لك بتسجيل الدخول الرجاء استخدام تطبيق النقاط');
          return;
        }else{
        box.write('token', response.data['token']);
        box.write('userName', response.data['user']['userName']);
        box.write('phoneNumber', response.data['user']['phoneNumber']);
        box.write('role', response.data['user']['role']);
        String fcmToken = box.read('fcmToken') ?? 'fcmToken';
        var responseToken = await AuthService.updateFcmToken(fcmToken, response.data['token']);
        if (responseToken.data['status'] == 'success') {
          log('FCM token updated');
        } else {
          log('Failed to update FCM token');
        }
        isLoggedIn(true);
        Get.offNamed(AppRoutes.home);
        }
      } else {
        DialogHelper.showDialog(response.data['error']);
      }
    } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(String email, String password) async {
    isLoading(true);
    Map creds = {
      'email': email,
      'password': password,
      'deviceName': 'mobile',
    };
    try {
      var response = await AuthService.register(creds);
      if (response.data['status'] == 'success') {
        box.write('token', response.data['token']);
        box.write('userName', response.data['userName']);
        isLoggedIn(true);
        Get.offNamed(AppRoutes.sendVerificationCode);
      } else if (response.data['status'] == 'validationFail') {
        DialogHelper.showDialog( response.data['errors']['email'][0]);
      } else if (response.data['status'] == 'fail') {
        DialogHelper.showDialog( response.data['message']);
      }
   } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    isLoading(true);
    Map data = {
      'email': email,
    };
    try {
      var response = await AuthService.forgotPassword(data);
      if (response.data['status'] == 'success') {
        Get.to(() => VerifyScreen(identifier: email, type: 'email'));
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
   } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> resetPassword(String password, String token, String email) async {
    isLoading(true);
    Map data = {'password': password, 'token': token, 'email': email};
    try {
      var response = await AuthService.resetPassword(data);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم اعادة تعيين كلمة السر بنجاح');
        Get.offNamed(AppRoutes.login);
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendVerificationCodeForPhone(String phoneNumber) async {
    isLoading(true);
    Map data = {
      'phoneNumber': phoneNumber,
    };
    try {
      String token = box.read('token') ?? '';
      var response = await AuthService.sendVerificationCodeForPhone(data, token);
      if (response.data['status'] == 'success') {
        Get.to(() => VerifyScreen(identifier: phoneNumber, type: 'phone'));
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendVerificationCodeAgainPhone(String phoneNumber) async {
    isLoading(true);
    Map data = {
      'phoneNumber': phoneNumber,
    };
    try {
      String token = box.read('token') ?? '';
      var response = await AuthService.sendVerificationCodeForPhone(data, token);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم إرسال رمز التحقق مجدداً');
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendVerificationCodeAgainEmail(String email) async {
    isLoading(true);
    Map data = {
      'email': email,
    };
    try {
      var response = await AuthService.forgotPassword(data);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم إرسال رمز تعيين كلمة السر مجدداً');
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyCodePhone(String phoneNumber, String code) async {
    isLoading(true);
    Map data = {
      'phone': phoneNumber,
      'code': code,
    };
    try {
      String token = box.read('token') ?? '';
      var response = await AuthService.verifyCode(data, token);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم التحقق بنجاح');
        box.write('phoneNumber', phoneNumber);
        String fcmToken = box.read('fcmToken') ?? 'fcmToken';
        var responseToken = await AuthService.updateFcmToken(fcmToken, token);
        if (responseToken.data['status'] == 'success') {
          log('FCM token updated');
        } else {
          log('Failed to update FCM token');
        }
        Get.offNamed(AppRoutes.home);
      } else {
        DialogHelper.showDialog( 'Verification failed');
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyCodeEmail(String email, String code) async {
    isLoading(true);
    Map data = {
      'email': email,
      'token': code,
    };
    try {
      var response = await AuthService.verifyCodeEmail(data);
      if (response.data['status'] == 'success') {
        Get.off(() => NewPasswordScreen(code: code, email: email));
        DialogHelper.showDialog( 'تم التحقق بنجاح');
      } else {
        DialogHelper.showDialog( 'فشل التحقق');
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    isLoading(true);
    Map data = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
    String token = box.read('token') ?? '';
    try {
      var response = await AuthService.updatePassword(data, token);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم تحديث كلمة المرور بنجاح');
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateEmail(String password, String newEmail) async {
    isLoading(true);
    Map data = {
      'password': password,
      'newEmail': newEmail,
    };
    String token = box.read('token') ?? '';
    try {
      var response = await AuthService.updateEmail(data, token);
      if (response.data['status'] == 'success') {
        DialogHelper.showDialog( 'تم تحديث البريد الإلكتروني بنجاح');
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>?> getUserInformation() async {
    isLoading(true);
    try {
      String token = box.read('token') ?? '';
      var response = await AuthService.getUserInformation(token);
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        DialogHelper.showDialog( response.data['message']);
      }
    } catch (e) {
      log('An error occurred: $e');
    } finally {
      isLoading(false);
    }
    return null;
  }

  void logout() async {
    String token = box.read('token') ?? '';
    if (token.isEmpty) {
      DialogHelper.showDialog( 'No token found');
      return;
    }
    try {
      var response = await AuthService.logout(token);
      if (response.statusCode == 200) {
        box.remove('token');
        box.remove('userName');
        box.remove('phoneNumber');
        isLoggedIn(false);
        Get.offNamed(AppRoutes.login);
      } else {
        log('Error: Failed to revoke token');
      }
    } catch (e) {
      log('Error: An error occurred: $e');
    }
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

}

class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const sendVerificationCode = '/send_verification_code';
}
