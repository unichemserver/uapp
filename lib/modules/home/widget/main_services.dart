import 'package:flutter/material.dart';
import 'package:uapp/modules/home/widget/service_icon.dart';

class MainServiceIcon extends StatelessWidget {
  const MainServiceIcon({
    super.key,
    required this.isMasterAvailable,
    required this.isMasterSelected,
    required this.onMasterSelected,
    required this.isTransactionAvailable,
    required this.isTransactionSelected,
    required this.onTransactionSelected,
    required this.isReportAvailable,
    required this.isReportSelected,
    required this.onReportSelected,
  });

  final bool isMasterAvailable;
  final bool isTransactionAvailable;
  final Function() onMasterSelected;
  final bool isReportAvailable;
  final bool isMasterSelected;
  final Function() onTransactionSelected;
  final bool isTransactionSelected;
  final bool isReportSelected;
  final Function() onReportSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isMasterAvailable
            ? Expanded(
                child: GestureDetector(
                  onTap: onMasterSelected,
                  child: ServiceIcon(
                    title: 'Master',
                    icon: Icons.account_circle,
                    isSelected: isMasterSelected,
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 20),
        isTransactionAvailable
            ? Expanded(
                child: GestureDetector(
                  onTap: onTransactionSelected,
                  child: ServiceIcon(
                    title: 'Transaction',
                    icon: Icons.account_balance_wallet,
                    isSelected: isTransactionSelected,
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(width: 20),
        isReportAvailable
            ? Expanded(
                child: GestureDetector(
                  onTap: onReportSelected,
                  child: ServiceIcon(
                    title: 'Report',
                    icon: Icons.insert_chart,
                    isSelected: isReportSelected,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
