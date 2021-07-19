import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormModel extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final IconData leadingIcon;
  final Widget? suffixWidget;
  final bool hideText;
  final String hintText;
  final int? maxLength;
  final int? maxLine;
  final bool onlyNumber;
  TextFormModel(this.title, this.textEditingController, this.keyboardType,
      this.leadingIcon, this.hintText,
      {this.suffixWidget,
      this.hideText = false,
      this.maxLength,
      this.maxLine = 1,
      this.onlyNumber = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Flavors.textStyles.loginNormalText,
        ),
        SizedBox(height: 10.0.h),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF6CA8F1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0.h,
          child: TextFormField(
            controller: textEditingController,
            keyboardType: keyboardType,
            cursorColor: Flavors.colorInfo.subtitleColor,
            maxLength: maxLength,
            maxLines: maxLine,
            obscureText: hideText,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                leadingIcon,
                color: Colors.white,
              ),
              suffixIcon: suffixWidget,
              hintText: hintText,
              errorMaxLines: 1,
              counterText: '',
              hintStyle: Flavors.textStyles.hintTextText,
            ),
            inputFormatters: <TextInputFormatter>[
              if (onlyNumber) FilteringTextInputFormatter.digitsOnly, //只输入数字
            ],
          ),
        ),
      ],
    );
  }
}

class TextFormNormalModel extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final IconData leadingIcon;
  final bool hideText;
  final String hintText;
  TextFormNormalModel(this.title, this.textEditingController, this.keyboardType,
      this.leadingIcon, this.hintText,
      {this.hideText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != ''
            ? Text(
                title,
                style: Flavors.textStyles.newGroupSettingTitleText,
              )
            : Container(),
        SizedBox(height: 10.0.h),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0.h,
          child: TextFormField(
            controller: textEditingController,
            keyboardType: keyboardType,
            cursorColor: Flavors.colorInfo.diver,
            obscureText: hideText,
            style: TextStyle(
              color: Colors.black54,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                leadingIcon,
                color: Flavors.colorInfo.mainColor,
              ),
              hintText: hintText,
              errorMaxLines: 1,
              hintStyle: Flavors.textStyles.loginSubTitleText,
            ),
          ),
        ),
      ],
    );
  }
}
