import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/production/data/model/barang.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({
    Key? key,
    required this.searchCtrl,
    this.onSearch,
    required this.barang,
    this.isOnSearch = false,
    required this.onResultTap,
  }) : super(key: key);

  final TextEditingController searchCtrl;
  final void Function()? onSearch;
  final List<BarangBalance> barang;
  final bool isOnSearch;
  final void Function(BarangBalance item) onResultTap;

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  bool _isOnSearch = false;
  List<BarangBalance> _barang = [];

  @override
  void initState() {
    super.initState();
    _isOnSearch = widget.isOnSearch;
    _barang = widget.barang;
  }

  @override
  void didUpdateWidget(covariant SearchItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOnSearch != widget.isOnSearch) {
      setState(() {
        _isOnSearch = widget.isOnSearch;
      });
    }
    if (oldWidget.barang != widget.barang) {
      setState(() {
        _barang = widget.barang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          AppTextField(
            controller: widget.searchCtrl,
            hintText: 'Cari Barang',
            suffixIcon: IconButton(
              onPressed: widget.onSearch,
              icon: const Icon(Icons.search),
            ),
            onSubmitted: (_) {
              widget.onSearch!();
            },
            textInputAction: TextInputAction.search,
          ),
          Expanded(
            child: _isOnSearch
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _barang.isEmpty
                    ? Center(
                        child: LottieBuilder.asset(Assets.noDataAnimation),
                      )
                    : ListView.builder(
                        itemCount: _barang.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_barang[index].descitem),
                            subtitle: Text(_barang[index].itemid),
                            onTap: () {
                              widget.onResultTap(_barang[index]);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
