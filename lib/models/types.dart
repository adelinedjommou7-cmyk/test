import 'dart:convert';

class Types {
  String? id;
  String? title;

  Types({this.id, this.title});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }

  static List<Types> fromJsonList(String jsonString) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) => Types.fromJson(item)).toList();
  }

  static String toJsonList(List<Types> list) {
    List<Map<String, dynamic>> jsonList =
        list.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }
}
