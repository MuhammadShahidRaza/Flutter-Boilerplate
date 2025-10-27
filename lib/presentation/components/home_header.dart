import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final String? profileImage;
  final VoidCallback? onNotificationTap;

  const HomeAppBar({
    super.key,
    this.userName,
    this.profileImage,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void onProfileTap() {
      context.navigate(AppRoutes.editProfile);
    }

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
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                final profileImage = auth.user?.profileImage ?? AppAssets.user;
                return AppImage(
                  path: profileImage,
                  width: 45,
                  height: 45,
                  onTap: onProfileTap,
                  isCircular: true,
                );
              },
            ),

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
                    onTap: onProfileTap,
                  ),
                  Row(
                    spacing: Dimens.spacingS,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, user, child) {
                          final name = user.fullName.isNotEmpty
                              ? user.fullName
                              : Common.guest;
                          return AppText(
                            name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.bottomTabText,
                            ),
                            onTap: onProfileTap,
                          );
                        },
                      ),
                      AppText(
                        '👋',
                        style: TextStyle(fontSize: Dimens.fontXL),
                        onTap: onProfileTap,
                      ),
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
