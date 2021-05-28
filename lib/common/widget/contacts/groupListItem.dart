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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 42, right: 42),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(mainImageUrl!),
                    maxRadius: 33,
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(groupName!,
                      style: Flavors.textStyles.groupMainName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
              Text('$membersNumber 人',
                  style: Flavors.textStyles.groupMembersNumberText),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(groupMembersImageUrl![0]),
                            maxRadius: 10,
                          ),
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(groupMembersImageUrl![1]),
                            maxRadius: 10,
                          ),
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(groupMembersImageUrl![2]),
                            maxRadius: 10,
                          ),
                        ],
                      )))
            ],
          ),
        ));
  }
}
