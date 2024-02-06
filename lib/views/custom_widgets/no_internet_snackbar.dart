import 'package:flutter/material.dart';

class NoInternetSnackbar extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const NoInternetSnackbar({
    Key? key,
    required this.message,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _NoInternetSnackbarState createState() => _NoInternetSnackbarState();
}

class _NoInternetSnackbarState extends State<NoInternetSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    // Close the snackbar after a delay (adjust as needed)
    Future.delayed(const Duration(seconds: 3), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        color: widget.backgroundColor,
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12.0),
            Text(
              widget.message,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomSnackbar(BuildContext context, String message, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: NoInternetSnackbar(
        message: message,
        backgroundColor: backgroundColor,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// Example usage:
// showCustomSnackbar(context, "Your message here", Colors.blue);
