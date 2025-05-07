import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vaultBloc/vault_bloc.dart';
import '../bloc/vaultBloc/vault_event.dart';
import '../bloc/vaultBloc/vault_state.dart';
import '../models/vault_item_model.dart';
import '../util/encryption_helper.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<VaultBloc>().add(LoadVaultItems(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Vault'),
      ),
      body: BlocBuilder<VaultBloc, VaultState>(
        builder: (context, state) {
          if (state is VaultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VaultLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 1.5,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return _VaultItemCard(item: item);
              },
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final platformController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final additionalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vault Item'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: platformController,
                  decoration: const InputDecoration(labelText: 'Platform Name')),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email')),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password')),
              TextField(
                  controller: additionalController,
                  decoration: const InputDecoration(labelText: 'Additional Details')),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final vaultItem = VaultItemModel(
                id: '',
                platformName: EncryptionHelper.encryptText(platformController.text),
                email: EncryptionHelper.encryptText(emailController.text),
                password: EncryptionHelper.encryptText(passwordController.text),
                additionalDetails: EncryptionHelper.encryptText(additionalController.text),
                userId: userId,
              );
              context.read<VaultBloc>().add(AddVaultItem(vaultItem));
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}

class _VaultItemCard extends StatefulWidget {
  final VaultItemModel item;

  const _VaultItemCard({Key? key, required this.item}) : super(key: key);

  @override
  State<_VaultItemCard> createState() => _VaultItemCardState();
}

class _VaultItemCardState extends State<_VaultItemCard> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTap: () => _showVaultDetailsDialog(context, item),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                EncryptionHelper.decryptText(item.platformName),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(
                EncryptionHelper.decryptText(item.email),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVaultDetailsDialog(BuildContext context, VaultItemModel item) {
    bool isDecrypted = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isDecrypted
                ? EncryptionHelper.decryptText(item.platformName)
                : item.platformName,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${isDecrypted ? EncryptionHelper.decryptText(item.email) : item.email}'),
                const SizedBox(height: 8),
                Text('Password: ${isDecrypted ? EncryptionHelper.decryptText(item.password) : item.password}'),
                const SizedBox(height: 8),
                Text('Additional Details: ${isDecrypted ? EncryptionHelper.decryptText(item.additionalDetails) : item.additionalDetails}'),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isDecrypted ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  isDecrypted = !isDecrypted;
                });
              },
              tooltip: isDecrypted ? 'Hide' : 'Decrypt',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<VaultBloc>().add(DeleteVaultItem(item.id, item.userId));
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}

