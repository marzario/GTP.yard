import '/utils/flutter_flow_animations.dart';
import '/utils/flutter_flow_theme.dart';
import '/utils/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
//import 'dart:io';

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

  late Future<List<Map<String, dynamic>>> _future;

  Future<List<Map<String, dynamic>>> _loadData() async {
    return await Supabase.instance.client
        .from('Servicios')
        .select('Empresas(nombre), *')
        .neq('pagado', true)
        .order('created_at', ascending: false);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _future = _loadData(); // Initialize the future

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
                        //print(total);
                        return RefreshIndicator(
                          onRefresh: () async {
                            // Create a new future to force fresh data
                            setState(() {
                              _future = _loadData();
                            });
                            // Add a small delay for better UX
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            // Show success feedback
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Inventario actualizado'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Color(0xFF7AA3AA),
                                ),
                              );
                            }
                          },
                          child: ListView.separated(
                            itemCount: servicios.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8.0),
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> servicio =
                                  servicios[index];
                              final int ticket = servicio['id'];
                              DateTime tempoI =
                                  DateTime.parse(servicio['created_at'])
                                      .toLocal();
                              String fDateI = DateFormat.yMMMd().format(tempoI);
                              String fHrI = DateFormat.Hm().format(tempoI);
                              final String placa =
                                  servicio['placa_tracto'] ?? '';
                              final String placa1 =
                                  servicio['placa1_remolque'] ?? '';
                              final bool isShow1 = placa1.isNotEmpty;
                              final String placa2 =
                                  servicio['placa2_remolque'] ?? '';
                              final bool isShow2 = placa2.isNotEmpty;
                              final String chofer =
                                  servicio['nombre_chofer'] ?? '';
                              final String telefono =
                                  servicio['telefono_chofer'] ?? '';
                              final String usuario = servicio['usuario'] ?? '';
                              final String smallU = usuario.length >= 2
                                  ? usuario.substring(0, 2)
                                  : usuario;
                              final String empresa = (servicio['Empresas']
                                      as Map<String, dynamic>?)?['nombre'] ??
                                  '';
                              final bool isShow3 =
                                  servicio['mecanico'] ?? false;

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return DraggableScrollableSheet(
                                            initialChildSize: 0.6,
                                            minChildSize: 0.3,
                                            maxChildSize: 0.9,
                                            builder:
                                                (context, scrollController) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      width: 40.0,
                                                      height: 4.0,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                      0xFF4B986C)
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .confirmation_number,
                                                              color: Color(
                                                                  0xFF4B986C),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 12.0),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Ticket: $ticket",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        color: const Color(
                                                                            0xFF4B986C),
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  "Detalle del servicio",
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        color: Colors
                                                                            .grey[600],
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        controller:
                                                            scrollController,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child: Column(
                                                            children: [
                                                              _buildDetailCard(
                                                                icon: Icons
                                                                    .schedule,
                                                                title:
                                                                    "Entrada",
                                                                value:
                                                                    "$fDateI  $fHrI",
                                                                context:
                                                                    context,
                                                              ),
                                                              _buildDetailCard(
                                                                icon: Icons
                                                                    .local_shipping,
                                                                title:
                                                                    "Placa Tracto",
                                                                value: placa,
                                                                context:
                                                                    context,
                                                              ),
                                                              if (isShow1)
                                                                _buildDetailCard(
                                                                  icon: Icons
                                                                      .rv_hookup,
                                                                  title:
                                                                      "Placa Remolque 1",
                                                                  value: placa1,
                                                                  context:
                                                                      context,
                                                                ),
                                                              if (isShow2)
                                                                _buildDetailCard(
                                                                  icon: Icons
                                                                      .rv_hookup,
                                                                  title:
                                                                      "Placa Remolque 2",
                                                                  value: placa2,
                                                                  context:
                                                                      context,
                                                                ),
                                                              _buildDetailCard(
                                                                icon: Icons
                                                                    .person,
                                                                title:
                                                                    "Nombre Chofer",
                                                                value: chofer,
                                                                context:
                                                                    context,
                                                              ),
                                                              _buildDetailCard(
                                                                icon:
                                                                    Icons.phone,
                                                                title:
                                                                    "Teléfono Chofer",
                                                                value: telefono,
                                                                context:
                                                                    context,
                                                              ),
                                                              _buildDetailCard(
                                                                icon: Icons
                                                                    .person_outline,
                                                                title:
                                                                    "Capturó",
                                                                value: smallU,
                                                                context:
                                                                    context,
                                                              ),
                                                              _buildDetailCard(
                                                                icon: Icons
                                                                    .business,
                                                                title:
                                                                    "Empresa",
                                                                value: empresa,
                                                                context:
                                                                    context,
                                                              ),
                                                              if (isShow3)
                                                                _buildDetailCard(
                                                                  icon: Icons
                                                                      .build,
                                                                  title:
                                                                      "Servicio",
                                                                  value:
                                                                      "Mecánicos",
                                                                  context:
                                                                      context,
                                                                ),
                                                              const SizedBox(
                                                                  height:
                                                                      100.0),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48.0,
                                            height: 48.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF7AA3AA)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: const Icon(
                                              Icons
                                                  .confirmation_number_outlined,
                                              color: Color(0xFF7AA3AA),
                                              size: 24.0,
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Ticket: $ticket",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  "$fDateI  $fHrI",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  "Tracto: $placa",
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey[400],
                                            size: 16.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _future,
                  builder: (context, snapshot) {
                    final int currentTotal =
                        snapshot.hasData ? snapshot.data!.length : 0;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7AA3AA),
                        // fixedSize: Size.fromWidth(150.00),
                      ),
                      onPressed: () {
                        setState(() {
                          _future = _loadData();
                        });
                      },
                      child: Text(
                        "Unidades: $currentTotal",
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF7AA3AA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7AA3AA),
              size: 20.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
