import 'package:dsx/models/room.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/utils/jwt_token.dart';
import 'package:dsx/utils/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../utils/navigable.dart';

class RoomsPage extends StatefulWidget implements Navigable {
  RoomsPage({Key key}) : super(key: key);

  @override
  _RoomsPageState createState() => new _RoomsPageState();

  @override
  String getDescription() {
    return "Pokoje";
  }

  @override
  IconData getIconData() {
    return Icons.vpn_key;
  }
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
          child: FutureBuilder(
              future: _getUserRooms(),
              initialData: [],
              builder: (context, snapshot) {
                return createCountriesListView(context, snapshot);
              }),
        )),
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
    waitingFor();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _pageController = PageController();
  }

  void waitingFor() async {
    await _getUserRooms();
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

  Future<List<Room>> _getUserRooms() async {
    String token;
    await JwtTokenUtils().getToken().then((e) => token = e);
    token = token.substring(13, token.length - 2);
    var headers = {"Authorization": ("Bearer " + token)};
    List<Room> roomList;
    headers.addAll(Request.jsonHeader);
    String url = GlobalConfiguration().getString("baseUrl") +
        GlobalConfiguration().getString("getAllForUser");
    await Request().createGet(url, headers: headers).then((value) {
//      final jsonResponse = json.decode(value);
//      roomList= Room.roomListFromJson(jsonResponse);
    });
    return roomList;
  }

  Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      itemCount: values == null ? 0 : values.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              _buildSubmitButton(values[index].name, 40, () => {}),
              Divider(
                height: 2.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
