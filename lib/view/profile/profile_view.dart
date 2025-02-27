import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  User? user;
  Map<String, dynamic>? userData;
  String? profileImageBase64;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>?;
          nameController.text = userData?['name'] ?? '';
          mobileController.text = userData?['mobile'] ?? '';
          addressController.text = userData?['address'] ?? '';
        });
      }
      await getProfileImage();
    }
  }

  Future<void> getProfileImage() async {
    DataSnapshot snapshot =
        await _database.child('users/${user!.uid}/profile_image').get();
    if (snapshot.exists) {
      setState(() {
        profileImageBase64 = snapshot.value as String?;
      });
    }
  }

  Future<void> saveUserData() async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).set({
        'name': nameController.text,
        'mobile': mobileController.text,
        'address': addressController.text,
      });

      if (image != null) {
        File file = File(image!.path);
        List<int> imageBytes = await file.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        await _database
            .child('users/${user!.uid}/profile_image')
            .set(base64Image);

        setState(() {
          profileImageBase64 = base64Image;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 46),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Avatar Section
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: image != null
                                ? Image.file(File(image!.path),
                                    fit: BoxFit.cover)
                                : profileImageBase64 != null
                                    ? Image.memory(
                                        base64Decode(profileImageBase64!),
                                        fit: BoxFit.cover)
                                    : const Icon(Icons.person,
                                        size: 70, color: Colors.grey),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: const Icon(Icons.edit,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// Greeting
                    Text(
                      "Hi, ${userData?['name'] ?? ''}!",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),

                    /// User Info Fields
                    buildTextField("Name", nameController),
                    buildTextField("Mobile", mobileController),
                    buildTextField("Address", addressController),

                    const SizedBox(height: 20),

                    /// Save button
                    RoundButton(
                      title: "Save Changes",
                      onPressed: () {
                        saveUserData();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  /// Widget helper for input fields
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
