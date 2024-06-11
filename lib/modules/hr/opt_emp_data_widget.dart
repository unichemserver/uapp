import 'package:flutter/material.dart';

class AdditionalEmployeeData extends StatelessWidget {
  const AdditionalEmployeeData({
    super.key,
    required this.nikController,
    required this.departmentController,
    required this.divisionController,
    required this.positionController,
  });

  final TextEditingController nikController;
  final TextEditingController departmentController;
  final TextEditingController divisionController;
  final TextEditingController positionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: nikController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'No NIK',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: departmentController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Departemen',
            prefixIcon: const Icon(Icons.apartment),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: divisionController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Bagian',
            prefixIcon: const Icon(Icons.work),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: positionController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Jabatan',
            prefixIcon: const Icon(Icons.badge),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
