import 'package:flutter/material.dart';
import '/utils/flutter_flow_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ExitPage extends StatefulWidget {
  const ExitPage({super.key});

  @override
  State<ExitPage> createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _ticketController = TextEditingController();

  Future readDataTurno() async {
    final gorouter = GoRouter.of(context);
    final usuario = supabase.auth.currentUser;
    final user = usuario?.email ?? '';
    try {
      final data = await supabase
          .from('Turnos')
          .select()
          .eq('usuario', user)
          .filter('folio_termino', 'is', null)
          .order('id', ascending: false)
          .limit(1);
      List datos = data[0].values.toList();
      //print(datos[0]);
    } catch (e) {
      gorouter.pushReplacementNamed('AppRoute.home.name');
      //var snackBar = SnackBar(content: Text('Error BD: $e'));
      var snackBar = SnackBar(content: Text('Favor de Iniciar Turno'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    readDataTurno();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //     automaticallyImplyLeading: true,
        leading: const BackButton(color: Color(0xFF7AA3AA)),
        backgroundColor: const Color(0xFF17282E),
        title: Text(
          'Registrar Salida',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: const Color(0xFF7AA3AA),
                fontSize: 22.0,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await supabase.auth.signOut();
                Future.delayed(const Duration(milliseconds: 1500), () {
                  exit(0);
                });
              },
              icon: const Icon(Icons.logout),
              color: const Color(0xFF7AA3AA)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                child: SizedBox(
                  width: 370.0,
                  child: TextFormField(
                    controller: _ticketController,
                    autofocus: true,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Ticket número',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF7AA3AA),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      final String servicioId = _ticketController.text;
                      context.pushNamed('AppRoute.checkout.name',
                          pathParameters: {'servicioId': servicioId});
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7AA3AA),
                        // fixedSize: Size.fromWidth(150.00),
                      ),
                      onPressed: () {
                        if (_ticketController.text.isEmpty) {
                          return;
                        }
                        final String servicioId = _ticketController.text;
                        context.pushNamed('AppRoute.checkout.name',
                            pathParameters: {'servicioId': servicioId});
                      },
                      child: const Text(
                        "Buscar",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
