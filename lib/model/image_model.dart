class ImageModel {
  String? docid;
  String? userid;
  String? imageurl;
  String? variable;
  String? slug;
  String? description;

  ImageModel(
      { required this.docid,
      required this.userid,
     required this.imageurl,
     required this.variable,
     required this.slug,
     required this.description});

  ImageModel.fromMap(Map<String, dynamic> map) {
    docid = map['docid'];
    userid = map['userid'];
    imageurl = map['imageurl'];
    variable = map['variable'];
    slug = map['slug'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      "docid": docid,
      "userid": userid,
      "imageurl": imageurl,
      "variable": variable,
      "slug": slug,
      "description": description
    };
  }
}
