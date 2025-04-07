import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/signature_widget.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/widget/to_dialog.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      init: CanvasingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          body: _buildBody(ctx.takingOrders, ctx),
        );
      },
    );
  }

  _buildBody(List<ToModel> takingOrders, CanvasingController ctx) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: takingOrders.length,
            itemBuilder: (context, index) {
              var item = takingOrders[index];
              return ListTile(
                onTap: ctx.isToComplete
                    ? () {}
                    : () {
                        _openOrderDialog(ctx, item);
                      },
                title: Text(item.description!),
                subtitle: Text(
                  '${item.quantity} * ${Utils.formatCurrency(item.unit!)}',
                ),
                leading: Text('${index + 1}'),
                trailing: Text(
                  Utils.formatCurrency(item.price.toString()),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ctx.isToComplete
                ? null
                : () {
                    _openOrderDialog(ctx, null);
                  },
            child: const Text('Tambah Produk'),
          ),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tanda Tangan Customer',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SignatureWidget(
              initTtdPath: ctx.ttdPath,
              isGestureEnabled: !ctx.isToComplete,
              onSaved: (value) {
                ctx.inserTtd(value.isNotEmpty ? value : null);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openOrderDialog(CanvasingController ctx, ToModel? toEdit) {
    Get.dialog(
      Dialog.fullscreen(
        child: ToDialog(toEdit: toEdit),
      ),
    );
  }
}