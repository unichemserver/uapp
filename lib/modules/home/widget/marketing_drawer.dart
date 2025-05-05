import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';

class MarketingDrawer extends StatelessWidget {
  const MarketingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 16),
          child: Text(
            'Menu Devisi (Marketing)',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ExpansionTile(
          initiallyExpanded: false,
          title: const Text('Data Outlet'),
          leading: const Icon(Icons.checklist),
          children: [
            Container(
                margin: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: const Text('New Opening Outlet'),
                  leading: const Icon(Icons.add_location_alt_outlined),
                  onTap: () async {
                    Get.toNamed(Routes.NOO);
                  },
                ),    
            ),
            Container(
                margin: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: const Text('Outlet Pengajuan'),
                  leading: const Icon(Icons.add_comment_outlined),
                  onTap: () async {
                    Get.toNamed(Routes.UPDATE_NOO);
                  },
                ),    
            ),
          ]
        ),
        ExpansionTile(
          initiallyExpanded: false,
          title: const Text('Kunjungan'),
          leading: const Icon(Icons.location_on),
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text('On Route'),
                leading: const Icon(Icons.location_on),
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      title: const Text('Call. Management'),
                      leading: const Icon(Icons.group_outlined),
                      onTap: () {
                        Get.toNamed(Routes.CALL_MANAGEMENT);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      title: const Text('Canvasing'),
                      leading: const Icon(Icons.manage_search),
                      onTap: () {
                        Get.toNamed(Routes.CANVASING_ONROUTE);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: ExpansionTile(
                initiallyExpanded: false,
                title: const Text('Off Route'),
                leading: const Icon(Icons.location_off),
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      title: const Text('Customer Active'),
                      leading: const Icon(Icons.group_add_outlined),
                      onTap: () {
                        Get.toNamed(Routes.CUSTACTIVE);
                      },
                    ),
                  ),                  
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      title: const Text('Canvasing'),
                      leading: const Icon(Icons.manage_search),
                      onTap: () {
                        Get.toNamed(Routes.CANVASING_OFFROUTE);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        ListTile(
          title: const Text('Sinkronisasi Data'),
          leading: const Icon(Icons.sync),
          onTap: () async {
            Get.toNamed(Routes.SYNC_MARKETING);
          },
        ),
      ],
    );
  }
}
