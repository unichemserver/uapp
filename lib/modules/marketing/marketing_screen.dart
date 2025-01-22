import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/pages/check_competitor_page.dart';
import 'package:uapp/modules/marketing/pages/check_display_page.dart';
import 'package:uapp/modules/marketing/pages/check_stock_page.dart';
import 'package:uapp/modules/marketing/pages/checkin_page.dart';
import 'package:uapp/modules/marketing/pages/checkout_page.dart';
import 'package:uapp/modules/marketing/pages/collection_page.dart';
import 'package:uapp/modules/marketing/pages/taking_order_page.dart';

import 'package:uapp/modules/marketing/marketing_controller.dart';

class MarketingScreen extends StatelessWidget {
  MarketingScreen({super.key});

  final List<Widget> pages = [
    const CheckInPage(),
    const CheckStockPage(),
    const CheckCompetitorPage(),
    const CheckDisplayPage(),
    TakingOrderPage(),
    CollectionPage(),
    const CheckoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: ctx.currentIndex == 0,
          onPopInvoked: (didPop) {
            if (!didPop) {
              if (ctx.currentIndex != 0) {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text(
                      'Apakah Anda yakin ingin keluar dari halaman ini?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Tidak'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const Text('Ya'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
          child: Scaffold(
            // appBar: (ctx.currentIndex == 0)
            //     ? null
            //     : AppBar(
            //         title: Text('${ctx.customerName}'),
            //         centerTitle: true,
            //         leading: const SizedBox(),
            //       ),
            body: Column(
              children: [
                ctx.currentIndex == 0
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                ctx.customerName!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child: pages[ctx.currentIndex],
                ),
                (ctx.currentIndex == 0)
                    ? const SizedBox()
                    : SizedBox(
                        height: 60,
                        child: BottomNavigationBar(
                          currentIndex: ctx.currentIndex,
                          onTap: (value) {
                            if ((ctx.jenisCall == Call.noo) && (value == 5)) {
                              return;
                            }
                            if (value != 0) {
                              ctx.currentIndex = value;
                              ctx.update();
                            }
                          },
                          selectedItemColor: Colors.blue,
                          unselectedLabelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          unselectedItemColor: Colors.grey,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.login),
                              label: 'Check-In',
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
                              icon: Icon(Icons.collections),
                              label: 'Display',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.swap_horiz),
                              label: 'TO',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.attach_money),
                              label: 'Collection',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.logout),
                              label: 'Checkout',
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
