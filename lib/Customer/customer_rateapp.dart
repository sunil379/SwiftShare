// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class RateApp extends StatefulWidget {
  const RateApp({super.key});

  @override
  _RateAppState createState() => _RateAppState();
}

class _RateAppState extends State<RateApp> {
  int? _userRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rate Application",
          style: TextStyle(
            fontSize: 28,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Your Opinion matters to us",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              "How would you Rate Our App Experience?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Give us a quick rating so we know what you think.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            _userRating != null
                ? Column(
                    children: [
                      Text(
                        "You rated us $_userRating stars!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        _buildButton('Later', Colors.white, Colors.red),
                        _buildButton(
                            'Rate Now', Colors.deepPurple, Colors.white),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor),
        ),
        child: SizedBox(
          width: 170,
          height: 50,
          child: ElevatedButton(
            onPressed: text == 'Later'
                ? () {
                    Navigator.pop(context);
                  }
                : () {
                    _showRatingDialog();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 2,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarButton(int rating) {
    return IconButton(
      icon: Icon(
        _userRating != null && rating <= _userRating!
            ? Icons.star
            : Icons.star_border,
        size: 40,
        color: Colors.orange,
      ),
      onPressed: () {
        setState(() {
          if (_userRating == rating) {
            _userRating = null; // Deselect the current rating
          } else {
            _userRating = rating; // Select the new rating
          }
        });
      },
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Please select your rating:'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildStarButton(1),
                  _buildStarButton(2),
                  _buildStarButton(3),
                  _buildStarButton(4),
                  _buildStarButton(5),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  // ignore: avoid_print
                  print('Submitted rating: $_userRating');
                });
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
