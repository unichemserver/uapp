import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_controller.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_model.dart';

class CustactivePage extends StatelessWidget {
  CustactivePage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GetBuilder<CustactiveController>(
        init: CustactiveController(),
        builder: (ctx) => RefreshIndicator(
          onRefresh: () => _handleRefresh(ctx),
          child: _buildBody(ctx),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Pilih Cust Active'),
      actions: [
        _buildSyncButton(context),
        _buildHistoryButton(),
      ],
    );
  }

  IconButton _buildSyncButton(BuildContext context) {
    return IconButton(
      onPressed: () => _syncData(context),
      icon: const Icon(Icons.sync),
      tooltip: 'Sync Data Customer',
    );
  }

  IconButton _buildHistoryButton() {
    return IconButton(
      onPressed: () => Get.toNamed(Routes.HISTORY_VISITASI, arguments: Call.custactive),
      icon: const Icon(Icons.history),
      tooltip: 'History Visitasi Customer',
    );
  }

  Future<void> _syncData(BuildContext context) async {
    Utils.showLoadingDialog(context);
    await Get.find<CustactiveController>().updateCustomerActive();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleRefresh(CustactiveController ctx) async {
    if (!ctx.isLoading) {
      ctx.setSelectedCustId(null);
      ctx.getCustActive();
    }
  }

  Widget _buildBody(CustactiveController ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildSearchField(ctx),
          const SizedBox(height: 16.0),
          _buildCustomerList(ctx),
          const SizedBox(height: 12.0),
          _buildContinueButton(ctx),
        ],
      ),
    );
  }

  Widget _buildSearchField(CustactiveController ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppTextField(
        controller: searchController,
        hintText: 'Cari Customer',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            searchController.clear();
            ctx.clearSearch();
            ctx.setSelectedCustId(null);
          },
        ),
        onChanged: ctx.searchCust,
      ),
    );
  }

  Widget _buildCustomerList(CustactiveController ctx) {
    return Expanded(
      child: ctx.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctx.custActive.isEmpty
          ? const Center(child: Text('Data tidak ditemukan'))
          : ListView.builder(
        itemCount: ctx.custActiveFiltered.length,
        itemBuilder: (_, index) => _buildListItem(ctx, index),
      ),
    );
  }

  Widget _buildListItem(CustactiveController ctx, int index) {
    final cust = ctx.custActiveFiltered[index];
    return RadioListTile<CustactiveModel>(
      title: Text(cust.name!),
      subtitle: Text(cust.address!),
      value: cust,
      groupValue: ctx.selectedCustId,
      onChanged: (value) => ctx.setSelectedCustId(value),
    );
  }

  Widget _buildContinueButton(CustactiveController ctx) {
    return ElevatedButton(
      onPressed: ctx.selectedCustId == null ? null : () => _navigateToMarketing(ctx),
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
      child: const Text('Lanjut'),
    );
  }

  void _navigateToMarketing(CustactiveController ctx) {
    // print('Selected Cust: ${ctx.selectedCustId}');
    Get.toNamed(Routes.MARKETING, arguments: {
      'type': Call.custactive,
      'id': ctx.selectedCustId!.id,
      'name': ctx.selectedCustId!.name,
    });
  }
}

