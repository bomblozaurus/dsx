import 'package:dsx/requests/requests.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/users/user.dart';
import 'package:dsx/utils/bubble_indication_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

import 'logo.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeFirstName = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignUp = true;

  TextEditingController signUpEmailController = new TextEditingController();
  TextEditingController signUpFirstNameController = new TextEditingController();
  TextEditingController signUpLastNameController = new TextEditingController();
  TextEditingController signUpPasswordController = new TextEditingController();

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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 775.0
                ? MediaQuery.of(context).size.height
                : 775.0,
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
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignUp(context),
                      ),
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
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeFirstName.dispose();
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
    return Container(
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
    );
  }

  Widget _buildSignIn(BuildContext context) {
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
                          myFocusNodeEmailLogin,
                          loginEmailController,
                          TextInputType.emailAddress,
                          FontAwesomeIcons.envelope,
                          "Email"),
                      _buildSeparator(),
                      _buildTextField(
                          myFocusNodePasswordLogin,
                          loginPasswordController,
                          TextInputType.text,
                          FontAwesomeIcons.lock,
                          "Hasło",
                          obscureText: _obscureTextLogin),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(
                  "ZALOGUJ",
                  170.0,
                  () => showInSnackBar(
                      GlobalConfiguration().getString("baseUrl"), Colors.blue)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {},
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
                  height: 360.0,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(
                          myFocusNodeFirstName,
                          signUpFirstNameController,
                          TextInputType.text,
                          FontAwesomeIcons.user,
                          "Imię"),
                      _buildSeparator(),
                      _buildTextField(
                          myFocusNodeLastName,
                          signUpLastNameController,
                          TextInputType.text,
                          FontAwesomeIcons.user,
                          "Nazwisko"),
                      _buildSeparator(),
                      _buildTextField(
                          myFocusNodeEmail,
                          signUpEmailController,
                          TextInputType.emailAddress,
                          FontAwesomeIcons.envelope,
                          "Email"),
                      _buildSeparator(),
                      _buildTextField(
                          myFocusNodePassword,
                          signUpPasswordController,
                          TextInputType.text,
                          FontAwesomeIcons.lock,
                          "Hasło",
                          obscureText: _obscureTextSignUp)
                    ],
                  ),
                ),
              ),
              _buildSubmitButton("DOŁĄCZ", 340.0, () => _registerUser())
            ],
          ),
        ],
      ),
    );
  }

  _registerUser() async {
    String firstName = signUpFirstNameController.text;
    String lastName = signUpLastNameController.text;
    String email = signUpEmailController.text;
    String password = signUpPasswordController.text;

    var user = User(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password);
    var data = user.toJson();
    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("signUpUrl");
    await Request().createPost(url, body: data).then(
        (value) => showInSnackBar("Zarejestrowano pomyślnie!", Colors.blue));
  }

  Container _buildSubmitButton(
      String text, double topMargin, Function() onPressed) {
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
    return Padding(
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
        ));
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
