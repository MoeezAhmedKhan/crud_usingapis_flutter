import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUserId({required int userId, required int roleId}) async {
    await prefs.setInt('user_id', userId);
    await prefs.setInt('role_id', roleId);
  }

  Map<String, dynamic>? getUserData() {
    int? userId = prefs.getInt('user_id');
    int? roleId = prefs.getInt('role_id');
    print("User Id on SP is $userId");
    print("User Id on SP is $roleId");
    return {
      "user_id": userId,
      "role_id": roleId,
    };
  }
}
