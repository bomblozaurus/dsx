import 'package:dsx/models/ad.dart';
import 'package:dsx/style/theme.dart' as Theme;
import 'package:dsx/ui/views/ad_details_page.dart';
import 'package:dsx/ui/widgets/item_details.dart';
import 'package:dsx/utils/indexable.dart';
import 'package:dsx/utils/text_with_icon.dart';
import 'package:flutter/material.dart';

class AdDetails extends ItemDetails<Ad> implements Indexable {
  final Ad ad;
  final bool horizontal;
  final int index;

  AdDetails({Key key, this.ad, this.horizontal, this.index})
      : super(
            key: key,
            item: ad,
            horizontal: horizontal,
            index: index,
            heroDescription: "ad");

  static AdDetails fromAd(var ad, var index) => AdDetails(
        ad: ad,
        index: index,
        horizontal: true,
      );

  static AdDetails vertical(Ad ad, int index) => AdDetails(
        ad: ad,
        index: index,
        horizontal: false,
      );

  @override
  Widget buildHeader() => Text(
        ad.name,
        style: Theme.TextStyles.headerTextStyle,
        overflow: TextOverflow.ellipsis,
      );

  @override
  Widget buildDescription() => SizedBox(
        height: 18,
        child: Text(
          ad.address.toString(),
          style: Theme.TextStyles.subHeaderTextStyle,
        ),
      );

  @override
  List<TextWithIcon> getFooterItems() => List.of([
        getTextWithIcon(
            "${ad.price}", Icon(Icons.monetization_on, color: Colors.white))
      ]);

  @override
  Widget buildRoutingWidget(Ad item, CircleAvatar avatar, int index) =>
      AdDetailsPage.fromRouting(item, avatar, index);
}
