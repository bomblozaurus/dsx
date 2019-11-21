import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dsx/requests/requests.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/users/user.dart';
import 'package:dsx/utils/bubble_indication_painter.dart';
import 'package:dsx/utils/jwt_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

import 'logo.dart';
import 'menu.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode emailLoginNode = FocusNode();
  final FocusNode passwordLoginNode = FocusNode();
  final TextEditingController emailLoginController =
  new TextEditingController();
  final TextEditingController passwordLoginController =
  new TextEditingController();

  final FocusNode passwordSignUpNode = FocusNode();
  final FocusNode emailSignUpNode = FocusNode();
  final FocusNode firstNameSignUpNode = FocusNode();
  final FocusNode lastNameSignUpNode = FocusNode();
  final FocusNode studentHouseSignUpNode = FocusNode();
  final FocusNode indexNumberSignUpNode = FocusNode();
  final TextEditingController emailSignUpController =
  new TextEditingController();
  final TextEditingController firstNameSignUpController =
  new TextEditingController();
  final TextEditingController lastNameSignUpController =
  new TextEditingController();
  final TextEditingController passwordSignUpController =
  new TextEditingController();
  final TextEditingController studentHouseSignUpController =
  new TextEditingController();
  final TextEditingController indexNumberSignUpController =
  new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignUp = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height >= 775.0
                ? MediaQuery
                .of(context)
                .size
                .height
                : 840,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
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
                Expanded(
                  flex: 2,
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

    _pageController = PageController();
  }

  void showInSnackBar(String value, Color color) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: Theme.Fonts.loginFontSize,
            fontFamily: Theme.Fonts.loginFontSemiBold),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }

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
                          "Email"),
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
                      "Imię"),
                  _buildSeparator(),
                  _buildTextField(
                      lastNameSignUpNode,
                      lastNameSignUpController,
                      TextInputType.text,
                      FontAwesomeIcons.user,
                      "Nazwisko"),
                  _buildSeparator(),
                  _buildTextField(
                      emailSignUpNode,
                      emailSignUpController,
                      TextInputType.emailAddress,
                      FontAwesomeIcons.envelope,
                      "Email"),
                  _buildSeparator(),
                  _buildTextField(
                      passwordSignUpNode,
                      passwordSignUpController,
                      TextInputType.text,
                      FontAwesomeIcons.lock,
                      "Hasło",
                      obscureText: _obscureTextSignUp),
                  _buildSeparator(),
                  _buildTextField(
                      indexNumberSignUpNode,
                      indexNumberSignUpController,
                      TextInputType.number,
                      FontAwesomeIcons.graduationCap,
                      "Numer indeksu"),
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
              child:
              _buildSubmitButton("DOŁĄCZ", 490.0, () => _registerUser()),
            )
          ],
        ),
      ],
    );
  }

  _registerUser() async {
    String firstName = firstNameSignUpController.text;
    String lastName = lastNameSignUpController.text;
    String email = emailSignUpController.text;
    String password = passwordSignUpController.text;
    int indexNumber = int.parse(indexNumberSignUpController.text);
    int studentHouseNumber = int.parse(studentHouseSignUpController.text);

    var user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        indexNumber: indexNumber,
        studentHouse: studentHouseNumber);
    var data = user.toJson();

var data = user.toJson();
    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("signUpUrl");
    var headers = Request.jsonHeader;

    await Request().createPost(url, body: data, headers: headers).then(

            (value) =>
            showInSnackBar("Zarejestrowano pomyślnie!", Colors.blue));

  }

  _loginUser() async {
    String email = emailLoginController.text;
    String password = passwordLoginController.text;

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceInfo;
    if (Platform.isAndroid) {
      await deviceInfoPlugin.androidInfo.then((e)=>deviceInfo=e.toString());
    } else if (Platform.isIOS) {
      await deviceInfoPlugin.iosInfo.then((e)=>deviceInfo=e.toString());
    }

    var body = LogInCredentials(
        email: email, password: password, deviceInformation: deviceInfo)
        .toJson();

    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("logInUrl");

    var headers = {"Device-info": deviceInfo};
    headers.addAll(Request.jsonHeader);
    await Request()
        .createPost(url, body: body, headers: headers)
        .then((token) => _loginSuccessful(token))
        .catchError((token) => _loginFailed(token));

  }

  _loginSuccessful(token) async {
    JwtTokenUtils().saveToken(token);
    showInSnackBar("Zalogowano poprawnie", Colors.lime);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MenuPage()));

  }

  _loginFailed(token) {
    print(token);
    showInSnackBar("Nie udało się zalogować", Colors.red);
  }

  Container _buildSubmitButton(String text, double topMargin,
      Function() onPressed) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      decoration: new BoxDecoration(
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
        gradient: new LinearGradient(
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
      {bool obscureText = false}) {
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

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignUp() {
    setState(() {
      _obscureTextSignUp = !_obscureTextSignUp;
    });
  }
}
