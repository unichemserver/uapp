import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/fonts.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/auth/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final TextEditingController unameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Strings.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontFamily: Fonts.rubik,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SpeechToTextField(
                    controller: unameController,
                    hintText: 'Masukkan nama pengguna',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama pengguna tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppTextField(
                    obscureText: !ctx.isPasswordVisible,
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
                  DropdownButtonFormField<String>(
                    value: ctx.selectedInstance,
                    onChanged: ctx.setSelectedInstance,
                    items: instances.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      labelText: 'Instance',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      prefixIcon: Icon(Icons.home_work),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (ctx.selectedInstance != null) {
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
                          Get.snackbar(
                            'Error',
                            'Pilih instance terlebih dahulu',
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(Strings.login),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
