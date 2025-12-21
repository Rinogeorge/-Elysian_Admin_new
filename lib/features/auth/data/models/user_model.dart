import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    super.photoURL,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoURL: data['photoURL'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'name': name,
      if (photoURL != null) 'photoURL': photoURL,
    };
  }
}
