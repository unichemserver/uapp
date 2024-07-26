import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/memo_history_item.dart';

class ReceivedMemoPage extends StatefulWidget {
  const ReceivedMemoPage({super.key});

  @override
  State<ReceivedMemoPage> createState() => _ReceivedMemoPageState();
}

class _ReceivedMemoPageState extends State<ReceivedMemoPage> {
  HistoryMemo? receivedMemo;

  getMemoHistory() async {
    final result = await api.getReceivedMemo(Utils.getBaseUrl());
    setState(() {
      receivedMemo = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getMemoHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo Diterima'),
      ),
      body: ListView.builder(
        itemCount: createdMemoList.length,
        itemBuilder: (context, index) {
          final memo = createdMemoList[index];
          return Card(
            child: ListTile(
              onTap: () {
                if (receivedMemo == null) {
                  Utils.showSnackbar(context, 'Sedang memuat data');
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoHistoryItem(
                      historyMemo: receivedMemo!,
                      memo: memo,
                      action: MemoAct.received,
                    ),
                  ),
                );
              },
              title: Text(memo.name),
              leading: Icon(memo.icon),
              trailing: receivedMemo != null
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
                        getMemoCount(receivedMemo!, memo.no).toString(),
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
