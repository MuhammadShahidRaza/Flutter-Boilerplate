import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final String? profileImage;
  final VoidCallback? onNotificationTap;
  final Widget? iconWidget;
  final double containerGap;
  final bool wantProfileTap;

  const HomeAppBar({
    super.key,
    this.userName,
    this.profileImage,
    this.containerGap = Dimens.spacingMSmall,
    this.iconWidget,
    this.onNotificationTap,
    this.wantProfileTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void onProfileTap() {
      if (!wantProfileTap) return;
      context.navigate(AppRoutes.editProfile);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM,
          vertical: Dimens.spacingS,
        ),
        child: Row(
          spacing: containerGap,
          children: [
            // 👤 User avatar
            Consumer<UserProvider>(
              builder: (context, provider, child) {
                final profileImage =
                    provider.user?.profileImage ?? AppAssets.user;
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
                      height: 1.0,
                      color: AppColors.textSecondary,
                    ),
                    onTap: onProfileTap,
                  ),
                  Row(
                    spacing: Dimens.spacingS,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: context.w(0.3)),
                        child: Consumer<UserProvider>(
                          builder: (context, provider, child) {
                            final name = provider.fullName.isNotEmpty == true
                                ? provider.fullName
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

            iconWidget ?? SizedBox.shrink(),

            // 🔔 Notification icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppIcon(
                  icon: Icons.notifications_none_rounded,
                  borderWidth: 1,
                  color: AppColors.bottomTabText,
                  padding: const EdgeInsets.all(5),
                  onTap: onNotificationTap,
                  borderRadius: Dimens.radiusXL,
                  backgroundColor: AppColors.lightWhite,
                  borderColor: AppColors.primary,
                ),

                /// Notification Badge
                Positioned(
                  top: -5,
                  right: -5,
                  child: Consumer<UserProvider>(
                    builder: (context, provider, child) {
                      final int count =
                          provider.user?.unreadNotificationCount ?? 0;
                      if (count == 0) return const SizedBox.shrink();

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: AppText(
                            count > 99 ? '99+' : count.toString(),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
