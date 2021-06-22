import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarView extends StatelessWidget {
  final String searchHintText;
  final bool isEnabled;
  final EdgeInsetsGeometry padding;
  final TextEditingController? textEditingController;
  final GestureTapCallback? onTap;
  final bool isAutofocus;
  final bool showPrefixIcon;
  SearchBarView(
      {this.searchHintText = "搜索",
      this.isEnabled = false,
      this.padding = const EdgeInsets.all(16.0),
      this.textEditingController,
      this.onTap,
      this.isAutofocus = false,
      this.showPrefixIcon = false});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            suffixIcon: showPrefixIcon
                ? IconButton(
                    onPressed: () => textEditingController!.clear(),
                    icon: Icon(Icons.cancel, color: Colors.grey),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(11),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
