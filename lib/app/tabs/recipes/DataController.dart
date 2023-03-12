import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController{
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        QuerySnapshot snapshot = await firebaseFirestore.collection(collection).get();
        return snapshot.docs;
  }

  Future queryData(String queryString) async{
    return FirebaseFirestore.instance.collection('Recipes').orderBy('searchName').startAt([queryString.toLowerCase()]).endAt([queryString.toLowerCase() + '\uf8ff']).get();
  }

  Future queryData2(String queryString) async{
    return FirebaseFirestore.instance.collection('Recipes').where('Ingredient', arrayContains: queryString.toLowerCase()).get();
  }
}