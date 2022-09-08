class UserList {
  String id;
  final String name;
  final int tel;
  final String city;

  UserList({
    this.id = '',
    required this.name,
    required this.tel,
    required this.city,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tel': tel,
        'city': city,
      };

  static UserList fromJson(Map<String, dynamic> json) => UserList(
        id: json['id'],
        name: json['name'],
        tel: json['tel'],
        city: json['city'],
      );
}
