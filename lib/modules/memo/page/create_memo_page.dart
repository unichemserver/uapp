import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/memo_history_item.dart';

class CreateMemoPage extends StatefulWidget {
  const CreateMemoPage({super.key});

  @override
  State<CreateMemoPage> createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  HistoryMemo? historyMemo;
  bool isLoading = true;

  getHistoryMemo() async {
    isLoading = true;
    historyMemo = await api.getMemo(Utils.getBaseUrl());
    isLoading = false;
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
        title: const Text('Buat Memo'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              getHistoryMemo();
              setState(() {
                isLoading = false;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await getHistoryMemo();
          setState(() {
            isLoading = false;
          });
        },
        child: ListView.builder(
          itemCount: createdMemoList.length,
          itemBuilder: (context, index) {
            return Hero(
              tag: createdMemoList[index].name,
              child: Card(
                child: ExpansionTile(
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(createdMemoList[index].name),
                  leading: Icon(createdMemoList[index].icon),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/${createdMemoList[index].name.replaceAll(' ', '_').toLowerCase()}',
                            arguments: {
                              'memo': createdMemoList[index],
                              'action': MemoAct.create,
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {
                          if (isLoading) {
                            Utils.showSnackbar(context, 'Sedang memuat data');
                            return;
                          }
                          if (historyMemo == null) {
                            Utils.showSnackbar(context, 'Gagal memuat data');
                            getHistoryMemo();
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemoHistoryItem(
                                historyMemo: historyMemo!,
                                memo: createdMemoList[index],
                                action: MemoAct.create,
                              ),
                            ),
                          ).then((value) async {
                            setState(() {
                              isLoading = true;
                            });
                            await getHistoryMemo();
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                        icon: const Icon(Icons.history),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
