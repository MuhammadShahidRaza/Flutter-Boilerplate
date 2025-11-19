import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/loader_service.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppLoaderOverlay extends StatelessWidget {
  const AppLoaderOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: LoaderService.instance.globalCounter,
      child: child,
      builder: (context, activeCount, baseChild) {
        final content = baseChild ?? const SizedBox();
        if (activeCount <= 0) return content;

        return Stack(children: [content, const _FullScreenLoader()]);
      },
    );
  }
}

class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AbsorbPointer(
      absorbing: true,
      child: ColoredBox(
        color: AppColors.lightBlackOpacity,
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 3,
                backgroundColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
