import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/models/customer.dart';

class SelectExistingCustomerSheet extends StatelessWidget {
  const SelectExistingCustomerSheet({
    super.key,
    required this.existingCustomer,
    required this.onLanjut,
    required this.onSelect,
    required this.customerId,
  });

  final List<Customer> existingCustomer;
  final Function() onLanjut;
  final Function(Customer?) onSelect;
  final String customerId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pilih Customer Aktif',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownSearch<Customer>(
              items: existingCustomer,
              selectedItem: existingCustomer.firstWhere(
                (element) => element.custId == customerId,
                orElse: () => existingCustomer.first,
              ),
              itemAsString: (Customer item) =>
                  '${item.custId} - ${item.custName}',
              onChanged: onSelect,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                disabledItemFn: (item) {
                  return item.custId == 'Pilih Customer Aktif';
                },
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Cari Customer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onLanjut,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
