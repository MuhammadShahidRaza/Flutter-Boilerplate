import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    final List<_AccountOption> options = [
      _AccountOption(
        icon: Icons.edit_outlined,
        title: Common.editProfile,
        onTap: () {
          context.navigate(AppRoutes.editProfile);
        },
      ),
      _AccountOption(
        icon: Icons.list,
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
        icon: Icons.credit_card,
        title: Common.payment,
        onTap: () {
          // context.navigate(AppRoutes.payment);
        },
      ),
      _AccountOption(
        icon: Icons.translate,
        title: Common.language,
        onTap: () {
          context.navigate(AppRoutes.language);
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
          context.navigate(
            AppRoutes.staticPage,
            params: {'name': Common.termsAndConditions},
          );
        },
      ),
      _AccountOption(
        icon: Icons.privacy_tip_outlined,
        title: Common.privacyPolicy,
        onTap: () {
          context.navigate(
            AppRoutes.staticPage,
            params: {'name': Common.privacyPolicy},
          );
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
            borderWidth: 5,
            dismissible: false,
            borderRadius: Dimens.radiusL,
            content: AppText(
              Common.doYouWantToDeleteAccount,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            showTwoPrimaryButtons: true,
            primaryButtonText: Common.yes,
            secondaryButtonText: Common.no,
            onPrimaryPressed: () async {
              setState(() {
                isLoading = true;
              });
              context.back();
              final currentContext = context;
              final isDeleted = await _authRepository.deleteAccount();
              if (isDeleted != null) {
                if (!currentContext.mounted) return;
                setState(() {
                  isLoading = false;
                });
                AuthProvider().logout();
                AppDialog.show(
                  context,
                  borderColor: AppColors.primary,
                  borderWidth: 5,
                  dismissible: false,
                  borderRadius: Dimens.radiusL,
                  content: AppText(
                    Common.yourAccountHasBeenDeleted,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  primaryButtonText: Common.signUpAgain,
                  onPrimaryPressed: () async {
                    context.replacePage(AppRoutes.getStarted);
                  },
                  crossAxisAlignment: CrossAxisAlignment.center,
                  insetPadding: EdgeInsets.all(Dimens.spacingMLarge),
                );
              }
            },
            onSecondaryPressed: () => {context.back()},
            backgroundColor: AppColors.lightWhite,
            crossAxisAlignment: CrossAxisAlignment.center,
            insetPadding: EdgeInsets.all(Dimens.spacingMLarge),
          );
        },
      ),
    ];

    return AppWrapper(
      scrollable: true,
      safeArea: false,
      scrollPhysics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            bottom: context.w(0.8),
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.07,
                child: Transform.rotate(
                  angle:
                      -1.5, // in radians → about -30° rotation (adjust as needed)
                  alignment: Alignment.centerRight, // rotate around right side
                  child: Align(
                    alignment:
                        Alignment.centerRight, // ensure it starts from right
                    child: AppImage(
                      path: AppAssets.watermark,
                      width: context.screenWidth,
                      height: context.h(0.60),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Column(
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
                          leading: AppIcon(
                            icon: e.icon,
                            color: AppColors.primary,
                          ),
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
                  isLoading: isLoading,
                  title: Common.logout,
                  onPressed: () {
                    AppDialog.show(
                      context,
                      title: Common.logout,
                      borderColor: AppColors.primary,
                      borderWidth: 5,
                      dismissible: false,
                      borderRadius: Dimens.radiusL,
                      content: AppText(
                        Common.areYouSureYouWantToLogout,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      primaryButtonText: Common.yes,
                      secondaryButtonText: Common.no,
                      showTwoPrimaryButtons: true,
                      onSecondaryPressed: () => {context.back()},
                      onPrimaryPressed: () async {
                        context.replacePage(AppRoutes.getStarted);
                        _authRepository.logout();
                      },
                      crossAxisAlignment: CrossAxisAlignment.center,
                      insetPadding: EdgeInsets.all(Dimens.spacingMLarge),
                    );
                  },
                ),
              ),
            ],
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
                return AppImage(
                  path: profileImage,
                  height: 90,
                  width: 90,
                  isCircular: true,
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
