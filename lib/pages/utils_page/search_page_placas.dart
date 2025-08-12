import 'package:flutter/material.dart';
import '/utils/flutter_flow_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class SearchPagePlacas extends StatefulWidget {
  const SearchPagePlacas({super.key, required this.placa});
  final String placa;

  @override
  State<SearchPagePlacas> createState() => _SearchPagePlacasState();
}

final SupabaseClient supabase = Supabase.instance.client;
final usuario = supabase.auth.currentUser;
final email = usuario!.email;

class _SearchPagePlacasState extends State<SearchPagePlacas> {
  var nombrePlaca = "";
  var placa1 = "";
  var placa2 = "";
  var id = 0;

//   Future readData() async {
//     try {
//       final data = await supabase
// .from('Servicios')
//           .select()
//           .eq('placa_tracto', "96AS7U")
//           .neq('pagado', true);
//       setState(() {
//       nombrePlaca = widget.placa;
//       });
//       print(data);
//     } catch (e) {
//       var snackBar = SnackBar(content: Text('Error BD: $e'));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }

  @override
  void initState() {
    super.initState();
    //readData();
  }

  @override
  Widget build(BuildContext context) {
    // final data = supabase
    //     .from('Servicios')
    //     .select()
    //     .eq(
    //       'placa_tracto',
    //       widget.placa,
    //     )
    //     .eq('pagado', false);
    final searchTerm = widget.placa; // Replace with your actual search term

    final data = supabase
        .from('Servicios')
        .select('Empresas(nombre), *')
//        .or('placa1_remolque.eq.$searchTerm,placa2_remolque.eq.$searchTerm')
        .or('placa1_remolque.ilike.%$searchTerm%,placa2_remolque.ilike.%$searchTerm%,placa_tracto.ilike.%$searchTerm%')
        .eq('pagado', false)
        .order('id', ascending: false);
    nombrePlaca = widget.placa;
    return Scaffold(
      appBar: AppBar(
        //     automaticallyImplyLeading: true,
        leading: const BackButton(color: Color(0xFF7AA3AA)),
        backgroundColor: const Color(0xFF17282E),
        title: Text(
          'Placa:  $nombrePlaca',
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
        padding: const EdgeInsetsDirectional.fromSTEB(25.0, 25.0, 25.0, 25.0),
        child: FutureBuilder<dynamic>(
          future: data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final servicios = snapshot.data!;
            if (servicios.isNotEmpty) {
              return ListView.builder(
                  itemCount: servicios.length,
                  itemBuilder: ((context, index) {
                    final servicio = servicios[index];
                    final ticket = servicio['id'];
                    DateTime tempoI =
                        DateTime.parse(servicio['created_at']).toLocal();
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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0xFF4B986C),
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
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child:
                                                Text("Entrada: $fDateI  $fHrI"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text("Placa Tracto: $placa"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text(
                                                "Placa Remolque 1: $placa1"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text(
                                                "Placa Remolque 2: $placa2"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child:
                                                Text("Nombre Chofer:  $chofer"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text(
                                                "Teléfono Chofer:  $telefono"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text("Capturó:  $smallU"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 16.0),
                                          child: SizedBox(
                                            width: 370.0,
                                            child: Text("Empresa:  $empresa"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      final gorouter = GoRouter.of(context);
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
            } else {
              return Center(
                child: Text(
                  "Información no encontrada",
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: const Color(0xFF7AA3AA),
                        fontSize: 22.0,
                      ),
                ),
              );
            }
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   backgroundColor: const Color(0xFF7AA3AA),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
