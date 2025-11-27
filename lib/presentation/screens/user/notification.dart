import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/presentation/index.dart';

class AppNotification {
  final String title;
  final String message;
  final DateTime createdAt;

  AppNotification({
    required this.title,
    required this.message,
    required this.createdAt,
  });
}

Map<String, List<AppNotification>> groupByDate(
  List<AppNotification> notifications,
) {
  final Map<String, List<AppNotification>> grouped = {};

  for (var n in notifications) {
    final dateKey = formatDate(
      n.createdAt,
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
  @override
  @override
  Widget build(BuildContext context) {
    // final List<AppNotification> notifications = [
    //   AppNotification(
    //     title: "Order Confirmed",
    //     message: "Your laundry order #1245 has been confirmed.",
    //     createdAt: DateTime.now().subtract(Duration(minutes: 10)),
    //   ),
    //   AppNotification(
    //     title: "Rider Assigned",
    //     message: "A rider has been assigned for pickup.",
    //     createdAt: DateTime.now().subtract(Duration(hours: 1)),
    //   ),
    //   AppNotification(
    //     title: "Order Ready",
    //     message: "Your clothes are washed and ready for delivery.",
    //     createdAt: DateTime.now().subtract(Duration(days: 1, hours: 2)),
    //   ),
    //   AppNotification(
    //     title: "Payment Successful",
    //     message: "Your payment of 45 SAR was successful.",
    //     createdAt: DateTime.now().subtract(Duration(days: 1, hours: 5)),
    //   ),
    //   AppNotification(
    //     title: "Welcome!",
    //     message: "Thank you for joining Sanam Laundry.",
    //     createdAt: DateTime.now().subtract(Duration(days: 3)),
    //   ),
    //   AppNotification(
    //     title: "Promotion",
    //     message: "Get 20% off on your next wash!",
    //     createdAt: DateTime.now().subtract(Duration(days: 3, hours: 4)),
    //   ),
    // ];
    final List<AppNotification> notifications = [];
    final grouped = groupByDate(notifications);
    final dateKeys = grouped.keys.toList();

    return AppWrapper(
      heading: Common.notifications,
      showBackButton: true,
      child: dateKeys.length == 0
          ? Center(
              child: AppText(
                "No notifications available",
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
  final AppNotification notification;

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

        title: AppText(notification.title),
        subtitle: AppText(notification.message),
        trailing: AppText(
          "${notification.createdAt.hour}:${notification.createdAt.minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
