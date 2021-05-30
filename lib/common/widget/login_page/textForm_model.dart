import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';

class TextFormModel extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool hideText;
  final String labelText;
  TextFormModel(this.textEditingController, this.labelText,
      {this.hideText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.name,
      obscureText: hideText,
      maxLines: 1,
      maxLength: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        labelText: labelText,
        counterText: '',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          //未选中时候的颜色
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Flavors.colorInfo.subtitleColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          //选中时候的颜色
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Flavors.colorInfo.mainColor,
          ),
        ),
      ),
      // ignore: missing_return
      validator: (value) {
        if (value == null || value.isEmpty) {
          showToast('请输入您的$labelText');
          return '请输入您的$labelText';
        } else if (value.length > 20) {
          showToast('$labelText格式不正确');
          return '$labelText格式不正确';
        }
        return null;
      },
    );
  }
}
