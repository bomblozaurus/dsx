import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:dsx/ui/widgets/reservation_form.dart';
import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../widgets/reservation_form.dart';
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
              _buildSliverBoxWithWidget(ReservationForm()),
              _buildSliverBox(_buildRoomDescription),
            ]), //
      )
    ]);
  }

  SliverBuilder _buildSliverBox(Function widgetBuilder) =>
      ((context) => SliverToBoxAdapter(child: widgetBuilder(context)));

  SliverBuilder _buildSliverBoxWithWidget(Widget widget) =>
      ((context) => SliverToBoxAdapter(child: widget));

  Container _buildRoomDescription(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            Text(room.description, style: DsxTheme.TextStyles.headerTextStyle),
          )),
    );
  }
}
