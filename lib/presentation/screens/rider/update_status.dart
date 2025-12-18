import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/user.dart';

class UpdateStatus extends StatefulWidget {
  const UpdateStatus({super.key});

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  final RiderRepository _riderRepository = RiderRepository();
  late bool isActive;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProvider>();
    isActive = provider.user?.isRiderActive ?? false;
  }

  Future<void> _submit() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    setState(() => isLoading = true);
    final user = await _riderRepository.updateStatus(isActive: isActive);
    if (user != null) {
      await provider.updateUser(user);
      if (!mounted) return;
      context.back();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      heading: Common.updateStatus,
      showBackButton: true,
      child: Stack(
        children: [
          // 🔹 Background watermark
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.07,
                child: AppImage(
                  path: AppAssets.watermark,
                  width: context.screenWidth,
                  height: context.h(0.45),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🔹 Content
          Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: Dimens.spacingLarge,
                  children: [
                    AppText(
                      Common.updateStatusDescription,
                      style: context.textTheme.bodyMedium,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          Common.activeStatus,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                          thumbColor: WidgetStatePropertyAll(
                            AppColors.secondary,
                          ),
                          activeThumbColor: AppColors.tertiary,
                          trackOutlineColor: WidgetStatePropertyAll(
                            AppColors.primary,
                          ),
                          trackOutlineWidth: WidgetStatePropertyAll(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 🔹 Save button
              AppButton(
                title: Common.save,
                isLoading: isLoading,
                onPressed: () {
                  _submit();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
