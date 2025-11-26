import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/message_box.dart';
import 'package:sanam_laundry/data/models/list_view.dart';

class AppListView<T> extends StatelessWidget {
  final AppListState<T> state;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final VoidCallback? onRetry;
  final VoidCallback? onLoadMore;
  final Future<void> Function()? onRefresh;
  final Widget? emptyWidget;
  final EdgeInsets padding;
  final ScrollPhysics? scrollPhysics;
  final Axis scrollDirection;
  final bool? shrinkWrap;
  final Widget? separatorBuilderWidget;
  final String? emptyMessageDesciption;
  final String? emptyMessageTitle;

  const AppListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    this.onRetry,
    this.onLoadMore,
    this.onRefresh,
    this.emptyWidget,
    this.padding = EdgeInsets.zero,
    this.scrollPhysics,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap,
    this.separatorBuilderWidget,
    this.emptyMessageDesciption,
    this.emptyMessageTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (state.loadingInitial) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (state.error != null && state.items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Dimens.spacingM,
        children: [
          AppText(
            state.error ?? Common.somethingWentWrong,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.red),
          ),
          AppButton(
            title: 'Retry',
            onPressed: onRetry,
            type: AppButtonType.text,
          ),
        ],
      );
    }
    if (state.items.isEmpty) {
      return emptyWidget ??
          MessageBox(
            icon: Icons.info_outline,
            title: emptyMessageTitle ?? 'No Data Found',
            value:
                emptyMessageDesciption ??
                "There is no data available to display at the moment.",
          );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: NotificationListener<ScrollNotification>(
        onNotification: (notif) {
          if (notif.metrics.pixels >= notif.metrics.maxScrollExtent - 120 &&
              state.hasMore &&
              !state.loadingMore) {
            onLoadMore?.call();
          }
          return false;
        },
        child: ListView.separated(
          separatorBuilder: (_, __) =>
              separatorBuilderWidget ?? const SizedBox(),
          padding: padding,
          physics: scrollPhysics,
          shrinkWrap: shrinkWrap ?? true,
          scrollDirection: scrollDirection,

          itemCount: state.items.length + (state.loadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            final item = state.items[index];
            return itemBuilder(context, item, index);
          },
        ),
      ),
    );
  }
}
