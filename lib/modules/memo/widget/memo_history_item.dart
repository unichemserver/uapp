import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/pdf_viewer.dart';

class MemoHistoryItem extends StatelessWidget {
  MemoHistoryItem({
    super.key,
    required this.historyMemo,
    required this.memo,
    required this.action,
  });

  final HistoryMemo historyMemo;
  final MemoIcon memo;
  final String action;

  var statusMap = {
    '1': 'Draft',
    '2': 'Ongoing',
    '3': 'Close',
    '4': 'Cancel',
  };

  var progresMap = {
    '1': 'Draft',
    '2': 'Posted',
    '3': 'Replaced',
    '4': 'Canceled',
  };
  String? taskId;

  String getStatus(String status) {
    return statusMap[status] ?? 'Draft';
  }

  String getProgres(String status) {
    return progresMap[status] ?? 'Draft';
  }

  @override
  Widget build(BuildContext context) {
    final memoMap = {
      'RGR': historyMemo.regular,
      'TGA': historyMemo.targetA,
      'TGB': historyMemo.targetB,
      'RTR': historyMemo.retur,
      'PGL': historyMemo.pengalihanA,
      'MRL': historyMemo.marcol,
      'KHS': historyMemo.khusus,
      'SPL': historyMemo.sample,
      'LCT': historyMemo.locationTransfer,
      'ACC': historyMemo.accounting,
      'KOR': historyMemo.koordinasi,
      'BRK': historyMemo.barangRusak,
    };

    final memos = memoMap[memo.no] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Memo ${memo.name}'),
      ),
      body: memos.isNotEmpty
          ? ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final e = memos[index];
                int status = int.parse(e.status);
                String table = e.toJson()['tabel'];
                return ExpansionTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  initiallyExpanded: true,
                  title: Text(e.no),
                  leading: _buildTgl(e.tgl),
                  subtitle: Text('Progress: ${getProgres(e.status)}'),
                  trailing: Text('Status:\n${getStatus(e.status)}'),
                  children: _buildMemoAct(e, status, table, context),
                );
              },
            )
          : Center(
              child: LottieBuilder.asset(Assets.noDataAnimation),
            ),
    );
  }

  List<Widget> _buildMemoAct(
    dynamic e,
    int status,
    String table,
    BuildContext context,
  ) {
    if (action == MemoAct.approval) {
      return [
        Align(
          alignment: Alignment.centerRight,
          child: _buildEditAndCancelButtons(context, e, table),
        ),
      ];
    }
    if (action == MemoAct.received) {
      return [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              _routeToEditMemo(context, e, table);
            },
            icon: const Icon(Icons.preview),
          ),
        )
      ];
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildIconButton(
            context,
            icon: Icons.download_rounded,
            onPressed: () async {
              var url =
                  '${Utils.getEDSUrl()}?page=memo&modul=$table&action=print&cat=$table&id=${e.id}';
              var token = Utils.getUserData().token;
              url = '$url&mobile_token=$token';
              await _downloadFile(url, context);
            },
          ),
          _buildIconButton(
            context,
            icon: Icons.preview,
            onPressed: () {
              var url =
                  '${Utils.getEDSUrl()}?page=memo&modul=$table&action=view&cat=$table&id=${e.id}';
              var token = Utils.getUserData().token;
              url = '$url&mobile_token=$token';
              _showPdfViewer(context, url);
            },
          ),
          if (status == 1 || status == 0)
            _buildPostAndDeleteButtons(context, e, table),
          if (status >= 2) _buildEditAndCancelButtons(context, e, table),
        ],
      ),
    ];
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }

  Future<void> _downloadFile(
    String url,
    BuildContext context,
  ) async {
    taskId = await FlutterDownloader.enqueue(
      url: url,
      headers: {},
      savedDir: '/storage/emulated/0/Download',
      showNotification: true,
      openFileFromNotification: true,
    );
    if (context.mounted) {
      Utils.showSnackbar(context, 'Memo sedang diunduh');
    }

    Future.delayed(const Duration(seconds: 3), () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Download Selesai'),
            content: const Text('Apakah anda ingin membuka file ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  FlutterDownloader.open(taskId: taskId!);
                  Navigator.pop(context);
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    });
  }

  void _showPdfViewer(
    BuildContext context,
    String url,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: PdfViewer(
            url: url,
          ),
        );
      },
    );
  }

  Widget _buildPostAndDeleteButtons(
    BuildContext context,
    dynamic e,
    String table,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          context,
          icon: Icons.send,
          onPressed: () => _confirmAction(context, 'Post Memo',
              'Apakah anda yakin ingin memposting memo ini?', () {
            var token = Utils.getUserData().token;
            _executeUpdateMemo(
              context,
              '${Utils.getEDSUrl()}?page=memo&modul=post&cat=$table&id=${e.id}&mobile_token=$token',
              'Posting memo...',
              'Memo berhasil diposting',
            );
          }),
        ),
        _buildIconButton(
          context,
          icon: Icons.delete,
          onPressed: () => _confirmAction(context, 'Hapus Memo',
              'Apakah anda yakin ingin menghapus memo ini?', () {
            var token = Utils.getUserData().token;
            _executeUpdateMemo(
              context,
              '${Utils.getEDSUrl()}?page=memo&modul=delete&cat=$table&id=${e.id}&mobile_token=$token',
              'Menghapus memo...',
              'Memo berhasil dihapus',
            );
          }),
        ),
      ],
    );
  }

  String getMonth(String month) {
    switch (month) {
      case '01':
        return 'JAN';
      case '02':
        return 'FEB';
      case '03':
        return 'MAR';
      case '04':
        return 'APR';
      case '05':
        return 'MAY';
      case '06':
        return 'JUN';
      case '07':
        return 'JUL';
      case '08':
        return 'AUG';
      case '09':
        return 'SEP';
      case '10':
        return 'OCT';
      case '11':
        return 'NOV';
      case '12':
        return 'DEC';
      default:
        return '';
    }
  }

  Widget _buildTgl(String tgl) {
    var tglSplit = tgl.split('-');
    var year = tglSplit[0];
    var month = tglSplit[1];
    var day = tglSplit[2];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getMonth(month),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '$day, $year',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEditAndCancelButtons(
    BuildContext context,
    dynamic e,
    String table,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          context,
          icon: Icons.edit,
          onPressed: () {
            _routeToEditMemo(context, e, table);
          },
        ),
        _buildIconButton(
          context,
          icon: Icons.cancel_outlined,
          onPressed: () => _confirmAction(context, 'Cancel Memo',
              'Apakah anda yakin ingin membatalkan memo ini?', () {
            _executeUpdateMemo(
              context,
              '${Utils.getEDSUrl()}?page=memo&modul=cancel&cat=$table&id=${e.id}',
              'Membatalkan memo...',
              'Memo berhasil dibatalkan',
            );
          }),
        ),
      ],
    );
  }

  void _confirmAction(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  void _executeUpdateMemo(
    BuildContext context,
    String url,
    String loadingMessage,
    String successMessage,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingDialog(message: loadingMessage);
      },
      barrierDismissible: false,
    );
    api.updateMemo(url).then((value) {
      Navigator.pop(context);
      if (value == null) {
        Utils.showSnackbar(context, successMessage);
        Navigator.pop(context);
      } else {
        Utils.showSnackbar(context, value);
      }
    });
  }

  void _routeToEditMemo(
    BuildContext context,
    dynamic e,
    String table,
  ) {
    Navigator.pushNamed(
      context,
      '/${memo.name.replaceAll(' ', '_').toLowerCase()}',
      arguments: {
        'memo': memo,
        'data': e,
        'action': action,
      },
    );
  }
}
