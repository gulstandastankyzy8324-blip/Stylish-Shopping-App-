import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/storage/user_storage.dart';
import '../auth/auth_signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  bool isLoading = true;
  bool isSaving = false;
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    nameController.text =
        await UserStorage.getName();

    emailController.text =
        await UserStorage.getEmail();

    addressController.text =
        await UserStorage.getAddress();

    cityController.text =
        await UserStorage.getCity();

    countryController.text =
        await UserStorage.getCountry();

    pincodeController.text =
        await UserStorage.getPincode();

    final savedAvatar = await UserStorage.getAvatar();
    if (!mounted) return;

    setState(() {
      avatarPath = savedAvatar;
      isLoading = false;
    });
  }

  Future<void> chooseAvatar() async {
    final XFile? image =
        await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1000,
    );

    if (image == null) return;

    await UserStorage.saveAvatar(image.path);

    if (!mounted) return;

    setState(() {
      avatarPath = image.path;
    });
  }

  Future<void> removeAvatar() async {
   await UserStorage.removeAvatar();
    if (!mounted) return;

    setState(() {
      avatarPath = null;
    });
  }

  void showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFFFF3B61),
                  ),
                  title: const Text(
                    'Choose from gallery',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    chooseAvatar();
                  },
                ),
                if (avatarPath != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Remove photo',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      removeAvatar();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> saveProfile() async {
    setState(() {
      isSaving = true;
    });

    await UserStorage.saveProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      country: countryController.text.trim(),
      pincode: pincodeController.text.trim(),
    );

    await Future.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> logout() async {
    await UserStorage.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SignInScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF3B61),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                22,
                10,
                22,
                35,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: showAvatarOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 49,
                          backgroundColor:
                              const Color(0xFFFFE4EA),
                          backgroundImage:
                              avatarPath != null &&
                                      File(avatarPath!)
                                          .existsSync()
                                  ? FileImage(
                                      File(avatarPath!),
                                    )
                                  : null,
                          child: avatarPath == null ||
                                  !File(avatarPath!)
                                      .existsSync()
                              ? const Icon(
                                  Icons.person,
                                  size: 58,
                                  color: Color(
                                    0xFFFF3B61,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 31,
                            height: 31,
                            decoration:
                                const BoxDecoration(
                              color:
                                  Color(0xFFFF3B61),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: showAvatarOptions,
                    child: const Text(
                      'Change profile photo',
                      style: TextStyle(
                        color: Color(0xFFFF3B61),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  sectionTitle(
                    'Personal Details',
                  ),
                  const SizedBox(height: 17),
                  profileField(
                    title: 'Username',
                    controller: nameController,
                  ),
                  profileField(
                    title: 'Email Address',
                    controller: emailController,
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 20),
                  sectionTitle(
                    'Business Address Details',
                  ),
                  const SizedBox(height: 17),
                  profileField(
                    title: 'Pincode',
                    controller:
                        pincodeController,
                    keyboardType:
                        TextInputType.number,
                  ),
                  profileField(
                    title: 'Address',
                    controller:
                        addressController,
                  ),
                  profileField(
                    title: 'City',
                    controller: cityController,
                  ),
                  profileField(
                    title: 'Country',
                    controller:
                        countryController,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isSaving ? null : saveProfile,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFF3B61),
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton.icon(
                    onPressed: logout,
                    icon: const Icon(
                      Icons.logout,
                    ),
                    label:
                        const Text('Log out'),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          const Color(0xFFFF3B61),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget profileField({
    required String title,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(7),
                borderSide: const BorderSide(
                  color: Color(0xFFDDDDDD),
                ),
              ),
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(7),
                borderSide: const BorderSide(
                  color: Color(0xFFFF3B61),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}