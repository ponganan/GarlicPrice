class UserList {
  String id;
  final String userPic;
  final String name;
  final String tel;
  final String city;
  final String imagePath;

  UserList({
    this.id = '',
    required this.userPic,
    required this.name,
    required this.tel,
    required this.city,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userpic': userPic,
        'name': name,
        'tel': tel,
        'city': city,
        'imagePath': imagePath,
      };

  static UserList fromJson(Map<String, dynamic> json) => UserList(
        id: json['id'],
        userPic: json['userpic'],
        name: json['name'],
        tel: json['tel'],
        city: json['city'],
        imagePath: json['imagePath'],
      );
}
