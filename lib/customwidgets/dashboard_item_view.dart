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
    return InkWell(
      onTap: () => onTap(model.routeName),
      child: Card(
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(model.iconData, size: 40),
              const SizedBox(height: 8),
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
