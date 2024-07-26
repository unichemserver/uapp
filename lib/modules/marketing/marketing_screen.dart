import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/pages/check_competitor_page.dart';
import 'package:uapp/modules/marketing/pages/check_display_page.dart';
import 'package:uapp/modules/marketing/pages/check_stock_page.dart';
import 'package:uapp/modules/marketing/pages/checkin_page.dart';
import 'package:uapp/modules/marketing/pages/collection_page.dart';
import 'package:uapp/modules/marketing/pages/select_rute_page.dart';
import 'package:uapp/modules/marketing/pages/taking_order_page.dart';

import 'package:uapp/modules/marketing/marketing_controller.dart';

class MarketingScreen extends StatelessWidget {
  MarketingScreen({super.key});

  List<Widget> pages = [
    SelectRutePage(),
    CheckInPage(),
    CheckStockPage(),
    CheckCompetitorPage(),
    CheckDisplayPage(),
    TakingOrderPage(),
    CollectionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: (ctx.currentIndex == 0 || ctx.currentIndex == 1)
              ? null
              : AppBar(
                  title: Text('Kunjungan ${ctx.customerId}'),
                  centerTitle: true,
                  leading: const SizedBox(),
                ),
          body: Column(
            children: [
              Expanded(
                child: pages[ctx.currentIndex],
              ),
              (ctx.currentIndex == 0 || ctx.currentIndex == 1)
                  ? const SizedBox()
                  : SizedBox(
                      height: 60,
                      child: BottomNavigationBar(
                        currentIndex: ctx.currentIndex,
                        onTap: (value) {
                          if (ctx.jenisCall == Call.noo && value == 4) {
                            Get.snackbar('Info', 'Menu ini tidak tersedia ketika anda memilih untuk melaporkan NOO');
                            return;
                          }

                          if (value != 0 && value != 1) {
                            ctx.currentIndex = value;
                            ctx.update();
                          }

                          if (value == 3) {
                            ctx.getCompetitors();
                          } else if (value == 4) {
                            ctx.getDisplay();
                          } else if (value == 5) {
                            ctx.getTakingOrders();
                          } else if (value == 6) {
                            ctx.getCollections();
                          }
                        },
                        selectedItemColor: Colors.blue,
                        unselectedLabelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        unselectedItemColor: Colors.grey,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.map),
                            label: 'Rute',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.login),
                            label: 'Check In',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.inventory),
                            label: 'Stock',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.people),
                            label: 'Competitor',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.display_settings),
                            label: 'Display',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.swap_horiz),
                            label: 'TO',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.collections),
                            label: 'Collection',
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
