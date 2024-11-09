# AppTelecomandoPC

Applicazione mobile Flutter che consente di controllare da remoto un PC Windows attraverso la rete locale. Questa app funziona in combinazione con [ServerTelecomandoPC](https://github.com/riccardo-florio/PCPC), l'applicazione server da installare sul PC.

## Funzionalità

- **Controllo del Volume**: Aumenta o diminuisci il volume del PC direttamente dal tuo dispositivo mobile.
- **Navigazione Direzionale**: Simula i tasti direzionali (su, giù, sinistra, destra) per navigare nelle presentazioni o nelle applicazioni.
- **Riproduzione Multimediale**: Metti in play o in pausa i contenuti multimediali sul tuo PC.
- **Spegnimento Programmato**: Pianifica lo spegnimento del PC con un semplice comando dall'app mobile.
- **Scoperta Automatica del Server**: L'app rileva automaticamente il server sulla rete locale, semplificando la configurazione.

## Requisiti

- **Dispositivo Mobile**: Smartphone Android con versione minima Android 5.0 (Lollipop).
- **Connessione di Rete**: Il dispositivo mobile e il PC devono essere connessi alla stessa rete locale (Wi-Fi).

## Installazione

1. **Download dell'APK**

   Scarica l'APK dell'app dalla sezione [Releases](https://github.com/riccardo-florio/AppTelecomandoPC/releases).

2. **Installazione Manuale**

   - Assicurati che l'opzione "Origini sconosciute" sia abilitata nelle impostazioni del tuo dispositivo.
   - Apri il file APK scaricato e segui le istruzioni per installare l'app.

3. **Configurazione del Server**

   - Scarica e avvia [ServerTelecomandoPC](https://github.com/riccardo-florio/ServerTelecomandoPC/releases) sul tuo PC Windows.
   - Assicurati che il firewall del PC permetta le connessioni in entrata sulla porta utilizzata dall'applicazione.

## Utilizzo

1. **Avvia l'app "telecomando"** sul tuo dispositivo mobile.
2. **Attendi la Scoperta del Server**: L'app cercherà automaticamente il server sulla rete locale.
3. **Controlla il PC**: Utilizza l'interfaccia dell'app per inviare comandi al PC.

## Sviluppo

Se desideri contribuire allo sviluppo dell'app o compilare il progetto da solo, segui questi passaggi:

### Clonare il Progetto

```shell
git clone https://github.com/tuo-username/AppTelecomando.git
```

### Installare Flutter

Assicurati di avere Flutter installato sul tuo sistema. Segui le istruzioni ufficiali per l'installazione:

- [Installazione di Flutter](https://docs.flutter.dev/get-started/install)

### Eseguire l'App

1. **Naviga nella directory del progetto**

   ```shell
   cd AppTelecomando
   ```

2. **Installa le dipendenze**

   ```shell
   flutter pub get
   ```

3. **Esegui l'app su un dispositivo o emulatore connesso**

   ```shell
   flutter run
   ```

### Aggiornare l'icona dell'app

Per personalizzare l'icona dell'app, segui questo [Tutorial](https://www.youtube.com/watch?v=oRBWPm7nCV0).

## Note Importanti

- **Permessi di Rete**: L'app richiede l'accesso alla rete locale per comunicare con il server.
- **Compatibilità**: Attualmente, l'app è disponibile solo per dispositivi Android. Il supporto per iOS non è ancora implementato.
- **Sicurezza**: Assicurati di scaricare l'app solo da fonti affidabili per evitare rischi alla sicurezza.

## Contribuire

Le contribuzioni sono benvenute! Sentiti libero di aprire issue o pull request per migliorare l'app.

## Licenza

Questo progetto è distribuito sotto la licenza MIT. Vedi il file [LICENSE](LICENSE) per maggiori dettagli.
