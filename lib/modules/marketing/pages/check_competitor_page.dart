import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/models/competitor.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/widget/competitor_report_dialog.dart';

class CheckCompetitorPage extends StatelessWidget {
  const CheckCompetitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cek Kompetitor',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
          ),
          body: _buildBody(context, ctx.competitors),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Competitor? competitor = await Get.dialog(
                CompetitorReportDialog(
                  idMarketingActivity: ctx.idMarketingActivity!,
                ),
              );
              if (competitor != null) {
                Get.find<MarketingController>().addCompetitorToDatabase(competitor);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  _buildBody(BuildContext context, List<Competitor> competitors) {
    if (competitors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory,
              size: 100.0,
            ),
            Text(
              'Belum ada data kompetitor yang anda masukkan',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik',
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: competitors.length,
      itemBuilder: (context, index) {
        final competitor = competitors[index];
        return ListTile(
          title: Text(competitor.name),
          subtitle: Text(competitor.price.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.find<MarketingController>().removeCompetitorFromDatabase(competitor);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
