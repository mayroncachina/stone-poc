import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/stone_reprint_type.dart';
import 'package:flutter_stone_payment/exceptions/stone_reprint_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/stone_reprint_payload.dart';

class ReprintPage extends StatefulWidget {
  const ReprintPage({super.key});

  @override
  State<ReprintPage> createState() => _ReprintPageState();
}

class _ReprintPageState extends State<ReprintPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _atkEC = TextEditingController();
  final List<DropdownMenuItem<StoneTypeCustomer>> _listTypeCustomer =
      StoneTypeCustomer.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList();

  StoneTypeCustomer _typeCustomer = StoneTypeCustomer.MERCHANT;

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
          title: Text('Reimprimir'),
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
                      value: _typeCustomer,
                      items: _listTypeCustomer,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _typeCustomer = value!;
                        setState(() {});
                      },
                    ),
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
                        final reprint = StoneReprintPayload(
                          atk: _atkEC.text,
                          typeCustomer: _typeCustomer,
                          showFeedbackScreen: _showFeedbackScreen,
                        );
                        await _flutterStonePaymentPlugin.reprint(
                          reprintPayload: reprint,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Impressão realizada com sucesso!"),
                          ),
                        );
                      } on StoneReprintException catch (e) {
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
                    child: Text('Reimprimir'),
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
