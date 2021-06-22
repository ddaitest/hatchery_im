import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarView extends StatelessWidget {
  final String searchHintText;
  final bool isEnabled;
  final EdgeInsetsGeometry padding;
  final GlobalKey<FormState>? globalKey;
  final TextEditingController? textEditingController;
  final GestureTapCallback? onTap;
  final bool isAutofocus;
  SearchBarView(
      {this.searchHintText = "搜索",
      this.isEnabled = false,
      this.padding = const EdgeInsets.all(16.0),
      this.textEditingController,
      this.globalKey,
      this.onTap,
      this.isAutofocus = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Form(
        key: globalKey,
        child: Container(
          padding: padding,
          child: TextFormField(
            controller: textEditingController,
            enabled: isEnabled,
            autofocus: isAutofocus,
            decoration: InputDecoration(
              hintText: searchHintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(11),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
