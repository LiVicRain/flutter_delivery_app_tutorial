import 'dart:convert';
import 'dart:io';

import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:delivery_app_tutorial/common/constants/data.dart';
import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:delivery_app_tutorial/common/services/secure_storage/secure_storage.dart';
import 'package:delivery_app_tutorial/common/views/root_tab.dart';
import 'package:delivery_app_tutorial/user/models/user_model.dart';
import 'package:delivery_app_tutorial/user/providers/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/components/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userName = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 15),
                const _SubTitle(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    "assets/img/misc/logo.png",
                  ),
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  hintText: "이메일을 입력하세요",
                  onChanged: (String value) {
                    userName = value;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  hintText: "비밀번호를 입력해주세요",
                  onChanged: (String value) {
                    password = value;
                  },
                  isSecret: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: state is UserModelLoading
                      ? null
                      : () async {
                          ref
                              .read(userMeProvider.notifier)
                              .login(userName: userName, password: password);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uPrimaryColor,
                  ),
                  child: const Text("로그인"),
                ),
                TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                    foregroundColor: uPrimaryColor,
                  ),
                  child: const Text("회원가입"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환영합니다",
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길',
      style: TextStyle(
        fontSize: 16,
        color: uFontBodyColor,
      ),
    );
  }
}
