

import '../../models/vault_item_model.dart';

abstract class VaultEvent {}

class LoadVaultItems extends VaultEvent {
  final String userId;

  LoadVaultItems(this.userId);
}

class AddVaultItem extends VaultEvent {
  final VaultItemModel item;

  AddVaultItem(this.item);
}

class DeleteVaultItem extends VaultEvent {
  final String id;
  final String userID;
  DeleteVaultItem(this.id, this.userID);
}