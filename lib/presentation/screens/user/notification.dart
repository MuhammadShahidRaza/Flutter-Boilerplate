import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/models/notification.dart';
import 'package:sanam_laundry/data/repositories/home.dart';
import 'package:sanam_laundry/presentation/index.dart';

Map<String, List<NotificationModel>> groupByDate(
  List<NotificationModel> notifications,
) {
  final Map<String, List<NotificationModel>> grouped = {};

  for (var n in notifications) {
    final dateKey = formatDate(
      n.createdAt ?? DateTime.now(),
    ); // e.g. "Today", "Yesterday", "22 Jan 2025"

    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    grouped[dateKey]!.add(n);
  }

  return grouped;
}

String formatDate(DateTime date) {
  final now = DateTime.now();

  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "Today";
  }

  final yesterday = now.subtract(Duration(days: 1));

  if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return "Yesterday";
  }

  // Default — format normal date
  return "${date.day} ${_monthName(date.month)} ${date.year}";
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
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: AppImage(
          path: AppAssets.user,
          width: 50,
          height: 50,
          borderRadius: 50,
        ),
        contentPadding: EdgeInsets.zero,
        title: AppText(notification.title ?? ""),
        subtitle: AppText(notification.body ?? ""),
        trailing: AppText(
          "${notification.createdAt?.hour}:${notification.createdAt?.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
