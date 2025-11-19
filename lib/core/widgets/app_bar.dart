import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String? heading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double height;

  const AppBarComponent({
    super.key,
    this.heading,
    this.onBackPressed,
    this.backgroundColor,
    this.showBackButton = true,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      leading: showBackButton
          ? Center(
              child: SizedBox(
                width: 35,
                height: 35,
                child: AppIcon(
                  icon: Icons.arrow_back_ios_new,
                  borderColor: AppColors.primary,
                  borderWidth: 1,
                  size: Dimens.iconS,
                  backgroundColor: AppColors.lightWhite,
                  onTap:
                      onBackPressed ??
                      () => {
                        if (context.canPop())
                          context.back()
                        else
                          context.replace(AppRoutes.home),
                      },
                ),
              ),
            )
          : null,
      title: heading != null
          ? AppText(heading!, style: theme.textTheme.titleLarge)
          : null,
      centerTitle: true,
    );
  }
}
