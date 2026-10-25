import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AutoScrollApp());
}

class AutoScrollApp extends StatelessWidget {
  const AutoScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoScroll Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        colorScheme: ColorScheme.dark(
          primary: Colors.purpleAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const ControlPanelScreen(),
    );
  }
}

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({super.key});

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  static const platform = MethodChannel('com.autoscroll/accessibility');
  bool isRunning = false;
  double tempoMedio = 8.0;

  Future<void> _toggleAutomation(bool start) async {
    try {
      if (start) {
        await platform.invokeMethod('startService', {'delay': (tempoMedio * 1000).toInt()});
        setState(() { isRunning = true; });
      } else {
        await platform.invokeMethod('stopService');
        setState(() { isRunning = false; });
      }
    } on PlatformException catch (e) {
      print("Erro ao acionar serviço: ${e.message}");
      _mostrarAlertaAcessibilidade();
    }
  }

  void _mostrarAlertaAcessibilidade() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ativar Acessibilidade'),
        content: const Text('Para o app rolar os vídeos automaticamente, você precisa ativar o AutoScroll Pro nas Configurações de Acessibilidade do seu Android.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendi'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoScroll Pro - Kwai & TikTok'),
        backgroundColor: Colors.purple.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('Status do Sistema', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    isRunning ? 'EM EXECUÇÃO (Anti-Ban Ativo)' : 'PARADO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isRunning ? Colors.greenAccent : Colors.amberAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tempo Médio por Vídeo: ${tempoMedio.toInt()} segundos', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Slider(
              value: tempoMedio,
              min: 4,
              max: 20,
              divisions: 16,
              activeColor: Colors.purpleAccent,
              onChanged: (val) {
                setState(() { tempoMedio = val; });
              },
            ),
            const Text(
              'O app aplica variação inteligente (Jitter) automaticamente para proteger sua conta.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _toggleAutomation(!isRunning),
              icon: Icon(isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 28),
              label: Text(
                isRunning ? 'PARAR AUTOMAÇÃO' : 'INICIAR AUTOMAÇÃO',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.red.shade700 : Colors.purple.shade700,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
