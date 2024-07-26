import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uapp/core/utils/log.dart';

class SpeechToTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String localeId;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final void Function(String)? onChanged;
  final bool readOnly;

  const SpeechToTextField({
    super.key,
    required this.controller,
    this.hintText = 'Masukkan teks',
    this.localeId = 'id_ID',
    this.readOnly = false,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.initialValue,
    this.onChanged,
  });

  @override
  _SpeechToTextFieldState createState() => _SpeechToTextFieldState();
}

class _SpeechToTextFieldState extends State<SpeechToTextField> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  BuildContext? _bottomSheetContext;
  Timer? _listenTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) {
        Log.d('onStatus: $val');
        if (val == 'done' || val == 'notListening') {
          _stopListening();
        }
      },
      onError: (val) {
        Log.d('onError: $val');
        _stopListening();
      },
    );
    if (!available) {
      Log.d('The user has denied the use of speech recognition.');
    }
  }

  void _listen() async {
    if (!_isListening) {
      await _initializeSpeech();
      if (_speech.isAvailable) {
        setState(() => _isListening = true);
        _showListeningModal();
        _speech.listen(
          onResult: (val) {
            setState(() {
              widget.controller.text = val.recognizedWords;
            });
          },
          localeId: widget.localeId,
        );
        _listenTimer = Timer(const Duration(seconds: 10), _stopListening);
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    _listenTimer?.cancel();
    if (_bottomSheetContext != null) {
      Navigator.pop(_bottomSheetContext!);
      _bottomSheetContext = null;
    }
  }

  void _showListeningModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        _bottomSheetContext = context;
        return WillPopScope(
          onWillPop: () async {
            _stopListening();
            return true;
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Listening...'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        hintText: widget.hintText,
        // suffixIcon: IconButton(
        //   icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        //   onPressed: _listen,
        // ),
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _listenTimer?.cancel();
    super.dispose();
  }
}
