import 'package:flutter/material.dart';
import 'package:chatify/core/theme/app_colors.dart';

class UserCard extends StatelessWidget {
   const UserCard({
    super.key,
    required this.username,
    required this.status,
    this.profilePhotoUrl,
  });
   final String username;
  final String status;
  final String? profilePhotoUrl;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.transparent,
            backgroundImage:  profilePhotoUrl != null
                ? NetworkImage(profilePhotoUrl!) :Image.asset(
              "assets/user.png",
              fit: BoxFit.fill,
            ).image,
          ),
          const SizedBox(width: 16),
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                 status,
                                style: const TextStyle(
                                    fontSize: 14, color: AppColors.textPrimary),
                              ),
        ],
      ),
        ],
      ),
    );
  }
}
