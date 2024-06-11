import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/pages/canvasing/canvasing_controller.dart';
import 'package:uapp/modules/marketing/pages/canvasing/widget/addcustomer.dart';
import 'package:uapp/modules/marketing/pages/canvasing/widget/order.dart';
import 'package:uapp/modules/marketing/pages/canvasing/widget/payment.dart';

class CanvasingPage extends StatelessWidget {
  CanvasingPage({super.key});

  final List<Widget> canvasingWidgets = [
    AddCustomerWidget(),
    OrderWidget(),
    PaymentWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      init: CanvasingController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            if (didPop) {
              Get.offAllNamed(Routes.HOME);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Canvasing'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                },
              ),
              actions: [
                IconButton(
                  onPressed: ctx.canvasingIndex != 2 ? null : () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Checkout'),
                        content: const Text('Apakah anda yakin ingin checkout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              ctx.checkOut();
                              Get.back();
                              Get.offAllNamed(Routes.HOME);
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
            body: canvasingWidgets[ctx.canvasingIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: ctx.canvasingIndex,
              onTap: (index) {
                ctx.setCanvasingIndex(index);
                if (index == 1) {
                  ctx.getListItem();
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Add Customer',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Order',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  label: 'Payment',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
