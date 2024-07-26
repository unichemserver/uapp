import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/widget/signature_widget.dart';

class SignatureForm extends StatefulWidget {
  const SignatureForm({
    super.key,
    required this.contacts,
    required this.onReqChanged, // select the contact
    required this.onCheckerChanged,
    required this.onApproverChanged,
    this.selectedReq, // the selected contact
    this.selectedChecker,
    this.selectedApprover,
    this.onSaveSignature, // save the signature
    this.onSaveNdmSignature,
    this.onSaveSmhSignature,
    this.signatureData, // the signature data
    this.ndmSignature,
    this.smhSignature,
    this.disabledContactReq = false,
    this.disabledContactChecker = false,
    this.disabledContactApprover = false,
    this.disabledSignatureReq = false,
    this.disabledSignatureChecker = false,
    this.disabledSignatureApprover = false,
    this.ndmKey,
    this.smhKey,
  });

  final List<Contact> contacts;
  final void Function(Contact?)? onReqChanged;
  final void Function(Contact?)? onCheckerChanged;
  final void Function(Contact?)? onApproverChanged;
  final void Function(ByteData?)? onSaveSignature;
  final void Function(ByteData?)? onSaveNdmSignature;
  final void Function(ByteData?)? onSaveSmhSignature;
  final ByteData? signatureData;
  final ByteData? ndmSignature;
  final ByteData? smhSignature;
  final String? selectedReq;
  final String? selectedChecker;
  final String? selectedApprover;
  final bool disabledContactReq;
  final bool disabledContactChecker;
  final bool disabledContactApprover;
  final bool disabledSignatureReq;
  final bool disabledSignatureChecker;
  final bool disabledSignatureApprover;
  final Key? ndmKey;
  final Key? smhKey;

  @override
  State<SignatureForm> createState() => _SignatureFormState();
}

class _SignatureFormState extends State<SignatureForm> {
  ByteData? signatureData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'PT. UnichemCandi Indonesia',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 16),
        SignatureWidget(
          title: 'Diajukan Oleh,',
          contacts: widget.contacts,
          onChanged: widget.onReqChanged,
          onSaveSignature: widget.onSaveSignature,
          signatureData: widget.signatureData,
          selectedContact: widget.contacts.firstWhereOrNull(
            (element) => element.id == widget.selectedReq,
          ),
          disabledContact: widget.disabledContactReq,
          disabledSignature: widget.disabledSignatureReq,
        ),
        const SizedBox(height: 16),
        SignatureWidget(
          key: widget.ndmKey,
          title: 'Diperiksa Oleh,',
          contacts: widget.contacts,
          onChanged: widget.onCheckerChanged,
          onSaveSignature: widget.onSaveNdmSignature,
          signatureData: widget.ndmSignature,
          selectedContact: widget.contacts.firstWhereOrNull(
            (element) => element.id == widget.selectedChecker,
          ),
          disabledContact: widget.disabledContactChecker,
          disabledSignature: widget.disabledSignatureChecker,
        ),
        const SizedBox(height: 16),
        SignatureWidget(
          key: widget.smhKey,
          title: 'Disetujui Oleh,',
          contacts: widget.contacts,
          onChanged: widget.onApproverChanged,
          onSaveSignature: widget.onSaveSmhSignature,
          signatureData: widget.smhSignature,
          selectedContact: widget.contacts.firstWhereOrNull(
            (element) => element.id == widget.selectedApprover,
          ),
          disabledContact: widget.disabledContactApprover,
          disabledSignature: widget.disabledSignatureApprover,
        ),
      ],
    );
  }
}
