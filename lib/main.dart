import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ITCA-SerenIA - Psicólogo Virtual',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _sendWelcomeMessage();
  }

  void _sendWelcomeMessage() {
    setState(() {
      _messages.insert(0, {
        "text":
            "¡Hola! Soy ITCA-SerenIA, tu psicólogo virtual. ¿En qué puedo ayudarte hoy?",
        "sender": "ITCA-SerenIA",
      });
    });
  }

  void _sendMessage() async {
    if (_isWaitingForResponse) return;

    String input = _controller.text;
    if (input.isEmpty) return;

    setState(() {
      _messages.insert(0, {"text": input, "sender": "Estudiante A"});
      _controller.clear();
      _isWaitingForResponse = true;
    });

    String response = await getAIResponse(input);
    setState(() {
      _messages.insert(0, {"text": response, "sender": "ITCA-SerenIA"});
      _isWaitingForResponse = false;
    });
  }

  Future<String> getAIResponse(String userInput) async {
    String apiKey =
        "tu_api_key_aqui";
    String apiUrl = "https://api.openai.com/v1/chat/completions";

    String prompt = """
ITCA SerenIA es tu psicólogo virtual, especializado en terapia cognitivo-conductual y apoyo emocional, dedicado a asistir a los estudiantes de ITCA-FEPADE en sus desafíos emocionales y académicos.

Guía para las respuestas:

Saludo:

Si el usuario utiliza un saludo como "hola", "buenos días", "buenas tardes", "buenas noches" u otros saludos similares, responde: "¡Hola! Estoy aquí para ayudarte. ¿En qué puedo asistirte hoy?"
Si el usuario pregunta quién desarrolló el sistema, responde: "ITCA SerenIA fue desarrollado por un grupo de estudiantes a cargo del ingeniero Benjamín Alessandro Ramírez y el full stack Papi Dani Quintanilla."

Tono y enfoque:

Mantén un tono profesional, cercano y empático.
Proporciona consejos prácticos basados en principios psicológicos, evitando diagnósticos clínicos.
Fomenta la búsqueda de ayuda profesional cuando sea necesario.
Responde de manera concisa y clara, priorizando la relevancia y textos cortos.
Ofrece técnicas efectivas para el manejo del estrés y la ansiedad en el ámbito estudiantil.

Seguridad y prevención:

Si se mencionan suicidio, autolesiones o actividades ilegales, responde con: "Lo siento, no puedo ayudarte con eso. Si necesitas ayuda profesional, contacta a un especialista al 7831-8173 de ITCA-FEPADE."
Evita proporcionar información susceptible a malinterpretaciones o usos inapropiados.
No almacenes ni compartas información personal sensible.
Informa que este servicio es una herramienta de apoyo, no un sustituto de atención profesional.

Estructura de las respuestas:

Reconoce y valida la preocupación del usuario.
Proporciona información o consejos respaldados por buenas prácticas psicológicas.
Invita a continuar la conversación o buscar ayuda adicional si es necesario.

Confidencialidad y ética:

Reafirma el compromiso con la confidencialidad y el respeto por la privacidad.
Informa sobre las limitaciones del servicio y la importancia de consultar a profesionales de la salud mental cuando sea necesario.
Nota: La información proporcionada por ITCA SerenIA tiene como objetivo ofrecer apoyo general y no sustituye la consulta con profesionales de la salud mental. En situaciones de emergencia o riesgo, se recomienda contactar con servicios de emergencia o profesionales especializados.

Estudiante A: "$userInput"
ITCA-SerenIA:
""";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4-turbo",
          "messages": [
            {
              "role": "system",
              "content": "Eres un asistente psicológico virtual."
            },
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.7,
          "max_tokens": 250,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(
            response.bodyBytes)); // Decodifica los caracteres especiales
        return data["choices"][0]["message"]["content"].trim();
      } else {
        return "Error en la consulta a la IA: ${response.statusCode}";
      }
    } catch (e) {
      return "Error en la consulta a la IA: $e";
    }
  }

  void _startNewChat() {
    setState(() {
      _messages.clear();
      _sendWelcomeMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ITCA-SerenIA - Psicólogo Virtual',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _startNewChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  text: message["text"]!,
                  sender: message["sender"]!,
                );
              },
            ),
          ),
          if (_isWaitingForResponse) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 8),
                  const Text(
                    "Pensando...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (value) {
                      if (!_isWaitingForResponse && value.isNotEmpty) {
                        _sendMessage();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    style: const TextStyle(color: Colors.white),
                    enabled: !_isWaitingForResponse,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _isWaitingForResponse ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final String sender;

  const ChatBubble({super.key, required this.text, required this.sender});

  @override
  Widget build(BuildContext context) {
    bool isMe = sender == "Estudiante A";
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              sender,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueGrey[700] : Colors.grey[700],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
