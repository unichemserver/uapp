import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uapp/app/fonts.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/auth/auth_controller.dart';
import 'package:uapp/core/widget/webview_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController unameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _isNeedPermission() async {
    Permission location = Permission.location;
    Permission notification = Permission.notification;
    return !(await location.isGranted) || !(await notification.isGranted);
  }

  _requestPermission() async {
    Permission location = Permission.location;
    Permission notification = Permission.notification;
    if (!await location.isGranted) await location.request();
    if (!await notification.isGranted) await notification.request();
  }

  _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Perhatian'),
        content: const Text(
          'Aplikasi U-APP membutuhkan akses lokasi dan notifikasi untuk dapat berjalan dengan baik. Pastikan Anda mengizinkan akses tersebut.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _requestPermission();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isNeedPermission().then((value) {
        if (value) {
          _showPermissionDialog();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(
                        top: 50,
                        bottom: 10,
                      ),
                      child: LottieBuilder.asset(Assets.loginAnimation),
                    ),
                    Text(
                      Strings.appTitle,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontFamily: Fonts.openSans,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    AppTextField(
                      controller: unameController,
                      hintText: 'Masukkan nomor NIK',
                      prefixIcon: const Icon(Icons.person),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor NIK tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextField(
                      obscureText: !ctx.isPasswordVisible,
                      hintText: 'Masukkan kata sandi',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Kata sandi tidak boleh kosong';
                        }
                        return null;
                      },
                      controller: passController,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          ctx.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: ctx.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.end,
                      runAlignment: WrapAlignment.end,
                      children: instances.keys
                          .map(
                            (instance) => ChoiceChip(
                              label: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Text(instance),
                              ),
                              selected: ctx.selectedInstance == instance,
                              onSelected: (selected) {
                                ctx.toggleInstanceSelected(false);
                                if (selected) {
                                  ctx.setSelectedInstance(instance);
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                    if (ctx.showInstanceError)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: Text(
                          'Pilih instance terlebih dahulu',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: ctx.isAgree,
                          onChanged: (value) {
                            ctx.toggleAgree(value!);
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'Dengan menggunakan aplikasi ini, Anda secara otomatis menyetujui ',
                              style: Theme.of(context).textTheme.labelMedium,
                              children: [
                                TextSpan(
                                  text: 'Kebijakan Privasi',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(() => const AuthWebviewWidget(
                                            url:
                                                'https://unichem.co.id/uapp/privacy_policy.html',
                                            title: 'Kebijakan Privasi U-APP',
                                          ));
                                    },
                                ),
                                const TextSpan(
                                  text: ' dan ',
                                ),
                                TextSpan(
                                  text: 'Syarat Penggunaan',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(() => const AuthWebviewWidget(
                                            url:
                                                'https://unichem.co.id/uapp/term_of_use.html',
                                            title: 'Syarat Penggunaan U-APP',
                                          ));
                                    },
                                ),
                                const TextSpan(
                                  text: ' yang berlaku.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: ctx.isAgree
                          ? () async {
                              if (formKey.currentState!.validate()) {
                                if (ctx.selectedInstance != null) {
                                  bool isInternetAvailable =
                                      await Utils.isInternetAvailable();
                                  if (!isInternetAvailable) {
                                    if (Get.isSnackbarOpen) {
                                      Get.back();
                                    }
                                    Get.snackbar(
                                      'Tidak Ada Koneksi Internet',
                                      'Pastikan Anda terhubung ke internet',
                                    );
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return LoadingDialog(
                                        message: ctx.loadingMessage!,
                                      );
                                    },
                                  );
                                  ctx.login(
                                    unameController.text,
                                    passController.text,
                                  );
                                } else {
                                  ctx.toggleInstanceSelected(true);
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text(Strings.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
