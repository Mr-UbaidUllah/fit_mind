import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/routes_names.dart';
import '../../../view_model/auth_view_model.dart';
import '../../../view_model/profile_view_model.dart';
import '../../profile/profile_screen.dart';
import '../../ai_coach/ai_coach_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Providers to get fresh profile data
    final authProvider = Provider.of<AuthViewModel>(context);
    final profileProvider = Provider.of<ProfileViewModel>(context);

    // Get current user (either from Auth or Profile provider)
    final User? user = profileProvider.user ?? FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. USER PROFILE HEADER
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              user?.displayName ?? "Fit Mind User",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              user?.email ?? "No Email",
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                // Navigate to Profile when clicking the avatar
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: (profileProvider.selectedImage != null)
                    ? FileImage(profileProvider.selectedImage!)
                    : (user?.photoURL != null
                    ? NetworkImage(user!.photoURL!) as ImageProvider
                    : null),
                child: (profileProvider.selectedImage == null && user?.photoURL == null)
                    ? const Icon(Icons.person, size: 40, color: Colors.blueAccent)
                    : null,
              ),
            ),
          ),

          // 2. DRAWER ITEMS
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Colors.blueAccent),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context), // Close drawer (already on home)
          ),

          ListTile(
            leading: const Icon(Icons.person_rounded, color: Colors.blueAccent),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.smart_toy_outlined, color: Colors.blueAccent),
            title: const Text('AI Coach'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("NEW", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AICoachScreen()));
            },
          ),

          const Divider(), // Visual separator

          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
            child: Text("Settings", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('App Settings'),
            onTap: () {
              // Placeholder for settings logic or permission handler
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings coming soon!")));
            },
          ),

          // 3. LOGOUT BUTTON
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              // Close drawer first
              Navigator.pop(context);

              // Perform Logout
              await authProvider.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutesNames.login, (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}