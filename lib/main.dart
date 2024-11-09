import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(RemoteControlApp());
}

class RemoteControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telecomando',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: ControlPage(title: 'Telecomando'),
    );
  }
}

class ControlPage extends StatefulWidget {
  ControlPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String? serverIp;
  final int serverPort = 65432; // Porta per i comandi
  final int discoveryPort = 65433; // Porta per la scoperta

  @override
  void initState() {
    super.initState();
    discoverServer();
  }

  void discoverServer() async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      socket.broadcastEnabled = true;
      socket.send(
        'DISCOVERY_REQUEST'.codeUnits,
        InternetAddress('255.255.255.255'),
        discoveryPort,
      );

      // Imposta un timeout di 5 secondi
      Timer(Duration(seconds: 5), () {
        if (serverIp == null) {
          setState(() {
            // Imposta uno stato per indicare che il server non è stato trovato
            serverIp = 'not_found';
          });
          socket.close();
        }
      });

      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = socket.receive();
          if (dg != null) {
            String message = String.fromCharCodes(dg.data);
            if (message == 'DISCOVERY_RESPONSE') {
              setState(() {
                serverIp = dg.address.address;
              });
              print('Server trovato all\'indirizzo: $serverIp');
              socket.close();
            }
          }
        }
      }, onDone: () {
        if (serverIp == null) {
          setState(() {
            serverIp = 'not_found';
          });
        }
      }, onError: (error) {
        print('Errore durante la scoperta: $error');
        setState(() {
          serverIp = 'not_found';
        });
      });
    });
  }

  void sendCommand(String command) async {
    if (serverIp == null || serverIp == 'not_found') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server non disponibile.')),
      );
      return;
    }
    try {
      RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
        bool responseReceived = false;
        socket.send(command.codeUnits, InternetAddress(serverIp!), serverPort);

        // Imposta un timeout di 5 secondi per la risposta
        Timer(Duration(seconds: 5), () {
          if (!responseReceived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nessuna risposta dal server.')),
            );
            socket.close();
            attemptReconnect();
          }
        });

        socket.listen((event) {
          if (event == RawSocketEvent.read) {
            Datagram? dg = socket.receive();
            if (dg != null) {
              String response = String.fromCharCodes(dg.data);
              print('Risposta dal server: $response');
              responseReceived = true;
              // Mostra un messaggio all'utente
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response)),
              );
              socket.close();
            }
          }
        }, onDone: () {
          if (!responseReceived) {
            attemptReconnect();
          }
        }, onError: (error) {
          print('Errore durante l\'invio del comando: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore: $error')),
          );
          attemptReconnect();
        });
      });
    } catch (e) {
      print('Errore durante l\'invio del comando: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
      attemptReconnect();
    }
  }

  void attemptReconnect() {
    setState(() {
      serverIp = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tentativo di riconnessione al server...')),
    );
    discoverServer();
  }

  Widget buildButton(
      {required String label,
      required String command,
      IconData? icon,
      double size = 80}) {
    return ElevatedButton(
      onPressed: () {
        sendCommand(command);
      },
      child: icon != null
          ? Icon(icon, size: 36)
          : Text(label, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size, size),
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (serverIp == null) {
      // Mostra schermata di caricamento
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ricerca del server in corso...',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    } else if (serverIp == 'not_found') {
      // Mostra messaggio di errore e bottone per riprovare
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Server non trovato.\nVerifica la connessione e riprova.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      serverIp = null;
                    });
                    discoverServer();
                  },
                  child: Text('Riprova'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Interfaccia principale dell'app dopo aver trovato il server
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - $serverIp'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsante Spegnimento
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(
                      label: 'Spegni',
                      command: 'spegni',
                      icon: Icons.power_settings_new,
                      size: 60,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Pulsante Su
                buildButton(
                  label: 'Su',
                  command: 'su',
                  icon: Icons.arrow_drop_up,
                ),
                SizedBox(height: 20),
                // Riga centrale con Sinistra e Destra
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pulsante Sinistra
                    buildButton(
                      label: 'Sinistra',
                      command: 'sinistra',
                      icon: Icons.arrow_left,
                    ),
                    SizedBox(width: 20),
                    // Pulsante Play/Pausa
                    buildButton(
                      label: 'Play/Pausa',
                      command: 'play_pause',
                      icon: Icons.play_arrow,
                      size: 60,
                    ),
                    SizedBox(width: 20),
                    // Pulsante Destra
                    buildButton(
                      label: 'Destra',
                      command: 'destra',
                      icon: Icons.arrow_right,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Pulsante Giù
                buildButton(
                  label: 'Giù',
                  command: 'giu',
                  icon: Icons.arrow_drop_down,
                ),
                SizedBox(height: 30),
                // Pulsanti Volume
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pulsante Volume Giù
                    buildButton(
                      label: 'Volume Giù',
                      command: 'volume_giu',
                      icon: Icons.volume_down,
                    ),
                    SizedBox(width: 20),
                    // Pulsante Volume Su
                    buildButton(
                      label: 'Volume Su',
                      command: 'volume_su',
                      icon: Icons.volume_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
