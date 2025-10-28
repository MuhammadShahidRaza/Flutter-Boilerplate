import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/providers/auth.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(AppAssets.splashVideo)
      ..initialize().then((_) {
        setState(() {}); // Refresh when video is ready
        _controller.play();
        _initFlow();
      });
  }

  Future<void> _initFlow() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.loadLoginStatus();

    final hasLanguage = await authProvider.hasSelectedLanguage();
    final route = authProvider.isLoggedIn
        ? AppRoutes.home
        : !hasLanguage
        ? AppRoutes.language
        : !authProvider.hasVisitedApp
        ? AppRoutes.onboarding
        : AppRoutes.getStarted;

    if (!mounted) return;
    context.replacePage(
      route,
      params: !hasLanguage ? {'isFromSplash': true} : {},
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
