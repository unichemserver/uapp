import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/signature_container.dart';

class SignatureWidget extends StatefulWidget {
  SignatureWidget({
    super.key,
    required this.title,
    required this.contacts,
    this.onChanged,
    this.onSaveSignature,
    this.signatureData,
    this.selectedSignature,
    this.selectedContact,
    this.disabledSignature = false,
    this.disabledContact = false,
  });

  final String title;
  final List<Contact> contacts;
  final void Function(Contact?)? onChanged;
  final void Function(ByteData?)? onSaveSignature;
  final ByteData? signatureData;
  final String? selectedSignature;
  Contact? selectedContact;
  final bool disabledSignature;
  final bool disabledContact;

  @override
  State<SignatureWidget> createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
  final HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ByteData? signatureData;
  bool showButton = false;

  void isEditMemo() {
    if (widget.signatureData != null) {
      signatureData = widget.signatureData;
    }
  }

  @override
  void initState() {
    super.initState();
    isEditMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (widget.disabledSignature) {
              return;
            }
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
            showDialog(
              context: context,
              builder: (context) {
                return PopScope(
                  canPop: true,
                  onPopInvoked: (didPop) {
                    if (didPop) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    }
                  },
                  child: Dialog(
                    child: SignatureContainer(
                      control: control,
                      title: widget.title,
                      onSaveSignature: (signature) {
                        setState(() {
                          signatureData = signature;
                        });
                        widget.onSaveSignature?.call(signature);
                      },
                    ),
                  ),
                );
              },
              barrierDismissible: false,
            );
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: signatureData != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.disabledSignature
                            ? Colors.red
                            : Colors.blue,
                        width: widget.disabledSignature ? 1 : 3,
                      ),
                      image: const DecorationImage(
                        image: AssetImage(Assets.placeholderTtd),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Image.memory(
                      signatureData!.buffer.asUint8List(),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(Assets.placeholderTtd),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: const Center(
                            child: Text('Tanda tangan tidak valid'),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage(Assets.placeholderTtd),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        DropdownList<Contact>(
          onChanged: widget.disabledContact ? null : widget.onChanged,
          items: widget.contacts,
          displayItem: (item) => item.name,
          selectedItem: widget.selectedContact,
        ),
      ],
    );
  }
}
