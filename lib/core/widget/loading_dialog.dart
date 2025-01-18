import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: LottieBuilder.asset(Assets.loadingAnimation),
              ),
              const SizedBox(width: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }
}
