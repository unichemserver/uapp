import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';

class MarketingDrawer extends StatelessWidget {
  const MarketingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildMenuSection('Menu Divisi (Marketing)', context),
        const SizedBox(height: 8),
        _buildMarketingExpandableTile(
          context,
          title: 'Data Outlet',
          icon: Icons.store_outlined,
          children: [
            _buildNestedMenuItem(
              context,
              title: 'New Opening Outlet',
              icon: Icons.add_location_alt_outlined,
              onTap: () {
                Get.toNamed(Routes.NOO);
              },
            ),
            _buildNestedMenuItem(
              context,
              title: 'Outlet Pengajuan',
              icon: Icons.add_comment_outlined,
              onTap: () {
                Get.toNamed(Routes.UPDATE_NOO);
              },
            ),
          ],
        ),
        _buildMarketingExpandableTile(
          context,
          title: 'Kunjungan',
          icon: Icons.location_on_outlined,
          children: [
            _buildNestedExpandableTile(
              context,
              title: 'On Route',
              icon: Icons.navigation_outlined,
              initiallyExpanded: true,
              children: [
                _buildNestedMenuItem(
                  context,
                  title: 'Call. Management',
                  icon: Icons.groups_outlined,
                  onTap: () {
                    Get.toNamed(Routes.CALL_MANAGEMENT);
                  },
                ),
                _buildNestedMenuItem(
                  context,
                  title: 'Canvasing',
                  icon: Icons.manage_search_outlined,
                  onTap: () {
                    Get.toNamed(Routes.CANVASING_ONROUTE);
                  },
                ),
              ],
            ),
            _buildNestedExpandableTile(
              context,
              title: 'Off Route',
              icon: Icons.location_off_outlined,
              children: [
                _buildNestedMenuItem(
                  context,
                  title: 'Customer Active',
                  icon: Icons.group_add_outlined,
                  onTap: () {
                    Get.toNamed(Routes.CUSTACTIVE);
                  },
                ),
                _buildNestedMenuItem(
                  context,
                  title: 'Canvasing',
                  icon: Icons.manage_search_outlined,
                  onTap: () {
                    Get.toNamed(Routes.CANVASING_OFFROUTE);
                  },
                ),
              ],
            ),
          ],
        ),
        _buildMenuTile(
          context,
          title: 'Sinkronisasi Data',
          icon: Icons.sync_outlined,
          onTap: () {
            Get.toNamed(Routes.SYNC_MARKETING);
          },
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final color = isActive 
        ? Theme.of(context).primaryColor 
        : Colors.grey.shade700;
        
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive 
            ? Theme.of(context).primaryColor.withOpacity(0.1) 
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(
          icon,
          color: color,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMarketingExpandableTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: Colors.grey.shade700,
            size: 22,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: Theme.of(context).primaryColor,
          collapsedIconColor: Colors.grey.shade700,
          childrenPadding: const EdgeInsets.only(left: 12),
          children: children,
        ),
      ),
    );
  }

  Widget _buildNestedExpandableTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 8, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: Colors.grey.shade700,
            size: 20,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: Theme.of(context).primaryColor,
          collapsedIconColor: Colors.grey.shade700,
          childrenPadding: const EdgeInsets.only(left: 8),
          children: children,
        ),
      ),
    );
  }

  Widget _buildNestedMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 8,
        leading: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }
}