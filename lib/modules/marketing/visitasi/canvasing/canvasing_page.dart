import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/widget/addcustomer.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/widget/order.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/widget/payment.dart';

class CanvasingPage extends StatelessWidget {
  CanvasingPage({super.key});

  final List<Widget> canvasingWidgets = [
    AddCustomerWidget(),
    OrderWidget(),
    PaymentWidget(),
  ];

  showWarningSnackBar(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  bool isFormFullyFilled(CanvasingController ctx) {
    bool nama = ctx.namaController.text.isNotEmpty;
    bool pemilik = ctx.pemilikController.text.isNotEmpty;
    bool telp = ctx.telpController.text.isNotEmpty;
    bool alamat = ctx.alamatController.text.isNotEmpty;
    bool image = ctx.outletImagePath.isNotEmpty;
    return nama && pemilik && telp && alamat && image;
  }

  validateForm(CanvasingController ctx) async {
    if (!isFormFullyFilled(ctx)) {
      ctx.setCanvasingIndex(0);
      showWarningSnackBar('Form Customer belum lengkap');
      return;
    }
    if (ctx.takingOrders.isEmpty || ctx.ttdPath.isEmpty) {
      ctx.setCanvasingIndex(1);
      showWarningSnackBar('Order belum lengkap atau TTD belum diisi');
      return;
    }
    if (!ctx.isToComplete) {
      ctx.setCanvasingIndex(2);
      showWarningSnackBar('Harap cetak struk pembayaran');
      return;
    }
    Get.dialog(
      AlertDialog(
        title: const Text('Checkout'),
        content:
        const Text('Apakah anda yakin ingin checkout?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.dialog(
                const LoadingDialog(message: 'Menyimpan data canvasing'),
                barrierDismissible: false,
              );
              Get.back();
              Get.back();
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  showCancelConfirmationDialog(CanvasingController ctx) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Canvasing'),
        content: const Text('Apakah anda yakin ingin membatalkan proses canvasing?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              ctx.cancelCanvasing();
              Get.back();
              Get.back();
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  String getCanvasingTitle(int index) {
    switch (index) {
      case 0:
        return 'Add Customer';
      case 1:
        return 'Taking Canvas';
      case 2:
        return 'Payment';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      init: CanvasingController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              if (ctx.isToComplete) {
                Get.back();
              } else {
                showCancelConfirmationDialog(ctx);
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                getCanvasingTitle(ctx.canvasingIndex),
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (ctx.isToComplete) {
                    Get.back();
                  } else {
                    showCancelConfirmationDialog(ctx);
                  }
                },
              ),
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       validateForm(ctx);
              //     },
              //     icon: const Icon(Icons.save),
              //   ),
              // ],
            ),
            body: canvasingWidgets[ctx.canvasingIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: ctx.canvasingIndex,
              onTap: (index) {
                ctx.setCanvasingIndex(index);
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
