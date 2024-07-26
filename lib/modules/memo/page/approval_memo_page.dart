import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/memo_history_item.dart';

class ApprovalMemoPage extends StatefulWidget {
  const ApprovalMemoPage({super.key});

  @override
  State<ApprovalMemoPage> createState() => _ApprovalMemoPageState();
}

class _ApprovalMemoPageState extends State<ApprovalMemoPage> {
  HistoryMemo? historyMemo;

  getHistoryMemo() async {
    historyMemo = await api.getApprMemo(Utils.getBaseUrl());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHistoryMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Memo'),
      ),
      body: ListView.builder(
        itemCount: createdMemoList.length,
        itemBuilder: (context, index) {
          final memo = createdMemoList[index];
          return Card(
            child: ListTile(
              onTap: () {
                if (historyMemo == null) {
                  Utils.showSnackbar(context, 'Sedang memuat data');
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoHistoryItem(
                      historyMemo: historyMemo!,
                      memo: memo,
                      action: MemoAct.approval,
                    ),
                  ),
                );
              },
              title: Text(memo.name),
              leading: Icon(memo.icon),
              trailing: historyMemo != null
                  ? Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        getMemoCount(historyMemo!, memo.no).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      width: 16,
                      height: 16,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
