import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_wanyu/bloc/upload_bankbook_screen_bloc.dart';
import 'package:security_wanyu/enum/onboard_documents.dart';
import 'package:security_wanyu/model/member.dart';
import 'package:security_wanyu/model/upload_document_screen_model.dart';
import 'package:security_wanyu/screen/take_document_image_screen.dart';
import 'package:security_wanyu/widget/upload_onboard_document_widget.dart';

class UploadBankbookScreen extends StatelessWidget {
  final UploadBankbookScreenBloc bloc;
  const UploadBankbookScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  static Widget create({required Member member}) {
    return Provider<UploadBankbookScreenBloc>(
      create: (context) => UploadBankbookScreenBloc(member: member),
      child: Consumer<UploadBankbookScreenBloc>(
        builder: (context, bloc, _) => UploadBankbookScreen(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('存摺上傳'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<UploadDocumentScreenModel>(
              stream: bloc.stream,
              initialData: bloc.model,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    UploadOnboardDocumentWidget(
                      content: '請拍攝內含存摺帳號、銀行及分行之資訊頁面。',
                      documentType: OnboardDocuments.bankbook,
                      image: snapshot.data!.image1,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TakeDocumentImageScreen(
                            documentType: OnboardDocuments.bankbook,
                            cameraLensDirection: CameraLensDirection.back,
                            onShutterPressed: bloc.takeImage,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      margin: const EdgeInsets.only(top: 32, bottom: 16),
                      child: ElevatedButton(
                        onPressed: snapshot.data!.canSubmit!
                            ? () => bloc.submit().then(
                                  (result) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(result ? '存摺上傳成功' : '存摺上傳失敗'),
                                      content: Text(
                                          result ? '存摺上傳成功！' : '存摺上傳失敗，請再試一次。'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            '確認',
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).then(
                                    (_) => Navigator.of(context).pop(),
                                  ),
                                )
                            : null,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Center(child: Text('上傳')),
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
