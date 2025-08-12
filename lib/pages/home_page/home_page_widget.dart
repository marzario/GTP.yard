import '/utils/flutter_flow_animations.dart';
import '/utils/flutter_flow_theme.dart';
import '/utils/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  HomePageWidgetState createState() => HomePageWidgetState();
}

final SupabaseClient supabase = Supabase.instance.client;

class HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.0, 10.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.0, 10.0),
          end: const Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  int total = 0;

  final _future = Supabase.instance.client
      .from('Servicios')
      .select('Empresas(nombre), *')
      .neq('pagado', true)
      .order('created_at', ascending: false);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: const Color(0xFF17282E),
            automaticallyImplyLeading: false,
            title: Text(
              'INVENTARIO',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: const Color(0xFF7AA3AA),
                    //                 color: const Color(0xFF4B986C),
                    fontSize: 22.0,
                  ),
            ),
            actions: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              // DigitalClock(
              //   hourMinuteDigitTextStyle: Theme.of(context)
              //       .textTheme
              //       .headlineMedium!
              //       .copyWith(color: const Color(0xFF4B986C)),
              //   secondDigitTextStyle: Theme.of(context)
              //       .textTheme
              //       .bodySmall!
              //       .copyWith(color: const Color(0xFF4B986C)),
              //   colon: Text(
              //     ":",
              //     style: Theme.of(context)
              //         .textTheme
              //         .titleMedium!
              //         .copyWith(color: Colors.green),
              //   ),
              // ),
              IconButton(
                onPressed: () async {
                  // final gorouter = GoRouter.of(context);
                  // gorouter.pushReplacementNamed('AppRoute.placa.name');
                  context.pushNamed('AppRoute.placa.name');
                },
                icon: const Icon(Icons.search),
                color: const Color(0xFF7AA3AA),
                //   ),
                // ],
              ),

              IconButton(
                onPressed: () async {
                  final gorouter = GoRouter.of(context);
                  await supabase.auth.signOut();
                  // if (!mounted) return;
                  gorouter.pushReplacementNamed('AppRoute.login.name');
                },
                icon: const Icon(Icons.logout),
                color: const Color(0xFF7AA3AA),
                //   ),
                // ],
              ),
            ],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (responsiveVisibility(
                  context: context,
                  phone: true,
                  tablet: true,
                ))
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        15.0, 15.0, 15.0, 5.0),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final servicios = snapshot.data!;
                        total = servicios.length;
                        //print(total);
                        return ListView.builder(
                            itemCount: servicios.length,
                            itemBuilder: ((context, index) {
                              final servicio = servicios[index];
                              //print(servicio);
                              final ticket = servicio['id'];
                              DateTime tempoI =
                                  DateTime.parse(servicio['created_at'])
                                      .toLocal();
                              String fDateI = DateFormat.yMMMd().format(tempoI);
                              String fHrI = DateFormat.Hm().format(tempoI);
                              final placa = servicio['placa_tracto'];
                              final placa1 = servicio['placa1_remolque'];
                              final placa2 = servicio['placa2_remolque'];
                              final chofer = servicio['nombre_chofer'];
                              final telefono = servicio['telefono_chofer'];
                              final usuario = servicio['usuario'];
                              String smallU = usuario.substring(0, 2);
                              final empresa = (servicio['Empresas']
                                      as Map<String, dynamic>?)?['nombre'] ??
                                  ' ';

                              return Card(
                                child: ListTile(
                                  title: Text("Ticket: $ticket",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text("$fDateI  $fHrI"),
                                  trailing: const Icon(
                                    Icons.info,
                                    color: Color(0xFF7AA3AA),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text(
                                            "Detalle Ticket:  $ticket",
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color:
                                                      const Color(0xFF4B986C),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Form(
                                              child: Column(
                                                children: [
                                                  // Padding(
                                                  //   padding: EdgeInsetsDirectional.fromSTEB(
                                                  //       0.0, 0.0, 0.0, 16.0),
                                                  //   child: SizedBox()
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Entrada: $fDateI  $fHrI"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Placa Tracto: $placa"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Placa Remolque 1: $placa1"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Placa Remolque 2: $placa2"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Nombre Chofer:  $chofer"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Teléfono Chofer:  $telefono"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Capturó:  $smallU"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                            0.0, 16.0),
                                                    child: SizedBox(
                                                      width: 370.0,
                                                      child: Text(
                                                          "Empresa:  $empresa"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                final gorouter =
                                                    GoRouter.of(context);
                                                gorouter.pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF4B986C)),
                                              child: const Text("Salir"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            }));
                      },
                    ),
                  )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7AA3AA),
                      // fixedSize: Size.fromWidth(150.00),
                    ),
                    onPressed: () {
                      setState(() {
                        context.pushReplacementNamed('AppRoute.home.name');
                      });
                    },
                    child: Text(
                      "Actualizar ($total)",
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
