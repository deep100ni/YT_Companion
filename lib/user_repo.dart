import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip_planner/models/user.dart';

class UserRepo{

  final coll = FirebaseFirestore.instance.collection('users');

  Future<AppUser?> getUser(String email) async{
    final querySnapshot = await coll.where('email', isEqualTo: email)
        .limit(1)
        .get();

    if(querySnapshot.docs.isNotEmpty){
      final doc = querySnapshot.docs.first;
      return AppUser.fromJson(doc.data());
    }

    return null;
  }

  Future<void> saveUser(AppUser user) async{
    await coll.add(user.toJson());
  }
}