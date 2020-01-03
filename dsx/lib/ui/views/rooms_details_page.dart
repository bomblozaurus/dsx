import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:flutter/material.dart';

import '../../rooms/room.dart';
import '../widgets/date_picker_button.dart';
import '../widgets/room_details.dart';
import '../widgets/sliver_content.dart';
import 'details_page.dart';

class RoomDetailsPage extends DetailsPage {
  final Room room;
  final CircleAvatar avatar;
  final int index;
  final bool withToolbar;

  RoomDetailsPage(this.room, this.avatar, this.index, this.withToolbar)
      : super(
    item: room,
    avatar: avatar,
    index: index,
  );

  static RoomDetailsPage fromRouting(room, avatar, index) =>
      RoomDetailsPage(room, avatar, index, false);

  @override
  Widget getContent() {
    return Column(children: <Widget>[
      Expanded(
        child: SliverContent.standard(
            title: room.name,
            appBarBackground: Stack(children: <Widget>[
              getHeader(),
              Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: RoomDetails.vertical(room, index)),
            ]),
            sliverBuilders: <SliverBuilder>[
                  (context) =>
              (SliverToBoxAdapter(
                child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: 120,
                            color: Colors.red,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Data"),
                                ),
                                DatePickerButton(),
                                Theme(
                                    data: new ThemeData(
                                        accentColor:
                                        DsxTheme.Colors.logoBackgroundColor,
                                        backgroundColor:
                                        DsxTheme.Colors.loginGradientEnd,
                                        brightness: Brightness.dark),
                                    child: DatePickerButton()),
                              ],
                            )),
                        Container(height: 120, color: Colors.blue),
                        Container(height: 120, color: Colors.green),
                      ],
                    )),
              )),
                  (context) =>
              (SliverToBoxAdapter(
                child: Container(
                  child: SingleChildScrollView(
                      child: Text(
                          "asdasdjha asdkjkjasd asdkjhkjashd askdjhaksjd asdkjahsdkjasd kjasndkjasdkjasd askdjnaskjdn asdkjnaksjdn askdjnakjsdn askdjnaksjdn askjdnkajsnd askdjnaksjdn asdasdjha asdkjkjasd asdkjhkjashd askdjhaksjd asdkjahsdkjasd kjasndkjas asdasdjha asdkjkjasd asdkjhkjashd askdjhaksjd asdkjahsdkjasd kjasndkjasdkjasd askdjnaskjdn asdkjnaksjdn askdjnakjsdn askdjnaksjdn askjdnkajsnd askdjnaksjdn dkjasd askdjnaskjdn asdkjnaksjdn askdjnakjsdn askdjnaksjdn askjdnkajsnd askdjnaksjdn ",
                          style: TextStyle(fontSize: 28.0))),
                ),
              )),
            ]), //
      )
    ]);
  }
}
