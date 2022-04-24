import 'package:get/get.dart';


import '../const/constants.dart';
import '../model/user_model.dart';

class SearchController extends GetxController {
  final Rx<List<UserModel>> _searchedUsers = Rx<List<UserModel>>([]);

  List<UserModel> get searchedUsers => _searchedUsers.value;

  searchUser(String search) async {
    _searchedUsers.bindStream(userCollection
        .where('name', isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var elm in event.docs) {
        users.add(UserModel.fromSnap(elm));
      }
      return users;
    }));
  }
}
