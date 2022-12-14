import 'dart:async';
import 'package:flutter/material.dart';
import 'package:security_wanyu/enum/sign_in_results.dart';
import 'package:security_wanyu/model/api_exception.dart';
import 'package:security_wanyu/model/login_screen_model.dart';
import 'package:security_wanyu/model/member.dart';
import 'package:security_wanyu/screen/base_screen.dart';
import 'package:security_wanyu/service/etun_api.dart';
import 'package:security_wanyu/other/utils.dart';
import 'package:security_wanyu/service/local_database.dart';

class LoginScreenBloc {
  final StreamController<LoginScreenModel> _streamController =
      StreamController();
  Stream<LoginScreenModel> get stream => _streamController.stream;
  LoginScreenModel _model =
      LoginScreenModel(rememberMe: false, canSubmit: false);
  LoginScreenModel get model => _model;
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Member? localMember;

  Future<void> initialize() async {
    try {
      localMember = await LocalDatabase.instance.getMember();
      accountController.text = localMember?.memberAccount ?? '';
      passwordController.text = localMember?.memberPassword ?? '';
      updateWith(
        account: accountController.text,
        password: passwordController.text,
        canSubmit: _canSubmit(),
      );
    } on APIException catch (e) {
      if (e.code == 'no-local-member') {
        updateWith(
          account: '',
          password: '',
          canSubmit: _canSubmit(),
        );
      }
    }
  }

  void onInputAccount(String account) {
    updateWith(
      account: account,
      canSubmit: _canSubmit(),
    );
  }

  void onInputPassword(String password) {
    updateWith(
      password: password,
      canSubmit: _canSubmit(),
    );
  }

  void rememberMe(bool? isChecked) {
    updateWith(rememberMe: isChecked);
  }

  Future<void> signIn(BuildContext context) async {
    final navigator = Navigator.of(context);
    //確認有無連上網路。
    if (await Utils.hasInternetConnection()) {
      Map<String, dynamic> result = await EtunAPI.instance.signIn(
          memberAccount: _model.account!, memberPassword: _model.password!);
      SignInResults signInResults = result['signInResult'];
      switch (signInResults) {
        case SignInResults.success:
          if (!navigator.mounted) return;
          Member member = result['member'];
          await LocalDatabase.instance.insertMember(member: member);
          navigator.pushReplacement(
            MaterialPageRoute(
              builder: (context) => BaseScreen.create(member: member),
            ),
          );
          break;
        case SignInResults.wrongPassword:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('登入失敗'),
              content: const Text('帳號或密碼錯誤。'),
              actions: <Widget>[
                TextButton(
                  child: const Text('確認'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
          break;
        case SignInResults.error:
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('登入失敗'),
              content: const Text('發生錯誤。'),
              actions: <Widget>[
                TextButton(
                  child: const Text('確認'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
          break;
      }
    } else {
      if (_model.account == localMember?.memberAccount &&
          _model.password == localMember?.memberPassword) {
        if (!navigator.mounted) return;
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => BaseScreen.create(member: localMember!),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('登入失敗'),
            content: const Text('離線登入帳號或密碼錯誤。'),
            actions: <Widget>[
              TextButton(
                child: const Text('確認'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _canSubmit() {
    return accountController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void updateWith({
    String? account,
    String? password,
    bool? rememberMe,
    bool? canSubmit,
  }) {
    _model = _model.copyWith(
      account: account,
      password: password,
      rememberMe: rememberMe,
      canSubmit: canSubmit,
    );
    _streamController.add(_model);
  }

  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    _streamController.close();
  }
}
