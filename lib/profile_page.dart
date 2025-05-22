import 'package:flutter/material.dart';
import 'firebase_auth_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage(this.uid, {super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  Map<String, dynamic>? _userData;
  File? _profileImage;
  String? _selectedAvatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    var data = await _authService.getUserDetails(widget.uid);
    if (mounted) {
      setState(() {
        _userData = data;
        _selectedAvatar = _userData?['avatar'] ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      String? imageUrl = await _authService.uploadProfilePicture(widget.uid, _profileImage!);
      if (imageUrl != null) {
        setState(() {
          _userData?['profileImage'] = imageUrl;
        });
      }
    }
  }

  void _selectAvatar(String avatarPath) async {
    setState(() {
      _selectedAvatar = avatarPath;
    });
    await _authService.updateAvatar(widget.uid, avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (_selectedAvatar != null && _selectedAvatar!.isNotEmpty)
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(_selectedAvatar!),
                  ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (_userData?['profileImage'] != ''
                      ? NetworkImage(_userData!['profileImage'])
                      : const AssetImage("assets/default_avatar.png") as ImageProvider),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _userData?['name'] ?? 'Loading...',
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(_userData?['email'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 5),
            Text(_userData?['phone'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 20),

            const Text(
              "Select Avatar",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _avatarOption("assets/avatars/avatar1.jpg"),
                  _avatarOption("assets/avatars/avatar2.jpg"),
                  _avatarOption("assets/avatars/avatar3.jpg"),
                  _avatarOption("assets/avatars/avatar4.jpg"),
                  _avatarOption("assets/avatars/avatar5.jpg"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _settingsOption(Icons.settings, "Settings"),
            _settingsOption(Icons.lock, "Privacy"),
            _settingsOption(Icons.help, "Help & Support"),
            _settingsOption(Icons.logout, "Logout", isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _avatarOption(String avatarPath) {
    return GestureDetector(
      onTap: () => _selectAvatar(avatarPath),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(avatarPath),
            ),
            if (_selectedAvatar == avatarPath)
              const Icon(Icons.check_circle, color: Colors.green, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _settingsOption(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.white),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : Colors.white, fontSize: 18)),
      onTap: () {
        if (isLogout) {
          _authService.signOut();
          Navigator.pop(context);
        }
      },
    );
  }
}
