import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppAutocomplete extends StatefulWidget {
  final String? label;
  final bool isRequired;
  final String? title;
  final TextEditingController textEditingController;
  final void Function(Prediction)? getPlaceDetailWithLatLng;
  final void Function(Prediction)? itemClick;
  final String? counterText;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppAutocomplete({
    super.key,
    this.label,
    this.isRequired = false,
    required this.textEditingController,
    this.getPlaceDetailWithLatLng,
    this.itemClick,
    this.title,
    this.counterText,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<AppAutocomplete> createState() => _AppAutocompleteState();
}

class _AppAutocompleteState extends State<AppAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacingS,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Row(
            children: [
              AppText(widget.title!, style: context.textTheme.titleSmall),
              if (widget.isRequired) const AppText(' *', color: AppColors.red),
            ],
          ),
        ],
        GooglePlaceAutoCompleteTextField(
          textEditingController: widget.textEditingController,
          // googleAPIKey: Environment.mapKey,
          googleAPIKey: '""',
          inputDecoration: InputDecoration(
            errorMaxLines: 3,
            counterText: widget.counterText,
            labelText: widget.label != null ? context.tr(widget.label!) : null,
            hintText: widget.hint != null ? context.tr(widget.hint!) : null,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          itemBuilder: (context, index, Prediction prediction) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AppText(prediction.description ?? "", maxLines: 3),
              ),
            );
          },
          countries: const ["SA"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: widget.getPlaceDetailWithLatLng,
          itemClick: widget.itemClick,
        ),
      ],
    );
  }
}
