//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2025, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import '/app/events/login_event.dart';
import '/bootstrap/app_helper.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/buttons.dart';
import '/resources/widgets/safearea_widget.dart';
import '/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:wp_json_api/exceptions/empty_username_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_email_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_login_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/user_already_exist_exception.dart';
import 'package:wp_json_api/exceptions/username_taken_exception.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountRegistrationPage extends NyStatefulWidget {
  static RouteView path =
      ("/account-register", (_) => AccountRegistrationPage());

  AccountRegistrationPage({super.key})
      : super(child: () => _AccountRegistrationPageState());
}

class _AccountRegistrationPageState extends NyPage<AccountRegistrationPage> {
  final TextEditingController _tfEmailAddressController =
          TextEditingController(),
      _tfPasswordController = TextEditingController(),
      _tfFirstNameController = TextEditingController(),
      _tfLastNameController = TextEditingController();

  final WooSignalApp? _wooSignalApp = AppHelper.instance.appConfig;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(trans("Register")),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeAreaWidget(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextEditingRow(
                        heading: trans("First Name"),
                        controller: _tfFirstNameController,
                        shouldAutoFocus: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Flexible(
                      child: TextEditingRow(
                        heading: trans("Last Name"),
                        controller: _tfLastNameController,
                        shouldAutoFocus: false,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                )),
            TextEditingRow(
              heading: trans("Email address"),
              controller: _tfEmailAddressController,
              shouldAutoFocus: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextEditingRow(
              heading: trans("Password"),
              controller: _tfPasswordController,
              shouldAutoFocus: true,
              obscureText: true,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: PrimaryButton(
                title: trans("Sign up"),
                isLoading: isLocked('register_user'),
                action: _signUpTapped,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: InkWell(
                onTap: _viewTOSModal,
                child: RichText(
                  text: TextSpan(
                    text:
                        '${trans("By tapping \"Register\" you agree to ")} ${AppHelper.instance.appConfig!.appName!}\'s ',
                    children: <TextSpan>[
                      TextSpan(
                          text: trans("terms and conditions"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '  ${trans("and")}  '),
                      TextSpan(
                          text: trans("privacy policy"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                    style: TextStyle(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.black45
                                : Colors.white70),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signUpTapped() async {
    String email = _tfEmailAddressController.text,
        password = _tfPasswordController.text,
        firstName = _tfFirstNameController.text,
        lastName = _tfLastNameController.text;

    if (email.isNotEmpty) {
      email = email.trim();
    }

    if (!isEmail(email)) {
      showToast(
          title: trans("Oops"),
          description: trans("That email address is not valid"),
          style: ToastNotificationStyleType.danger);
      return;
    }

    if (password.length <= 5) {
      showToast(
          title: trans("Oops"),
          description: trans("Password must be a min 6 characters"),
          style: ToastNotificationStyleType.danger);
      return;
    }

    await lockRelease('register_user', perform: () async {
      WPUserRegisterResponse? wpUserRegisterResponse;
      try {
        wpUserRegisterResponse = await WPJsonAPI.instance.api(
          (request) => request.wcRegister(
            email: email.toLowerCase(),
            password: password,
            args: {
              "first_name": firstName,
              "last_name": lastName,
            },
          ),
        );
      } on UsernameTakenException catch (e) {
        showToast(
            title: trans("Oops!"),
            description: trans(e.message),
            style: ToastNotificationStyleType.danger);
      } on InvalidNonceException catch (_) {
        showToast(
            title: trans("Invalid details"),
            description:
                trans("Something went wrong, please contact our store"),
            style: ToastNotificationStyleType.danger);
      } on ExistingUserLoginException catch (_) {
        showToast(
            title: trans("Oops!"),
            description: trans("A user already exists"),
            style: ToastNotificationStyleType.danger);
      } on ExistingUserEmailException catch (_) {
        showToast(
            title: trans("Oops!"),
            description: trans("That email is taken, try another"),
            style: ToastNotificationStyleType.danger);
      } on UserAlreadyExistException catch (_) {
        showToast(
            title: trans("Oops!"),
            description: trans("A user already exists"),
            style: ToastNotificationStyleType.danger);
      } on EmptyUsernameException catch (e) {
        showToast(
            title: trans("Oops!"),
            description: trans(e.message),
            style: ToastNotificationStyleType.danger);
      } on Exception catch (e) {
        printError(e.toString());
        showToast(
            title: trans("Oops!"),
            description: trans("Something went wrong"),
            style: ToastNotificationStyleType.danger);
      }

      if (wpUserRegisterResponse?.status != 200) {
        return;
      }

      event<LoginEvent>();

      showToast(
          title: "${trans("Hello")} $firstName",
          description: trans("you're now logged in"),
          style: ToastNotificationStyleType.success,
          icon: Icons.account_circle);
      if (!mounted) return;
      navigatorPush(context,
          routeName: UserAuth.instance.redirect, forgetLast: 2);
    });
  }

  _viewTOSModal() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trans("Actions")),
        content: Text(trans("View Terms and Conditions or Privacy policy")),
        actions: <Widget>[
          MaterialButton(
            onPressed: _viewTermsConditions,
            child: Text(trans("Terms and Conditions")),
          ),
          MaterialButton(
            onPressed: _viewPrivacyPolicy,
            child: Text(trans("Privacy Policy")),
          ),
          Divider(),
          TextButton(
            onPressed: pop,
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewTermsConditions() {
    Navigator.pop(context);
    openBrowserTab(url: _wooSignalApp!.appTermsLink!);
  }

  void _viewPrivacyPolicy() {
    Navigator.pop(context);
    openBrowserTab(url: _wooSignalApp!.appPrivacyLink!);
  }
}
