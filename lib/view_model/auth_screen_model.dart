import 'package:beacon/enums/view_state.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/view_model/base_view_model.dart';

class AuthViewModel extends BaseModel {
  final formKeySignup = GlobalKey<FormState>();
  final formKeyLogin = GlobalKey<FormState>();

  AutovalidateMode validate = AutovalidateMode.onUserInteraction;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode emailLogin = FocusNode();
  final FocusNode passwordLogin = FocusNode();

  final FocusNode password = FocusNode();
  final FocusNode email = FocusNode();
  final FocusNode name = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool obscureTextLogin = true;
  bool obscureTextSignup = true;
  bool loginAsGuest = false;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();

  PageController pageController = PageController();

  Color left = Colors.white;
  Color right = Colors.black;

  Color leftBg = kLightBlue;
  Color rightBg = kBlue;

  next_signup() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeySignup.currentState.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final bool signUpSuccess = await databaseFunctions.signup(
          signupNameController.text ?? "Anonymous",
          signupEmailController.text,
          signupPasswordController.text);
      if (signUpSuccess) {
        userConfig.currentUser.print();
        navigationService.pushScreen('/main');
      } else {
        navigationService.showSnackBar('SomeThing went wrong');
      }
      setState(ViewState.idle);
    } else {
      navigationService.showSnackBar('Enter valid entries');
    }
  }

  next_login() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyLogin.currentState.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final bool loginSuccess = await databaseFunctions.login(
          loginEmailController.text, loginPasswordController.text);
      if (loginSuccess) {
        userConfig.currentUser.print();
        navigationService.removeAllAndPush('/main', '/');
      } else {
        navigationService.showSnackBar('SomeThing went wrong');
      }
      setState(ViewState.idle);
    } else {
      navigationService.showSnackBar('Enter valid entries');
    }
  }

  void onSignInButtonPress() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void onSignUpButtonPress() {
    pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
