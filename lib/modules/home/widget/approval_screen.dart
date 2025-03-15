import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  List<String> approvalData = [];

  @override
  void initState() {
    super.initState();
    fetchApprovalData();
  }

  Future<void> fetchApprovalData() async {
    final response = await http.post(
      Uri.parse('https://unichem.co.id/api/'),
      body: {
        'action': 'noo',
        'method': 'get_data_approval',
        'userid': '1580',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['message'] == 'Data Found') {
        setState(() {
          approvalData = List<String>.from(data['data'].map((item) => item['nonoo']));
        });
      }
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
                        Text('Approval ID: ${approvalData[index]}'),
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
