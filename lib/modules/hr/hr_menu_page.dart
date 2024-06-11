import 'package:flutter/material.dart';
import 'package:uapp/modules/hr/config.dart' as config;

class HrMenuPage extends StatefulWidget {
  const HrMenuPage({super.key});

  @override
  State<HrMenuPage> createState() => _HrMenuPageState();
}

class _HrMenuPageState extends State<HrMenuPage> {
  FocusNode searchFocus = FocusNode();
  var hrMenuList = config.hrMenuList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Menu'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
        ),
        itemCount: hrMenuList.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => hrMenuList[index].page,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      hrMenuList[index].icon,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      hrMenuList[index].title,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}