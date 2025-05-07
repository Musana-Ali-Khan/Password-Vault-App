import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_bloc/bloc/vaultBloc/vault_event.dart';
import 'package:login_bloc/bloc/vaultBloc/vault_state.dart';
import '../../models/vault_item_model.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  VaultBloc() : super(VaultInitial()) {
    on<LoadVaultItems>(_loadVaultItems);
    on<AddVaultItem>(_addVaultItem);

    on<DeleteVaultItem>(_deleteVaultItem);

  }

  final _vaultRef = FirebaseFirestore.instance.collection('vault');

  Future<void> _loadVaultItems(LoadVaultItems event, Emitter<VaultState> emit) async {
    emit(VaultLoading());
    try {
      final querySnapshot = await _vaultRef.where('userId', isEqualTo: event.userId).get();
      final items = querySnapshot.docs
          .map((doc) => VaultItemModel.fromMap(doc.data(), doc.id))
          .toList();

      emit(VaultLoaded(items));
    } catch (e) {
      emit(VaultError('Failed to load items'));
    }
  }

  Future<void> _addVaultItem(AddVaultItem event, Emitter<VaultState> emit) async {
    try {
      await _vaultRef.add(event.item.toMap());
      add(LoadVaultItems(event.item.userId));
    } catch (e) {
      emit(VaultError('Failed to add item'));
    }
  }


  Future<void> _deleteVaultItem(DeleteVaultItem event, Emitter<VaultState> emit) async {
    try {
      await _vaultRef.doc(event.id).delete();
      add(LoadVaultItems(event.userID)); // reload after deleting
    } catch (e) {
      emit(VaultError(e.toString()));
    }
  }
}
