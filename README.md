# Password Vault App

A simple and secure **Password Vault** built with **Flutter** and **BLoC** to manage your sensitive credentials.

## Features
- 🔒 Add and store **encrypted** platform credentials (Platform, Email, Password, Additional Details)
- 🔎 View **only platform name and email** on the home screen
- 📋 Tap a vault item to **view full details** inside a dialog
- 🧩 **Decrypt/Hide** data inside the dialog
- 🗑️ **Delete** vault items easily
- 🔑 **AES Encryption** with a fixed key and IV

## Tech Stack
- Flutter (UI Framework)
- flutter_bloc (State Management)
- encrypt (AES Encryption/Decryption)

## Project Structure
```plaintext
lib/
 ├── bloc/
 ├── models/
 ├── screens/
 ├── util/
 └── main.dart
```


## How It Works
- Vault items are stored with encrypted fields using AES encryption.
- Home screen displays platform name and email only.
- Clicking a vault item opens a dialog showing all encrypted fields.
- User can **decrypt/hide** or **delete** the item from the dialog.

## How to Run
```bash
git clone https://github.com/your-username/password-vault-app.git
cd password-vault-app
flutter pub get
flutter run

```
## Encryption Details
- **Algorithm:** AES CBC with PKCS7 padding
- **Key:** Fixed 32-character key
- **IV:** Fixed 16-character IV
- Managed inside util/encryption_helper.dart

## Author
Developed by Musana Ali Khan
