import 'package:dsx/models/ad.dart';
import 'package:dsx/ui/widgets/ad_details.dart';
import 'package:dsx/ui/widgets/sliver_content.dart';
import 'package:flutter/material.dart';

import 'details_page.dart';

class AdDetailsPage extends DetailsPage<Ad> {
  final Ad ad;
  final CircleAvatar avatar;
  final int index;

  AdDetailsPage({this.ad, this.avatar, this.index})
      : super(item: ad, avatar: avatar, index: index);

  static AdDetailsPage fromRouting(ad, avatar, index) => AdDetailsPage(
        ad: ad,
        avatar: avatar,
        index: index,
      );

  @override
  Widget getContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SliverContent.standard(
            title: ad.name,
            appBarBackground: Stack(
              children: <Widget>[
                getHeader(),
                Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: AdDetails.vertical(ad, index),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
