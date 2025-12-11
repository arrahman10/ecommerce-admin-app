import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/models/dashboard_model.dart';

/// A reusable grid item widget for the admin dashboard.
///
/// Displays an icon and title, and triggers [onTap] with the
/// corresponding [DashboardModel.routeName] when tapped. If the
/// route name is empty, it shows a placeholder SnackBar instead.
class DashboardItemView extends StatelessWidget {
  /// Model describing the dashboard tile (icon, title, route name).
  final DashboardModel model;

  /// Callback that is invoked when the tile is tapped with [model.routeName].
  final ValueChanged<String> onTap;

  const DashboardItemView({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (model.routeName.isNotEmpty) {
          onTap(model.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This section will be added later.')),
          );
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(model.iconData, size: 50, color: theme.colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
