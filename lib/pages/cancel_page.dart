import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';
import 'package:flutter_stone_payment/exceptions/stone_cancel_exception.dart';
import 'package:flutter_stone_payment/exceptions/stone_print_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/stone_cancel_payload.dart';
import 'package:flutter_stone_payment/models/stone_content_print.dart';
import 'package:flutter_stone_payment/models/stone_print_payload.dart';

class CancelPage extends StatefulWidget {
  const CancelPage({super.key});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _amountEC = TextEditingController();
  final _atkEC = TextEditingController();

  String _responseCancel = "";
  bool _editableAmount = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('cancelar'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Valor')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(
                      hintText: 'Valor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Identificação do pagamento'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _atkEC,
                    decoration: InputDecoration(
                      hintText: 'ATK',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _editableAmount = !_editableAmount;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _editableAmount,
                          onChanged: (_) {
                            setState(() {
                              _editableAmount = !_editableAmount;
                            });
                          },
                        ),
                        Text("Valor Editável", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Text(_responseCancel),
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
                        _responseCancel = "SEM RESPOSTA";
                        double? amount = double.tryParse(_amountEC.text);
                        final cancel = StoneCancelPayload(
                          amount: amount,
                          atk: _atkEC.text,
                          editableAmount: _editableAmount,
                        );
                        final response = await _flutterStonePaymentPlugin
                            .cancel(cancelPayload: cancel);
                        _responseCancel = response.toJson().toString();
                        final print = StonePrintPayload(
                          printableContent: [
                            StoneContentprint(
                              type: StonePrintType.text,
                              align: StonePrintAlign.center,
                              size: StonePrintSize.big,
                              content:
                                  "Cancelamento Simulado\n\n${response.toJson().toString()}",
                            ),
                          ],
                          showFeedbackScreen: false,
                        );
                        await _flutterStonePaymentPlugin.print(
                          printPayload: print,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Simulacao Cancelamento e Impressão realizada com sucesso! $cancel",
                            ),
                          ),
                        );
                      } on StoneCancelException catch (e) {
                        _responseCancel = e.message;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } on StonePrintException catch (e) {
                        _responseCancel = e.message;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Simulação de pagamento realizado mas erro na impressão: ${e.message}",
                            ),
                          ),
                        );
                      } catch (e) {
                        _responseCancel = "Erro desconhecido";
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro desconhecido')),
                        );
                      } finally {
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Continuar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
