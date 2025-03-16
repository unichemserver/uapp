import 'package:flutter/material.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/home/home_api.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  List<Map<String, dynamic>> approvalData = [];
  final db = MarketingDatabase();

  @override
  void initState() {
    super.initState();
    fetchApprovalData();
  }

  Future<void> fetchApprovalData() async {
    final allApprovalData = await HomeApi.getAllApprovalData();
    if (allApprovalData != null) {
      setState(() {
        approvalData = allApprovalData;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval'),
      ),
      body: approvalData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: approvalData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${approvalData[index]['userId']}'),
                        Text('Approval ID: ${approvalData[index]['data']}'),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle approve action
                              },
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                // Handle reject action
                              },
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
