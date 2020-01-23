import 'dart:io';

import 'package:dsx/models/user.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/bubble_indication_painter.dart';
import 'package:dsx/utils/flushbar_utils.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:dsx/utils/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

import '../widgets/logo.dart';
import 'landing_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode emailLoginNode = FocusNode();
  final FocusNode passwordLoginNode = FocusNode();
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  final FocusNode passwordSignUpNode = FocusNode();
  final FocusNode emailSignUpNode = FocusNode();
  final FocusNode firstNameSignUpNode = FocusNode();
  final FocusNode lastNameSignUpNode = FocusNode();
  final FocusNode studentHouseSignUpNode = FocusNode();
  final FocusNode indexNumberSignUpNode = FocusNode();
  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController firstNameSignUpController =
      TextEditingController();
  final TextEditingController lastNameSignUpController =
      TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  final TextEditingController studentHouseSignUpController =
      TextEditingController();
  final TextEditingController indexNumberSignUpController =
      TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignUp = true;

  PageController _pageController;
  ScrollPhysics _physics;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            physics: _physics,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 870.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.Colors.loginGradientStart,
                      Theme.Colors.loginGradientEnd
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(top: 60.0)),
                  Logo(size: 120.0),
                  Padding(padding: const EdgeInsets.only(top: 40.0)),
                  _buildMenuBar(context),
                  Flexible(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        _buildLogIn(context),
                        _buildSignUp(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordSignUpNode.dispose();
    emailSignUpNode.dispose();
    firstNameSignUpNode.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _physics = AlwaysScrollableScrollPhysics();
    _pageController = PageController()
      ..addListener(() {
        _physics = (_pageController.page == 0.0)
            ? NeverScrollableScrollPhysics()
            : AlwaysScrollableScrollPhysics();
      });
  }

  void showFlushbar({String title, String message, Icon icon, Color color}) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: title,
      message: message,
      icon: icon,
      color: color,
    );
  }

  void showSuccess({String title, String message, IconData iconData}) =>
      showFlushbar(
        title: title,
        message: message,
        icon: Icon(iconData, color: Theme.Colors.logoBackgroundColor),
      );

  void showFailed({String title, String message, IconData iconData}) =>
      showFlushbar(
        title: title,
        message: message,
        icon: Icon(iconData, color: Colors.red),
      );

  void showLoginSuccess() =>
      showSuccess(title: "Zalogowano pomyślnie", iconData: Icons.done);

  void showLoginFailed() => showFailed(
      title: "Nie udało się zalogować!",
      message: "Sprawdź poprawność danych i spróbuj ponownie",
      iconData: Icons.warning);

  void showSignUpSuccess() => showSuccess(
      title: "Zarejestrowano pomyślnie",
      message: "Możesz się teraz zalogować",
      iconData: Icons.done);

  void showSignUpFailed() =>
      showFailed(
          title: "Nie udało się zarejestrować!",
          message: "Sprawdź poprawność danych i spróbuj ponownie",
          iconData: Icons.warning);

  Widget _buildMenuBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: 300.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Color(0x552B2B2B),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: CustomPaint(
          painter: TabIndicationPainter(pageController: _pageController),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onSignInButtonPress,
                  child: Text(
                    "Logowanie",
                    style: TextStyle(
                        color: left,
                        fontSize: Theme.Fonts.loginFontSize,
                        fontFamily: Theme.Fonts.loginFontSemiBold),
                  ),
                ),
              ),
              //Container(height: 33.0, width: 1.0, color: Colors.white),
              Expanded(
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onSignUpButtonPress,
                  child: Text(
                    "Rejestracja",
                    style: TextStyle(
                        color: right,
                        fontSize: Theme.Fonts.loginFontSize,
                        fontFamily: Theme.Fonts.loginFontSemiBold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(
                        emailLoginNode,
                        emailLoginController,
                        TextInputType.emailAddress,
                        FontAwesomeIcons.envelope,
                        "Email",
                        onSubmitFocusNode: passwordLoginNode,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildSeparator(),
                      _buildTextField(
                          passwordLoginNode,
                          passwordLoginController,
                          TextInputType.text,
                          FontAwesomeIcons.lock,
                          "Hasło",
                          obscureText: _obscureTextLogin),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton("ZALOGUJ", 170.0, () => _loginUser()),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () async {
                  showFailed(
                    title: "Funkcjonalność nieobsługiwana",
                    message:
                    "Wpłać 999'999'999 € na nasze konto, abyśmy rozwinęli aplikację.",
                    iconData: Icons.monetization_on,
                  );
                  await JwtTokenUtils()
                      .getToken()
                      .then((value) => print(value));
                },
                child: Text(
                  "Zapomniałeś hasła?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: Theme.Fonts.loginFontSize,
                      fontFamily: Theme.Fonts.loginFontMedium),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  _buildTextField(
                      firstNameSignUpNode,
                      firstNameSignUpController,
                      TextInputType.text,
                      FontAwesomeIcons.user,
                      "Imię",
                      onSubmitFocusNode: lastNameSignUpNode),
                  _buildSeparator(),
                  _buildTextField(lastNameSignUpNode, lastNameSignUpController,
                      TextInputType.text, FontAwesomeIcons.user, "Nazwisko",
                      onSubmitFocusNode: emailSignUpNode),
                  _buildSeparator(),
                  _buildTextField(
                    emailSignUpNode,
                    emailSignUpController,
                    TextInputType.emailAddress,
                    FontAwesomeIcons.envelope,
                    "Email",
                    onSubmitFocusNode: passwordSignUpNode,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildSeparator(),
                  _buildTextField(passwordSignUpNode, passwordSignUpController,
                      TextInputType.text, FontAwesomeIcons.lock, "Hasło",
                      obscureText: _obscureTextSignUp,
                      onSubmitFocusNode: indexNumberSignUpNode),
                  _buildSeparator(),
                  _buildTextField(
                      indexNumberSignUpNode,
                      indexNumberSignUpController,
                      TextInputType.number,
                      FontAwesomeIcons.graduationCap,
                      "Numer indeksu",
                      onSubmitFocusNode: studentHouseSignUpNode),
                  _buildSeparator(),
                  _buildTextField(
                      studentHouseSignUpNode,
                      studentHouseSignUpController,
                      TextInputType.number,
                      FontAwesomeIcons.home,
                      "Numer DS")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _buildSubmitButton("DOŁĄCZ", 520.0, () => _registerUser()),
            )
          ],
        ),
      ],
    );
  }

  _registerUser() async {
    String firstName = firstNameSignUpController.text.trim();
    String lastName = lastNameSignUpController.text.trim();
    String email = emailSignUpController.text.trim();
    String password = passwordSignUpController.text.trim();

    String indexString = indexNumberSignUpController.text;
    String studentHouseString = studentHouseSignUpController.text;
    int indexNumber = indexString != "" ? int.parse(indexString) : null;
    int studentHouseNumber =
    studentHouseString != "" ? int.parse(studentHouseString) : null;

    var user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        indexNumber: indexNumber,
        studentHouse:
        studentHouseNumber != null ? studentHouseNumber - 1 : null);
    var data = user.toJson();
    try {
      await Request()
          .postToMobileApiWithoutTokenHeader(
          resourcePath: GlobalConfiguration().getString("signUpUrl"),
          body: data)
          .then(_processSignupResponse);
    } catch (e) {
      FlushbarUtils.showConnectionTimeout(context);
    }
  }

  _processSignupResponse(response) {
    response.statusCode == HttpStatus.created
        ? showSignUpSuccess()
        : showSignUpFailed();
  }

  _loginUser() async {
    String email = emailLoginController.text.trim();
    String password = passwordLoginController.text.trim();
    var body = LogInCredentials(email: email, password: password).toJson();

    var resourcePath = GlobalConfiguration().getString("logInUrl");
    try {
      await Request()
          .postToMobileApiWithoutTokenHeader(
          resourcePath: resourcePath, body: body)
          .then((response) => _processLoginResponse(response));
    } catch (e) {
      FlushbarUtils.showConnectionTimeout(context);
    }
  }

  _processLoginResponse(var response) async {
    response.statusCode == HttpStatus.ok
        ? _loginSuccessful(response.body)
        : _loginFailed(response.body);
  }

  void _loginSuccessful(token) async {
    JwtTokenUtils().saveToken(token.substring(13, token.length - 2));
    showLoginSuccess();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

  _loginFailed(token) {
    print(token);
    showLoginFailed();
  }

  Container _buildSubmitButton(
      String text, double topMargin, Function() onPressed) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.Colors.loginGradientStart,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
          BoxShadow(
            color: Theme.Colors.loginGradientEnd,
            offset: Offset(1.0, 6.0),
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
            colors: [
              Theme.Colors.loginGradientEnd,
              Theme.Colors.loginGradientStart
            ],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: Theme.Colors.loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: Theme.Fonts.loginFontBold),
            ),
          ),
          onPressed: onPressed),
    );
  }

  Widget _buildTextField(FocusNode focusNode, TextEditingController controller,
      TextInputType textInputType, IconData iconData, String text,
      {bool obscureText = false,
        FocusNode onSubmitFocusNode,
        TextInputType keyboardType}) {
    return Container(
      width: 320,
      child: Padding(
          padding:
          EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            keyboardType: textInputType,
            obscureText: obscureText,
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(onSubmitFocusNode ?? null),
            style: TextStyle(
                fontFamily: Theme.Fonts.loginFontSemiBold,
                fontSize: Theme.Fonts.loginFontSize,
                color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                iconData,
                color: Colors.black,
                size: 22.0,
              ),
              hintText: text,
              hintStyle: TextStyle(
                  fontFamily: Theme.Fonts.loginFontSemiBold, fontSize: 17.0),
            ),
          )),
    );
  }

  Container _buildSeparator() {
    return Container(
      width: 250.0,
      height: 1.0,
      color: Colors.grey[400],
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
