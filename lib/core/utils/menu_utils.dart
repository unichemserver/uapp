import 'package:flutter/material.dart';
import 'package:uapp/modules/hrd/pages/guest_arrival_page.dart';
import 'package:uapp/modules/memo/page/approval_memo_page.dart';
import 'package:uapp/modules/memo/page/create_memo_page.dart';
import 'package:uapp/modules/memo/page/received_memo_page.dart';
import 'package:uapp/modules/production/page/item_balance_page.dart';

bool routeToPage(String url, BuildContext context) {
  switch (url) {
    case '?page=memo&amp;modul=memo':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateMemoPage(),
        ),
      );
      return true;
    case '?page=memo&amp;modul=memo_diterima':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ReceivedMemoPage(),
        ),
      );
      return true;
    case '?page=memo&amp;modul=memo_menunggu_tanda_tangan':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ApprovalMemoPage(),
        ),
      );
      return true;
    case '?page=item&amp;modul=balance':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ItemBalancePage(),
        ),
      );
      return true;
    case '?page=hrd&amp;modul=kedatangan_tamu':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GuestArrivalPage(),
        ),
      );
      return true;
  }
  return false;
}
