import 'package:nylo_framework/nylo_framework.dart';

/* Login Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class LoginForm extends NyFormData {
  LoginForm({String? name}) : super(name ?? "login");

  @override
  fields() => [
        Field.email(
          "Email",
          style: "compact",
          validate: FormValidator.email(),
        ),
        Field.password(
          "Password",
          style: "compact",
          viewable: true,
          validate: FormValidator.password(),
        ),
      ];
}
