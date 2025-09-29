import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';
import 'package:flutter_stone_payment/exceptions/stone_print_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/stone_content_print.dart';
import 'package:flutter_stone_payment/models/stone_print_payload.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _printTextEC = TextEditingController();
  final List<DropdownMenuItem<StonePrintType>> _listPrintType =
      StonePrintType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();
  final List<DropdownMenuItem<StonePrintAlign>> _listPrintAlign =
      StonePrintAlign.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();
  final List<DropdownMenuItem<StonePrintSize>> _listPrintSize =
      StonePrintSize.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();

  StonePrintType _printType = StonePrintType.line;
  StonePrintAlign? _printAlign = StonePrintAlign.center;
  StonePrintSize? _printSize = StonePrintSize.medium;

  bool _showFeedbackScreen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('impresssão'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Tipo de Impressão'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 55,
                    child: DropdownButton(
                      value: _printType,
                      items: _listPrintType,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _printType = value!;
                        if (_printType == StonePrintType.text) {
                          _printAlign = StonePrintAlign.center;
                          _printSize = StonePrintSize.medium;
                        } else {
                          _printAlign = null;
                          _printSize = null;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  if (_printType == StonePrintType.text)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Alinhamento da Impressão'),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 55,
                          child: DropdownButton(
                            value: _printAlign,
                            items: _listPrintAlign,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              _printAlign = value!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  if (_printType == StonePrintType.text)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tamanho da Impressão'),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 55,
                          child: DropdownButton(
                            value: _printSize,
                            items: _listPrintSize,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              _printSize = value!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  (_printType != StonePrintType.image)
                      ? Column(
                        children: [
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Texto para Impressão'),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _printTextEC,
                            decoration: InputDecoration(
                              hintText: 'Texto',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          Image.network(
                            'https://css-tricks.com/wp-content/uploads/2022/08/flutter-clouds.jpg',
                          ),
                        ],
                      ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showFeedbackScreen = !_showFeedbackScreen;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _showFeedbackScreen,
                          onChanged: (_) {
                            setState(() {
                              _showFeedbackScreen = !_showFeedbackScreen;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Mostrar tela de feedback",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        String? image64;
                        if (_printType == StonePrintType.image) {
                          image64 = await imageToBase64(
                            'https://css-tricks.com/wp-content/uploads/2022/08/flutter-clouds.jpg',
                          );
                        }
                        final print = StonePrintPayload(
                          printableContent: [
                            StoneContentprint(
                              type: _printType,
                              align: _printAlign,
                              content: _printTextEC.text,
                              size: _printSize,
                              imagePath: image64,
                            ),
                          ],
                          showFeedbackScreen: _showFeedbackScreen,
                        );
                        await _flutterStonePaymentPlugin.print(
                          printPayload: print,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Impressão realizada com sucesso!"),
                          ),
                        );
                      } on StonePrintException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro desconhecido')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('imprimir'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> imageToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final originalBytes = response.bodyBytes;

        // Decodifica a imagem original
        final codec = await ui.instantiateImageCodec(originalBytes);
        final frame = await codec.getNextFrame();
        final image = frame.image;

        const maxWidth = 380;
        final originalWidth = image.width;
        final originalHeight = image.height;

        // Se a largura for menor que maxWidth, usa a imagem original
        if (originalWidth <= maxWidth) {
          return base64Encode(originalBytes);
        }

        // Calcula nova altura mantendo proporção
        final ratio = maxWidth / originalWidth;
        final targetHeight = (originalHeight * ratio).round();

        // Cria nova imagem redimensionada
        final recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(recorder);

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(
            0,
            0,
            originalWidth.toDouble(),
            originalHeight.toDouble(),
          ),
          Rect.fromLTWH(0, 0, maxWidth.toDouble(), targetHeight.toDouble()),
          Paint()..filterQuality = ui.FilterQuality.high,
        );

        final picture = recorder.endRecording();
        final resizedImage = await picture.toImage(maxWidth, targetHeight);
        final byteData = await resizedImage.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData != null) {
          return base64Encode(byteData.buffer.asUint8List());
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao converter imagem para Base64: $e");
      }
      return null;
    }
  }
}
