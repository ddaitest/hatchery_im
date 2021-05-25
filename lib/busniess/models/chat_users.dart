import 'package:flutter/cupertino.dart';

class ChatUsers {
  String? text;
  String? secondaryText;
  String? image;
  String? time;
  ChatUsers(
      {@required this.text,
      @required this.secondaryText,
      @required this.image,
      @required this.time});
}

class ContactsUsers {
  String? text;
  String? image;
  ContactsUsers({@required this.text, @required this.image});
}
