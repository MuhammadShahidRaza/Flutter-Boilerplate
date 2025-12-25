import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/notification.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/index.dart';

Map<String, List<NotificationModel>> groupByDate(
  List<NotificationModel> notifications,
) {
  final Map<String, List<NotificationModel>> grouped = {};

  for (var n in notifications) {
    final dateKey = formatDate(
      (n.createdAt ?? DateTime.now()).toLocal(),
    ); // e.g. "Today", "Yesterday", "22 Jan 2025"

    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    grouped[dateKey]!.add(n);
  }

  return grouped;
}

String formatDate(DateTime date) {
  final localDate = date.toLocal();
  final now = DateTime.now();

  if (localDate.day == now.day &&
      localDate.month == now.month &&
      localDate.year == now.year) {
    return "Today";
  }

  final yesterday = now.subtract(Duration(days: 1));

  if (localDate.day == yesterday.day &&
      localDate.month == yesterday.month &&
      localDate.year == yesterday.year) {
    return "Yesterday";
  }

  // Default — format normal date
  return "${localDate.day} ${_monthName(localDate.month)} ${localDate.year}";
}

String _monthName(int month) {
  const months = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return months[month];
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final HomeRepository _homeRepository = HomeRepository();
  final List<NotificationModel> notifications = [];

  Future<void> fetchNotifications() async {
    final response = await _homeRepository.getNotifications();
    if (response != null) {
      setState(() {
        notifications.clear();
        notifications.addAll(response);
      });
      context.read<UserProvider>().updateNotificationCount(clear: true);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByDate(notifications);
    final dateKeys = grouped.keys.toList();

    return AppWrapper(
      heading: Common.notifications,
      showBackButton: true,
      child: dateKeys.isEmpty
          ? Center(
              child: AppText(
                Common.noNotificationsAvailable,
                style: context.textTheme.bodyMedium,
              ),
            )
          : ListView.builder(
              itemCount: dateKeys.length,
              itemBuilder: (context, index) {
                final date = dateKeys[index];
                final items = grouped[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Notifications for that date
                    ...items.map((n) => _NotificationTile(notification: n)),

                    SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final dateTime = (notification.createdAt ?? DateTime.now()).toLocal();
    final formattedTime = DateFormat('hh:mm a').format(dateTime);
    // agar date bhi chahiye:
    // final formattedTime = DateFormat('dd MMM, hh:mm a').format(time);

    final isOfBooking =
        notification.type == 'rider-assigned-for-delivery' ||
        notification.type == 'booking-status-updated';

    return Card(
      elevation: 0,

      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => {
          if (notification.type != null && notification.objectableId != null)
            if (isOfBooking)
              {
                {
                  context.navigate(
                    AppRoutes.bookingDetails,
                    extra: notification.objectableId?.toString(),
                  ),
                },
              },
        },
        leading: AppImage(
          path: notification.user?.profileImage ?? AppAssets.logo,
          width: 50,
          height: 50,
          isCircular: true,
          borderRadius: 50,
        ),
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              notification.title ?? "",
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppText(formattedTime, style: TextStyle(color: Colors.grey)),
          ],
        ),
        subtitle: AppText(notification.body ?? "", maxLines: 5),
      ),
    );
  }
}
