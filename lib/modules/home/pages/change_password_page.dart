import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/home/home_controller.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final TextEditingController passwdController = TextEditingController();
  final TextEditingController confirmPasswdController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              Get.dialog(
                AlertDialog(
                  title: const Text('Peringatan'),
                  content: const Text('Ganti password anda terlebih dahulu, untuk melanjutkan ke halaman lain'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Ganti Password'),
            ),
            body: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwdController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(ctx.showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: ctx.togglePasswordVisibility,
                      ),
                    ),
                    obscureText: !ctx.showPassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: confirmPasswdController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Konfirmasi password tidak boleh kosong';
                      }
                      if (value != passwdController.text) {
                        return 'Password tidak sama';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password Baru',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(ctx.showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: ctx.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    obscureText: !ctx.showConfirmPassword,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '*Pastikan password baru anda berbeda dengan password sebelumnya',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Get.dialog(
                          const LoadingDialog(
                            message: 'Mengubah password...',
                          ),
                          barrierDismissible: false,
                        );
                        ctx.changePassword(passwdController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Perbarui Password'),
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
