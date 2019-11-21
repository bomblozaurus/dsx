import 'dart:convert';

import 'package:dsx/requests/requests.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/rooms/room.dart';
import 'package:dsx/rooms/room.l.dart';

import 'package:dsx/utils/bubble_indication_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:dsx/utils/jwt_token.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';

import 'logo.dart';

class RoomsPage extends StatefulWidget {
  RoomsPage({Key key}) : super(key: key);

  @override
  _RoomsPageState createState() => new _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage>
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
  final List<Widget> buttonsList = [];
  RoomList roomList = new RoomList();
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
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: roomList.rooms.length,
                itemBuilder: (BuildContext context, int index) {
                   return _buildSubmitButton(roomList.rooms[index].name, 50, ()=>{});

                },
            ),

          )
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
  void initState()   {
    super.initState();
    _getUserRooms();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
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

  Container _buildSeparator() {
    return Container(
      width: 250.0,
      height: 1.0,
      color: Colors.grey[400],
    );
  }

  _getUserRooms() async {
    String token;
    await JwtTokenUtils().getToken().then((e)=> token=e);

    token = token.substring(13,token.length-2);

    var headers = {
      "Authorization":("Bearer " + token)
    };
    print(JwtTokenUtils().getToken().toString());

    headers.addAll(Request.jsonHeader);
    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("getAllForUser");
    RoomList data;

    await Request()
        .createGet(url, body: new Map(), headers: headers)
        .then((value) {
      final jsonResponse = json.decode(value);
     roomList= RoomList.fromJson(jsonResponse);
     print(roomList.rooms[0].name);
    });
  }

//  _buildButtonsWithNames(RoomList data) {
//    print( data.rooms);
//    for (int i = 0; i < data.rooms.length; i++) {
//      buttonsList.add(_buildSubmitButton((data.rooms[i]).name, i * 60.0, () => {}));
//
//      print(data.rooms[i].name);
//    }
//  }

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
