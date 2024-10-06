class DescriptionModel {
  String? textid;
  String? userid;
  String? imageurl;
  String? variable;
  String? description;

  DescriptionModel(
      {required this.textid,
      required this.userid,
      required this.imageurl,
      required this.variable,
      required this.description});

  DescriptionModel.fromMap(Map<String, dynamic> map) {
    textid = map['textid'];
    userid = map['userid'];
    imageurl = map['imageurl'];
    variable = map['variable'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
     "textid" : textid,
      "userid": userid,
      "imageurl": imageurl,
      "variable": variable,
      "description": description
    };
  }
}
