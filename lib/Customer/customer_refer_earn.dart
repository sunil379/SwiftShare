import 'package:flutter/material.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Refer & Earn',
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refer friends and earn rewards!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'How it works:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Share your referral code/link with friends.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. When your friend signs up using your referral code/link, both of you earn rewards.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. The more friends you refer, the more rewards you earn!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Referral Code:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildReferralCodeDisplay('YOUR_REFERRAL_CODE_HERE'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement share functionality to share referral code/link
                _shareReferralCode(context);
              },
              child: const Text('Share Your Referral Code'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCodeDisplay(String referralCode) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        referralCode,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _shareReferralCode(BuildContext context) {
    // Implement sharing functionality (e.g., using share package or custom sharing logic)
    const String referralCode = 'YOUR_REFERRAL_CODE_HERE';
    // ignore: unused_local_variable
    const String shareText =
        'Use my referral code $referralCode to earn rewards!';
    // Implement sharing logic here (e.g., using share package)
    // For example:
    // Share.share(shareText);
    // Show feedback to user after sharing if needed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code shared!')),
    );
  }
}
