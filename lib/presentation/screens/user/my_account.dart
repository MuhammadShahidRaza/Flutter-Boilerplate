import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_AccountOption> options = [
      _AccountOption(
        icon: Icons.edit,
        title: Common.editProfile,
        onTap: () {
          context.navigate(AppRoutes.editProfile);
        },
      ),
      _AccountOption(
        icon: Icons.shopping_bag_outlined,
        title: Common.myOrders,
        onTap: () {
          // context.navigate(AppRoutes.myOrders);
        },
      ),
      _AccountOption(
        icon: Icons.location_on_outlined,
        title: Common.myAddress,
        onTap: () {
          // context.navigate(AppRoutes.myAddress);
        },
      ),
      _AccountOption(
        icon: Icons.payment_outlined,
        title: Common.payment,
        onTap: () {
          // context.navigate(AppRoutes.payment);
        },
      ),
      _AccountOption(
        icon: Icons.language_outlined,
        title: Common.language,
        onTap: () {
          // context.navigate(AppRoutes.language);
        },
      ),
      _AccountOption(
        icon: Icons.contact_mail_outlined,
        title: Common.contactUs,
        onTap: () {
          context.navigate(AppRoutes.contactUs);
        },
      ),
      _AccountOption(
        icon: Icons.article_outlined,
        title: Common.termsAndConditions,
        onTap: () {
          context.navigate(AppRoutes.termsAndConditions);
        },
      ),
      _AccountOption(
        icon: Icons.privacy_tip_outlined,
        title: Common.privacyPolicy,
        onTap: () {
          context.navigate(AppRoutes.privacyPolicy);
        },
      ),
      _AccountOption(
        icon: Icons.delete_outline,
        title: Common.deleteAccount,
        onTap: () {
          AppDialog.show(
            context,
            title: Common.deleteAccount,
            borderColor: AppColors.primary,
            borderWidth: 4,
            borderRadius: Dimens.radiusL,
            imageSize: 150,
            content: AppText(
              maxLines: 3,
              textAlign: TextAlign.center,
              Common.doYouWantToDeleteAccount,
            ),
            primaryButtonText: Auth.letsExploreApp,
            onPrimaryPressed: () => {
              AuthService.removeToken(),
              context.replacePage(AppRoutes.getStarted),
            },
            backgroundColor: AppColors.lightWhite,
            crossAxisAlignment: CrossAxisAlignment.center,
            insetPadding: EdgeInsets.all(Dimens.spacingXXL),
          );
        },
      ),
    ];

    return AppWrapper(
      scrollable: true,
      safeArea: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenMarginVertical,
            ),
            child: Column(
              children: options
                  .map(
                    (e) => ListTile(
                      leading: AppIcon(icon: e.icon, color: AppColors.primary),
                      title: AppText(e.title),
                      trailing: const AppIcon(
                        icon: Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: e.onTap,
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacingM),
            child: AppButton(
              title: Common.logout,
              onPressed: () {
                AuthService.removeToken();
                context.replacePage(AppRoutes.getStarted);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 🔹 Header background
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimens.radiusL),
                bottomRight: Radius.circular(Dimens.radiusL),
              ),
            ),
          ),

          // 🔹 Profile image
          Positioned(
            top: 110, // half overlaps header
            child: Consumer<AuthProvider>(
              builder: (context, auth, child) {
                final profileImage = auth.user?.profileImage ?? AppAssets.user;
                return CircleAvatar(
                  radius: 42,
                  child: AppImage(
                    path: profileImage,
                    height: context.h(0.2),
                    width: context.screenWidth,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),

          // 🔹 Name / info below avatar
          Positioned(
            top: 210, // adjust spacing below avatar
            child: Consumer<AuthProvider>(
              builder: (context, auth, child) {
                final name = auth.fullName.isNotEmpty
                    ? auth.fullName
                    : Common.guest;
                final customerId = auth.user?.customerId ?? '-';
                return Column(
                  spacing: Dimens.spacingS,
                  children: [
                    AppText(
                      name,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mediumGrey,
                      ),
                    ),

                    // Customer ID
                    AppText(
                      "Customer ID: $customerId",
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AccountOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
