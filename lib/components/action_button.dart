import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.textOne,
    required this.textTwo,
    required this.login,
    required this.signUp,
  });

  final String label;
  final String textOne;
  final String textTwo;
  final Future<void> Function() login;
  final Future<void> Function() signUp;

  @override
  // ignore: library_private_types_in_public_api
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isLoading = false;

  void _toggleLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _handleSignUp() async {
    _toggleLoading(true);
    try {
      await widget.signUp();
    } finally {
      _toggleLoading(false);
    }
  }

  Future<void> _handleLogin() async {
    _toggleLoading(true);
    try {
      await widget.login();
    } finally {
      _toggleLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C57A6),
                foregroundColor: Colors.white,
                minimumSize: const Size(400, 60),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(5)), // no border radius
                ),
              ),
              onPressed: _isLoading ? null : _handleSignUp,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.label,
                        style: const TextStyle(),
                      ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.textOne,
                style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              TextButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: Text(widget.textTwo),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
