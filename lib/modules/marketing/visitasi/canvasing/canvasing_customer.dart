import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
// import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/history_canvasing_screen.dart';

class CanvasingCustomerPage extends StatelessWidget {
  CanvasingCustomerPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          // Placeholder for refresh logic
        },
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Pilih Customer'),
      actions: [
        _buildAddCustomer(),
        _buildHistoryButton(),
      ],
    );
  }

  IconButton _buildHistoryButton() {
    return IconButton(
      onPressed: () {
        Get.to(() => const HistoryCanvasingScreen());
      },
      icon: const Icon(Icons.history),
      tooltip: 'History Canvasing',
    );
  }
    IconButton _buildAddCustomer() {
    return IconButton(
      onPressed: () {
        Get.toNamed(Routes.CANVASING);
      },
      icon: const Icon(Icons.add_business_outlined),
      tooltip: 'History Canvasing',
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 16.0),
          _buildCustomerList(),
          const SizedBox(height: 12.0),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
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
                  // Placeholder for clearing search logic
                },
              ),
        onChanged: (value) {
          // Placeholder for search logic
        },
      ),
    );
  }

  Widget _buildCustomerList() {
    return Expanded(
      child: Center(
        child: const Text('Data tidak ditemukan'), // Placeholder for customer list
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: null, // Placeholder for navigation logic
      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
      child: const Text('Lanjut'),
    );
  }
}
