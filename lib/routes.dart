import 'package:book_bridge/view/screens/auth/update_password_screen.dart';
import 'package:book_bridge/view/screens/donation/add.dart';
import 'package:book_bridge/view/screens/my_donation_screen.dart';
import 'package:book_bridge/view/screens/notification_screen.dart';
import 'package:get/get.dart';
import 'view/screens/auth/forgot_password_screen.dart';
import 'view/screens/auth/login_screen.dart';
import 'view/screens/auth/new_password_screen.dart';
import 'view/screens/auth/register_screen.dart';
import 'view/screens/auth/send_verification_code_screen.dart';
import 'view/screens/auth/verify_screen.dart';
import 'view/screens/home_screen.dart';
import 'view/screens/splash_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => const RegisterScreen()),
    GetPage(name: '/forgot_password', page: () => const ForgotPasswordScreen()),
    GetPage(name: '/new_password', page: () => const NewPasswordScreen(code: '', email: '',)),
    GetPage(name: '/send_verification_code', page: () => const SendVerificationCodeScreen()),
    GetPage(name: '/verify', page: () => const VerifyScreen(type: '', identifier: '',)),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/add_donation_screen', page: () => const AddDonationScreen()),
    // GetPage(name: '/update_password', page: () =>  UpdatePasswordScreen(authController: "null",)),
    GetPage(name: '/notification', page: () => const NotificationScreen()),
  ];
}
