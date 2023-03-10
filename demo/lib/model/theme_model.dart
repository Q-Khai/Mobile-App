class ThemesProduct {
  final String idtheme;
  final String name;
  final int status;

  ThemesProduct({
    required this.idtheme, 
    required this.name, 
    required this.status});
}


// class ThemesProduct {
//   String? idtheme;
//   String? name;
//   int? status;
//   String? idcreator;

//   ThemesProduct({this.idtheme, this.name, this.status, this.idcreator});

//   ThemesProduct.fromJson(Map<String, dynamic> json) {
//     idtheme = json['idtheme'];
//     name = json['name'];
//     status = json['status'];
//     idcreator = json['idcreator'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['idtheme'] = this.idtheme;
//     data['name'] = this.name;
//     data['status'] = this.status;
//     data['idcreator'] = this.idcreator;
//     return data;
//   }
// }