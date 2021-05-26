import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:image_stack/image_stack.dart';

class GroupListItem extends StatelessWidget {
  final String? mainImageUrl;
  final String? groupName;
  final List<String>? groupMembersImageUrl;
  final int? membersNumber;
  GroupListItem(
      {@required this.mainImageUrl,
      @required this.groupName,
      @required this.groupMembersImageUrl,
      @required this.membersNumber});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatDetailPage();
          }));
        },
        child: Container(
          width: 150.0.w,
          decoration: BoxDecoration(
              border:
                  Border.all(color: Color.fromRGBO(236, 240, 250, 1), width: 1),
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular((4.0))),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 42, right: 42, top: 19),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(mainImageUrl!),
                    maxRadius: 33,
                  )),
              Text(groupName!, style: Flavors.textStyles.groupMainName),
              Text('$membersNumber 人',
                  style: Flavors.textStyles.groupMembersNumberText),
              Container(
                  padding:
                      const EdgeInsets.only(left: 36.5, right: 36.5, top: 5),
                  child: ImageStack(
                    imageList: groupMembersImageUrl!,
                    imageSource: ImageSource.Asset,
                    showTotalCount: false,
                    totalCount:
                        3, // If larger than images.length, will show extra empty circle
                    imageRadius: 28, // Radius of each images
                    imageCount:
                        3, // Maximum number of images to be shown in stack
                    imageBorderWidth: 3, // Border width around the images
                  ))
            ],
          ),
        ));
  }
}
