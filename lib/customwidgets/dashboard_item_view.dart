import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/models/dashboard_model.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardModel model;
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
    );
  }
}
