import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_prof_mang_bloc.dart';
import '../user_edit_pro_view/user_edit_pro_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EmployeeProfilePage extends StatefulWidget {
  final int userId;
  final String name;
  const EmployeeProfilePage({super.key, required this.userId, this.name = ''});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  int? id;
  File? _imageFile; // Declaring the variable
  String _profilePictureUrl = ''; // Default value

  @override
  void initState() {
    super.initState();
    id = widget.userId;
    print('After editing Page ============== $id');

    if (id != null) {
      _fetchUserProfile();
    } else {
      print("Error: userId is null in EmployeeProfilePage");
    }
  }
 Future<bool> _hasInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
  void _fetchUserProfile({String? updatedImage}) {
    context.read<UserProfMangBloc>().add(UserProfMangEvent.userProMan(
          id: id.toString(),
          profilePicture: updatedImage ?? '',
          name: '',
          email: '',
          place: '',
          address: '',
          phone: '',
          utype: '',
          longitude: '',
          latitude: '',
          ward: '',
        ));
  }

  String getFullImageUrl(String? imagePath) {
    const String baseUrl = "https://417sptdw-8001.inc1.devtunnels.ms";
    if (imagePath == null || imagePath.isEmpty) {
      return "https://via.placeholder.com/150"; // Default placeholder image
    }
    return Uri.encodeFull("$baseUrl/$imagePath");
  }

  void _editProfile() async {
    final updatedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeProfilePage(userId: id!),
      ),
    );

    if (updatedImage != null) {
      setState(() {
        _profilePictureUrl = updatedImage; // Update profile picture URL
      });
      _fetchUserProfile(updatedImage: updatedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Profile")),
      body: BlocListener<UserProfMangBloc, UserProfMangState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (user) {
              setState(() {
                _profilePictureUrl = user.profilePicture ?? '';
              });
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(message, style: const TextStyle(color: Colors.red)),
                ),
              );
            },
          );
        },
        child: BlocBuilder<UserProfMangBloc, UserProfMangState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text("No Data Available")),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (userData) => Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.indigoAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (_profilePictureUrl.isNotEmpty
                                ? NetworkImage(
                                    getFullImageUrl(_profilePictureUrl))
                                : const AssetImage('assets/images/person.png')),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      userData.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      userData.email,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInfoRow("Phone", userData.phone),
                            buildInfoRow("Address", userData.address),
                            buildInfoRow("Place", userData.place),
                            buildInfoRow("Ward", userData.ward.toString()),
                            buildInfoRow("Longitude", userData.longitude),
                            buildInfoRow("Latitude", userData.latitude),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _editProfile,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Edit Profile"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              error: (message) => Center(
                child: Text(message, style: const TextStyle(color: Colors.red)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "N/A",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
