

import '../../models/vault_item_model.dart';

abstract class VaultState {}

class VaultInitial extends VaultState {}

class VaultLoading extends VaultState {}

class VaultLoaded extends VaultState {
  final List<VaultItemModel> items;
  VaultLoaded(this.items);
}

class VaultError extends VaultState {
  final String message;
  VaultError(this.message);
}