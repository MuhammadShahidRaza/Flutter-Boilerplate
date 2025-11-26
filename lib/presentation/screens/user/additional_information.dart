import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class AdditionalInformation extends StatefulWidget {
  const AdditionalInformation({super.key});

  @override
  State<AdditionalInformation> createState() => _AdditionalInformationState();
}

class _AdditionalInformationState extends State<AdditionalInformation> {
  final TextEditingController additionalNotesController =
      TextEditingController();
  // final Map<String, List<String>> additionalList = {
  //   "Ironing": ["Standard", "Premium", "Express"],
  //   "Packaging": ["Basic", "Gift", "Eco-friendly"],
  //   "Instructions": [
  //     "Handle with care",
  //     "Use hypoallergenic detergent",
  //     "Extra starch on shirts",
  //   ],
  // };

  final HomeRepository _homeRepository = HomeRepository();
  Map<String, dynamic> additionalList = {};

  void fetchAdditionalInfo() async {
    final data = await _homeRepository.additionalInfo();
    if (data != null) {
      setState(() {
        additionalList = data;
      });
    }
  }

  final Map<String, int?> selectedOptionIds = {};

  @override
  void initState() {
    super.initState();
    fetchAdditionalInfo();
  }

  final Map<String, String> keyMap = {
    "ghutra ironing": "ironing_id",
    "starch": "starch_id",
    "clothes": "clothes_returned_id",
  };

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
            String category = entry.key.replaceAll('-', ' ');
            final List options = entry.value as List;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.spacingM,
              children: [
                AppText(
                  Utils.capitalize(category),
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
                      final item = options[index]; // map
                      final String option = item["title"]; // string
                      final int optionId = item["id"]; // optional if needed

                      bool isSelected = selectedOptionIds[category] == optionId;

                      return AppButton(
                        title: Utils.capitalize(option),
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
                            if (selectedOptionIds[category] == optionId) {
                              selectedOptionIds[category] = null;
                            } else {
                              selectedOptionIds[category] = optionId;
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
              final cart = context.read<CartProvider>();
              cart.addOrderDetail(
                "special_instructions",
                additionalNotesController.text,
              );
              selectedOptionIds.forEach((category, id) {
                if (id != null) {
                  final saveKey = keyMap[category];
                  if (saveKey != null) {
                    cart.addOrderDetail(saveKey, id.toString());
                  }
                }
              });

              context.navigate(AppRoutes.confirmation);
            },
          ),
        ],
      ),
    );
  }
}
