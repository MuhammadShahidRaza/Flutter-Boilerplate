import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/network/api_client.dart';

class AppLoaderOverlay extends StatelessWidget {
  const AppLoaderOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder<bool>(
          valueListenable: ApiClient.loaderNotifier,
          builder: (context, isLoading, _) {
            if (!isLoading) return const SizedBox.shrink();
            return const _FullScreenLoader();
          },
        ),
      ],
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
        color: Colors.black.withOpacity(0.35),
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
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ),
      ),
    );
  }
}
