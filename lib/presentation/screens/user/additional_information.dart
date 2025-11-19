import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AdditionalInformation extends StatefulWidget {
  const AdditionalInformation({super.key});

  @override
  State<AdditionalInformation> createState() => _AdditionalInformationState();
}

class _AdditionalInformationState extends State<AdditionalInformation> {
  final TextEditingController additionalNotesController =
      TextEditingController();
  final Map<String, List<String>> additionalList = {
    "Ironing": ["Standard", "Premium", "Express"],
    "Packaging": ["Basic", "Gift", "Eco-friendly"],
    "Instructions": [
      "Handle with care",
      "Use hypoallergenic detergent",
      "Extra starch on shirts",
    ],
  };

  final Map<String, String?> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      showBackButton: true,
      heading: "Additional Information",
      scrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Dimens.spacingMLarge,
        children: [
          // Categories
          ...additionalList.entries.map((entry) {
            String category = entry.key;
            List<String> options = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.spacingM,
              children: [
                AppText(
                  category,
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 50, // Fixed height for horizontal scroll
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: options.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: Dimens.spacingMSmall),
                    itemBuilder: (context, index) {
                      // String option = options[index];
                      // bool isSelected =
                      //     selectedOptions[category]?.contains(option) ?? false;
                      String option = options[index];

                      bool isSelected = selectedOptions[category] == option;

                      return AppButton(
                        title: option,
                        type: isSelected
                            ? AppButtonType.elevated
                            : AppButtonType.outlined,
                        textStyle: context.textTheme.bodyMedium!.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                        style: ButtonStyle(
                          side: isSelected
                              ? null
                              : WidgetStatePropertyAll(
                                  BorderSide(color: AppColors.border),
                                ),
                        ),
                        width: context.w(0.3),
                        onPressed: () {
                          setState(() {
                            // If clicked again → unselect
                            if (selectedOptions[category] == option) {
                              selectedOptions[category] = null;
                            } else {
                              selectedOptions[category] =
                                  option; // Select only this one
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),

          AppInput(
            controller: additionalNotesController,
            title: "Additional Notes (Optional)",
            maxLines: 10,
            hint: TemporaryText.lorumIpsum,
          ),

          AppButton(
            title: "Continue",
            onPressed: () {
              context.navigate(AppRoutes.confirmation);
            },
          ),
        ],
      ),
    );
  }
}
