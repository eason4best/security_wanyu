import 'dart:math';

import 'package:flutter/material.dart';
import 'package:security_wanyu/widget/announcement_widget.dart';

class CompanyAnnouncementTab extends StatefulWidget {
  const CompanyAnnouncementTab({Key? key}) : super(key: key);

  @override
  State<CompanyAnnouncementTab> createState() => _CompanyAnnouncementTabState();
}

class _CompanyAnnouncementTabState extends State<CompanyAnnouncementTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemBuilder: (context, index) {
        var tf = [true, false];
        final random = Random();
        return AnnouncementWidget(
          title: '公告標題${index + 1}',
          subtitle: '公告內文預覽${index + 1}',
          read: tf[random.nextInt(tf.length)],
          onPressed: () {},
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
