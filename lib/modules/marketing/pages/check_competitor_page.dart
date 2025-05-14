import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/competitor_model.dart';
import 'package:uapp/modules/marketing/widget/competitor_report_dialog.dart';

class CheckCompetitorPage extends StatelessWidget {
  const CheckCompetitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      builder: (ctx) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(context, ctx.competitors, ctx),
          floatingActionButton: _buildFloatingActionButton(ctx),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cek Kompetitor',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  Widget _buildFloatingActionButton(MarketingController ctx) {
    return FloatingActionButton(
      onPressed: () async {
        CompetitorModel? competitor = await Get.dialog(
          CompetitorReportDialog(
            idMarketingActivity: ctx.idMarketingActivity!,
          ),
        );
        if (competitor != null) {
          ctx.addCompetitorToDatabase(competitor);
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<CompetitorModel> competitors,
    MarketingController ctx,
  ) {
    return competitors.isEmpty
        ? _buildEmptyState(context)
        : _buildCompetitorList(competitors, ctx);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory,
            size: 100.0,
          ),
          Text(
            'Belum ada data kompetitor',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorList(
    List<CompetitorModel> competitors,
    MarketingController ctx,
  ) {
    return ListView.builder(
      itemCount: competitors.length,
      itemBuilder: (context, index) {
        final competitor = competitors[index];
        return _buildCompetitorTile(competitor, ctx, context);
      },
    );
  }

  Widget _buildCompetitorTile(
    CompetitorModel competitor,
    MarketingController ctx,
    BuildContext context,
  ) {
    return Dismissible(
      key: Key(competitor.name!),
      background: _buildDeleteBackground(),
      confirmDismiss: (direction) async {
        bool isDelete = await _showDeleteConfirmation(context, competitor.name);
        if (isDelete) {
          ctx.deleteCompetitorFromDatabase(competitor);
          return true;
        }
        return false;
      },
      child: ListTile(
        title: Text(competitor.name!),
        subtitle: Text('Harga: ${competitor.price}'),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String? competitorName,
  ) async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah anda yakin ingin menghapus data kompetitor $competitorName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
