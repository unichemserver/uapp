import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/company_profile_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/general_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/kil_signature_widget.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/outlet_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/outlet_status.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/owner_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/va_bank_account.dart';

class NooPage extends StatelessWidget {
  NooPage({super.key});

  final creditLimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NooController>(
      init: NooController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Kartu Identitas Langganan'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              GeneralInformation(),
              OwnerInformation(),
              OutletInformation(),
              OutletStatus(),
              VaBankAccount(),
              CompanyProfileInformation(),
              KilSignatureWidget(),
            ],
          ),
        );
      },
    );
  }
}
