
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meals_management/views/modals/user_model.dart';


class DatebaseServices{
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user,String uId) async {
    await _db.collection('employees').doc(uId).set(user.toJson());
  }

  Stream<List<UserModel>> _readData(){
    final userCollection =_db.collection("employees");

    return userCollection.snapshots().map((querySnapshot)
    => querySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e)).toList());
  }

  Future<void> getEmployeeData(String uid) async{
      DocumentSnapshot documentSnapshot= await _db.collection("employees").doc(uid).get() ;
      print(documentSnapshot);
      if (documentSnapshot.exists){
        print("yes");
      }
      else{
        print("no");
      }
      UserModel user=UserModel.fromSnapshot(documentSnapshot as DocumentSnapshot<Map<String,dynamic>>);
      print(user);

      //   Map<String,dynamic> userData=  documentSnapshot.data() as Map<String,dynamic>;
      // print("userdata ${userData}");
      // return UserModel(userData['email'], userData['employee_id'], userData['password'], userData['department'], userData['floor']);
      
  }

  Future<List<Map<String,dynamic>>> getDepartments() async{
    QuerySnapshot snapshot = await _db.collection('departments').get();
    List<Map<String,dynamic>> deptList = snapshot.docs.map((doc) => doc.data() as Map<String,dynamic>).toList();

    return deptList;
  }
}