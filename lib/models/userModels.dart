class User {
  String username;
  String password;
  String name;

  User({required this.username, required this.password, required this.name});
}

User user1 = User(username: "admingacoan", password: "1221", name: "JOKOWI");

User user2 = User(username: "Septian", password: "124240172", name: "Septian");

List<User> userList = [user1, user2];
