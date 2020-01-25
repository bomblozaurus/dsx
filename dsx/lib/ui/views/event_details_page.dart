import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../widgets/event_details.dart';
import '../widgets/sliver_content.dart';
import 'details_page.dart';

class EventDetailsPage extends DetailsPage {
  final Event event;
  final CircleAvatar avatar;
  final int index;

  const EventDetailsPage({Key key, this.event, this.avatar, this.index})
      : super(
          key: key,
          item: event,
          avatar: avatar,
          index: index,
        );

  static EventDetailsPage fromRouting(event, avatar, index) => EventDetailsPage(
        event: event,
        avatar: avatar,
        index: index,
      );

  @override
  Widget getContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SliverContent.standard(
            title: event.name,
            appBarBackground: Stack(
              children: <Widget>[
                getHeader(),
                Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: EventDetails.vertical(event, index)),
              ],
            ),
            sliverBuilders: <SliverBuilder>[
              _buildSliverBox(_buildEventDescription),
            ],
          ), //
        )
      ],
    );
  }

  SliverBuilder _buildSliverBox(Function widgetBuilder) =>
      ((context) => SliverToBoxAdapter(child: widgetBuilder(context)));

  Widget _buildEventDescription(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Text(event.description,
              style: DsxTheme.TextStyles.headerTextStyle),
        ),
      ),
    );
  }
}
