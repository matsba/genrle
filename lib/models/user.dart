class User {
  final String id;
  final String username;
  final int points;

  User({required this.id, required this.username, required this.points});

  User.init()
      : id = "",
        username = "",
        points = 0;

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        points = json["points"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": username,
        "email": points,
      };
}
