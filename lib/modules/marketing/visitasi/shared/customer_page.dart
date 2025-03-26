import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_controller.dart';

class CustomerPage extends StatelessWidget {
  final String title;
  final Future<void> Function(CustactiveController) fetchData;
  final void Function(CustactiveController) onContinue;
  final List<Widget>? actions; // New parameter for AppBar actions

  const CustomerPage({
    super.key,
    required this.title,
    required this.fetchData,
    required this.onContinue,
    this.actions, // Initialize actions
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions, // Use the passed actions
      ),
      body: GetBuilder<CustactiveController>(
        init: CustactiveController(),
        builder: (ctx) => RefreshIndicator(
          onRefresh: () => fetchData(ctx),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                _buildSearchField(ctx, searchController),
                const SizedBox(height: 16.0),
                _buildCustomerList(ctx),
                const SizedBox(height: 12.0),
                _buildContinueButton(ctx),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(CustactiveController ctx, TextEditingController searchController) {
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
          : ctx.custActiveFiltered.isEmpty
              ? const Center(child: Text('Data tidak ditemukan'))
              : ListView.builder(
                  itemCount: ctx.custActiveFiltered.length,
                  itemBuilder: (_, index) => RadioListTile(
                    title: Text(ctx.custActiveFiltered[index].name!),
                    subtitle: Text(ctx.custActiveFiltered[index].address!),
                    value: ctx.custActiveFiltered[index],
                    groupValue: ctx.selectedCustId,
                    onChanged: (value) => ctx.setSelectedCustId(value),
                  ),
                ),
    );
  }

  Widget _buildContinueButton(CustactiveController ctx) {
    return ElevatedButton(
      onPressed: ctx.selectedCustId == null ? null : () => onContinue(ctx),
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
      child: const Text('Lanjut'),
    );
  }

  // Future<void> _syncData(BuildContext context) async {
  //   Utils.showLoadingDialog(context);
  //   await Get.find<CustactiveController>().updateCustomerActive();
  //   if (context.mounted) {
  //     Navigator.of(context).pop();
  //   }
  // }
}
