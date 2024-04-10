import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 45,
            height: 45,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.account_circle,
            title: 'Profile Settings',
            page: const ProfileSettingsPage(),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.notifications,
            title: 'Notification Preferences',
            page: const NotificationSettingsPage(),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.security,
            title: 'Privacy & Security',
            page: const PrivacySecurityPage(),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.language,
            title: 'Language & Region',
            page: const LanguageRegionPage(),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.settings,
            title: 'App Settings',
            page: const AppSettingsPage(),
          ),
          _buildSettingsItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            page: const HelpSupportPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return Card(
      color: Colors.lightBlueAccent.shade200,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
          size: 32.0,
        ),
        title: Text(
          title,
          style: const TextStyle(
            // color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right_outlined,
          color: Colors.black,
          size: 28,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: const Center(
        child: Text('Profile Settings Screen'),
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
      ),
      body: const Center(
        child: Text('Notification Preferences Screen'),
      ),
    );
  }
}

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: const Center(
        child: Text('Privacy & Security Screen'),
      ),
    );
  }
}

class LanguageRegionPage extends StatelessWidget {
  const LanguageRegionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Region'),
      ),
      body: const Center(
        child: Text('Language & Region Screen'),
      ),
    );
  }
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: const Center(
        child: Text('App Settings Screen'),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: const Center(
        child: Text('Help & Support Screen'),
      ),
    );
  }
}
