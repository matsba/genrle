class User {
  final String username;
  final int points;

  User(this.username, this.points);

  User.init()
      : username = "",
        points = 0;
}
