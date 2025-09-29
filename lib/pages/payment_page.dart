import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/stone_installment_type.dart';
import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';
import 'package:flutter_stone_payment/constants/stone_transaction_type.dart';
import 'package:flutter_stone_payment/exceptions/stone_payment_exception.dart';
import 'package:flutter_stone_payment/exceptions/stone_print_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/stone_content_print.dart';
import 'package:flutter_stone_payment/models/stone_payment_payload.dart';
import 'package:flutter_stone_payment/models/stone_print_payload.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _amountEC = TextEditingController();
  final _qtdEC = TextEditingController();
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final List<DropdownMenuItem<StoneTransactionType?>> _listTypes =
      StoneTransactionType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();
  final List<DropdownMenuItem<StoneInstallmentType?>> _listInstallmentType =
      StoneInstallmentType.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();
  StoneTransactionType? _transactionType;
  StoneInstallmentType? _transactionInstallmentType;

  bool _editableAmount = false;

  @override
  void initState() {
    super.initState();
    _listTypes.add(
      DropdownMenuItem<StoneTransactionType>(
        value: null,
        child: Text('NENHUM'),
      ),
    );
    _listInstallmentType.add(
      DropdownMenuItem<StoneInstallmentType>(
        value: null,
        child: Text('NENHUM'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('pagamento'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Tipo do Pagamento'),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 55,
                    child: DropdownButton(
                      value: _transactionType,
                      items: _listTypes,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _transactionInstallmentType = null;
                        _qtdEC.text = '';
                        _transactionType = value;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
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
                  // if (_transactionType == StoneTransactionType.CREDIT)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('tipo parcelamento'),
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
                                  value: _transactionInstallmentType,
                                  items: _listInstallmentType,
                                  isExpanded: true,
                                  underline: Container(),
                                  onChanged: (value) {
                                    _transactionInstallmentType = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Qtd parcelamento'),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _qtdEC,
                                decoration: InputDecoration(
                                  hintText: 'Qtd parcelamento',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                        double? amount = double.tryParse(_amountEC.text);
                        int? qtdPar = int.tryParse(_qtdEC.text);
                        final payment = StonePaymentPayload(
                          amount: amount,
                          transactionType: _transactionType,
                          orderId: Random().nextInt(1000).toString(),
                          installmentCount: qtdPar,
                          installmentType: _transactionInstallmentType,
                          editableAmount: _editableAmount,
                        );
                        final response = await _flutterStonePaymentPlugin.pay(
                          paymentPayload: payment,
                        );
                        debugPrint(response.toJson().toString());
                        final print = StonePrintPayload(
                          printableContent: [
                            StoneContentprint(
                              type: StonePrintType.line,
                              content: response.toJson().toString(),
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
                              "Simulacao pagamento e Impressão realizada com sucesso!",
                            ),
                          ),
                        );
                      } on StonePaymentException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } on StonePrintException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Simulação de pagamento realizado mas erro na impressão: ${e.message}",
                            ),
                          ),
                        );
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
                    child: Text('Pagar'),
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
