import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_AccountOption> options = [
      _AccountOption(icon: Icons.edit, title: Common.editProfile, onTap: () {}),
      _AccountOption(
        icon: Icons.shopping_bag_outlined,
        title: Common.myOrders,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.location_on_outlined,
        title: Common.myAddress,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.payment_outlined,
        title: Common.payment,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.language_outlined,
        title: Common.language,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.contact_mail_outlined,
        title: Common.contactUs,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.article_outlined,
        title: Common.termsAndConditions,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.privacy_tip_outlined,
        title: Common.privacyPolicy,
        onTap: () {},
      ),
      _AccountOption(
        icon: Icons.delete_outline,
        title: Common.deleteAccount,
        onTap: () {
          AuthService.removeToken();
          context.replacePage(AppRoutes.login);
        },
      ),
    ];

    return AppWrapper(
      scrollable: true,
      padding: EdgeInsets.zero,
      child: Column(
        spacing: Dimens.spacingLarge,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.screenMarginHorizontal,
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

          AppButton(
            title: Common.logout,
            onPressed: () {
              AuthService.removeToken();
              context.replacePage(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Positioned(
          top: 90,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage(
                AppAssets.user,
              ), // or NetworkImage(profileImage)
            ),
          ),
        ),
        Positioned(
          top: 210,
          child: Column(
            children: const [
              Text(
                'Aldo Bareto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Customer ID: 15643FJU541',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
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
