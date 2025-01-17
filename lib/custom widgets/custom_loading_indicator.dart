import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white, // Background color for the loader box
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2), // Optional border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31C48D)),
          ),
        ),
      ),
    );
  }
}