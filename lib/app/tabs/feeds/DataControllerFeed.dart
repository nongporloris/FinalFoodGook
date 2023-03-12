import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataControllerFeed extends GetxController{
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        QuerySnapshot snapshot = await firebaseFirestore.collection(collection).get();
        return snapshot.docs;
  }

  Future queryDataFeed(String queryString) async{
    return FirebaseFirestore.instance.collection('User_Profile').orderBy('searchName').startAt([queryString.toLowerCase()]).endAt([queryString.toLowerCase() + '\uf8ff']).get();
  }


}