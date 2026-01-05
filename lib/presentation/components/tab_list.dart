import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class TabList extends StatelessWidget {
  const TabList({
    super.key,
    required this.list,
    required this.selectedId,
    this.onTap,
    this.tabWidth,
  });

  final List<CategoryModel> list;
  final String? selectedId;
  final void Function(String id)? onTap;
  final double? tabWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.screenMarginHorizontal,
          vertical: Dimens.screenMarginVertical,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(width: Dimens.spacingS),
        itemBuilder: (context, index) {
          final item = list[index];
          final isSelected = item.id == selectedId;

          return GestureDetector(
            onTap: () => onTap?.call(item.id),
            child: Container(
              constraints: BoxConstraints(
                minWidth: context.w(tabWidth ?? 0.28),
              ),
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingS),
              decoration: BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.text,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Center(
                child: AppText(
                  item.title,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: isSelected ? 14 : 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
