import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../providers/user_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  File? _pickedImage;
   //late  String? imageUrl;
  // const ProfileAvatar({this.imageUrl});
  bool _isEditing = false;
   String? name, photo;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserFromProvider());
  }

  void _loadUserFromProvider() {
    final provider = context.read<UserProvider>();
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = provider.userData;

    if (currentUser != null) {
      name = currentUser.displayName ?? userData?.name;
      photo = currentUser.photoURL ?? '';
      _nameController.text = userData?.name ?? currentUser.displayName ?? '';
      _emailController.text = currentUser.email ?? userData?.email ?? '';
      _phoneController.text = userData?.phone ?? '';
      _gender = userData?.gender;
      if (userData?.dob != null) {
        _dobController.text = userData!.dob.toLocal().toString().split(' ')[0];
      }
    }
  }

  Future<void> saveUserData(AppUser user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await docRef.set(user.toMap(), SetOptions(merge: true));
    context.read<UserProvider>().setUser(user); // Update provider
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        double? fontSize,
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
        VoidCallback? onTap,
        Widget? suffixIcon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[900],
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon, // ← here
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          isDense: true,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;


    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, size: 25),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "User Profile",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, ),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : photo != null
                            ? NetworkImage(photo!) as ImageProvider
                            : null,
                        child: photo == null && _pickedImage == null
                            ? const Icon(Icons.person, size: 30, color: Colors.white)
                            : null,
                      ),
                      // ❌ Removed the Positioned widget that showed the camera icon
                    ],
                  )

                ),
                Text(
                  user?.displayName ?? "No Name",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor==Colors.black?Color(0xFF26272B)  :Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Full Name"),
                      _buildTextField("", _nameController,
                          fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                          readOnly: !_isEditing),
                      _label("Email"),
                      _buildTextField("Email", _emailController, fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                          keyboardType: TextInputType.emailAddress, readOnly: true),
                      _label("Phone Number"),
                      _buildTextField("Phone", _phoneController, fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                          keyboardType: TextInputType.phone, readOnly: !_isEditing),
                      _label("Gender"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: DropdownButtonFormField<String>(
                          value: _gender,
                          style: const TextStyle(color: Colors.white),
                          decoration: _dropdownDecoration(),
                          items: ['Male', 'Female', 'Other']
                              .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g, style: const TextStyle(color: Colors.white)),
                          ))
                              .toList(),
                          onChanged: _isEditing ? (val) => setState(() => _gender = val) : null,
                        ),
                      ),
                      _label("Date of Birth"),
                      _buildTextField(
                        "",
                        _dobController,
                        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                        readOnly: true,
                        onTap: !_isEditing
                            ? null
                            : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _dobController.text =
                              picked.toLocal().toString().split(' ')[0];
                            });
                          }
                        },
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70), // ← icon added
                      )
                      ,
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child:TextButton(
                          onPressed: () async {
                            if (_isEditing) {
                              if (_formKey.currentState!.validate()) {
                                final user = FirebaseAuth.instance.currentUser!;
                                final appUser = AppUser(
                                  uid: user.uid,
                                  email: user.email ?? '',
                                  name: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  gender: _gender ?? '',
                                  dob:
                                  DateTime.parse(_dobController.text.trim()),
                                );
                                await saveUserData(appUser);
                                setState(() => _isEditing = false);
                              }
                            } else {
                              setState(() => _isEditing = true);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor==Colors.black?Colors.red:Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text(
                            _isEditing ? "Save" : "Edit",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }

  Widget _label(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: Theme.of(context)
          .textTheme
          .bodySmall),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      hintText: 'Select Gender',
      hintStyle: const TextStyle(color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
