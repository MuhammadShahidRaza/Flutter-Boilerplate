import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? profileImage;
  final VoidCallback? onNotificationTap;

  const HomeAppBar({
    super.key,
    required this.userName,
    this.profileImage,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM,
          vertical: Dimens.spacingS,
        ),
        child: Row(
          spacing: Dimens.spacingM,
          children: [
            // 👤 User avatar
            ClipOval(
              child: AppImage(
                path: profileImage ?? AppAssets.user,
                width: 45,
                height: 45,
              ),
            ),

            // 🧑‍💼 Welcome text and name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    Common.welcomeComma,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    spacing: Dimens.spacingS,
                    children: [
                      AppText(
                        userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.bottomTabText,
                        ),
                      ),
                      AppText('👋', style: TextStyle(fontSize: Dimens.fontXL)),
                    ],
                  ),
                ],
              ),
            ),

            // 🔔 Notification icon
            AppIcon(
              icon: Icons.notifications_none_rounded,
              borderWidth: 1,
              color: AppColors.bottomTabText,
              padding: EdgeInsets.all(10),
              onTap: onNotificationTap,
              borderRadius: Dimens.radiusXL,
              backgroundColor: AppColors.lightWhite,
              borderColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
