import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/domain/entities/atm_status.dart';

final databaseProvider = Provider<CloudFirestore>((ref) => CloudFirestore());

FirebaseFirestore cloudFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class CloudFirestore {
  

  Future uploadAtmStatusToDatabase({required AtmStatus atm, required uid }) async {
    await cloudFirestore.collection('ATM Status').doc(uid).set(atm.toJson());
  }

  Future<AtmStatus?> getAtmStatus(uid) async {
    DocumentSnapshot snapshot =
        await cloudFirestore.collection('ATM Status').doc(uid).get();
    if (snapshot.exists) {
      AtmStatus atm =
          AtmStatus.getModelFromJson(json: snapshot.data() as dynamic);
      return atm;}
      else{
        return null;
      }
    }
  }