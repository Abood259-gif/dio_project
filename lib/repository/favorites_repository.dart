import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio_project/entities/favorites_entity.dart';
import 'package:dio_project/models/favorites_model.dart';
import 'package:dio_project/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FavoritesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FavoritesRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  CollectionReference<Map<String, dynamic>> _favoritesRef() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  Stream<List<FavoriteEntity>> watchFavorites() {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _favoritesRef().snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FavoriteModel.fromFirestore(doc.data()).toEntity())
          .toList();
    });
  }


  Future<void> addFavorite(FavoriteEntity favorite) async {
    final model = FavoriteModel(
      productId: favorite.productId,
      title: favorite.title,
      image: favorite.image,
      price: favorite.price,
    );
    await _favoritesRef().doc(favorite.productId).set(model.toFirestoreMap());
  }

  Future<void> removeFavorite(String productId) async {
    await _favoritesRef().doc(productId).delete();
  }

  Future<void> toggleFavorite(FavoriteEntity favorite) async {
    final docRef = _favoritesRef().doc(favorite.productId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      final model = FavoriteModel(
        productId: favorite.productId,
        title: favorite.title,
        image: favorite.image,
        price: favorite.price,
      );
      await docRef.set(model.toFirestoreMap());
    }
  }

  Future<bool> isFavorite(String productId) async {
    final doc = await _favoritesRef().doc(productId).get();
    return doc.exists;
  }
}

/// Provider for FirebaseFirestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provider for FavoritesRepository
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FavoritesRepository(
    firestore: firestore,
    firebaseAuth: firebaseAuth,
  );
});